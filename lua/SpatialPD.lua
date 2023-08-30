local payoff = {
    cooperate    = {cooperate = 1,   noncooperate = 0},
    noncooperate = {cooperate = 1.88, noncooperate = 0}
}

--- Implementation of a Spatial Prisoner's Dilemma model, proposed by
-- Nowak and Sigmund, using an agent-based model. In this model,
-- each Agent has a strategy and plays a non-cooperative
-- game with its neighbors. Then it updates its strategy with the
-- most successful one among its neighbors. This simple spatial game
-- produces a very complex spatial dynamics such as kaleidoscopes and
-- dynamic fractals. Implemented by Pedro R. Andrade and Luiz Gabriel da Silva. \
-- Reference: Nowak and Sigmund (2004) Evolutionary Dynamics of
-- Biological Games, Science 303(5659):793-799.
-- @arg data.dim Space dimensions. A number with 101 as default value.
-- @arg data.finalTime Final simulation time. A number with 200 as default value.
-- @image spd.png
SpatialPD = Model{
    finalTime = 200,
    dim = 101,
    init = function(model)
        model.cell = Cell{
            state = function(cell)
                return cell:getAgent().strategy
            end
        }

        model.cs = CellularSpace{
            instance = model.cell,
            xdim = model.dim
        }

        model.cs:createNeighborhood{self = true}

        model.agent = Agent{
            strategy = "cooperate", -- Random{cooperate = 0.9, noncooperate = 0.1},
            newRound = function(agent)
                if agent.strategy == "newcooperate" then agent.strategy = "cooperate" end
                if agent.strategy == "newnoncooperate" then agent.strategy = "noncooperate" end
                agent.payoff = 0
            end,
            play = function(agent)
                forEachNeighbor(agent:getCell(), function(neighbor)
                    local agent_n = neighbor:getAgent()
                    agent.payoff = agent.payoff + payoff[agent.strategy][agent_n.strategy]
                end)
            end,
            findBestStrategy = function(agent)
                local bestPayoff = agent.payoff
                agent.bestStrategy = agent.strategy

                forEachNeighbor(agent:getCell(), function(neighbor)
                    local agent_n = neighbor:getAgent()

                    if agent_n.payoff > bestPayoff then
                        bestPayoff = agent_n.payoff
                        agent.bestStrategy = agent_n.strategy
                    end
                end)
            end,
            updateStrategy = function(agent)
                if agent.bestStrategy ~= agent.strategy then
                    if agent.bestStrategy == "cooperate" then
                        agent.strategy = "newcooperate"
                    else -- bestStrategy == "noncooperate"
                        agent.strategy = "newnoncooperate"
                    end
                end
            end
        }

        model.society = Society{
            instance = model.agent,
            quantity = model.dim * model.dim
        }

        model.env = Environment{
            model.cs,
            model.society
        }

        model.env:createPlacement{strategy = "uniform"}

        local middle = math.floor(model.dim / 2)
        model.cs:get(middle, middle):getAgent().strategy = "noncooperate"

        model.map = Map{
            target = model.cs,
            select = "state",
            value = {"cooperate", "noncooperate", "newcooperate", "newnoncooperate"},
            grid = true,
            color = {"blue", "red", "yellow", "green"}
        }

        model.timer = Timer{
            Event{action = model.map},
            Event{action = function()
                model.society:newRound()
                model.society:play()
                model.society:findBestStrategy()
                model.society:updateStrategy()
            end}
        }
    end
}
