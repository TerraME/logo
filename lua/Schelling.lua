--- Schelling's segregation model. In 1971, the American economist Thomas Schelling created 
-- an agent-based model that might help explain why segregation is so difficult to combat.
-- His model of segregation showed that even when individuals (or "agents") didn't mind being
-- surrounded or living by agents of a different race, they would still choose to segregate
-- themselves from other agents over time! Although the model is quite simple, it gives a
-- fascinating look at how individuals might self-segregate, even when they have no explicit
-- desire to do so. A small preference for one's neighbors to be of the same color could lead
-- to total segregation. In Schellinga model, initially black and white families are randomly
-- distributed. At each step in the modeling process the families examine their immediate
-- neighborhood and either stay put or move elsewhere depending on whether the local racial
-- composition suits their preferences. The procedure is repeated until everyone finds a
-- satisfactory home (or until the simulator’s patience is exhausted).
-- @arg data.dim The x and y dimensions of space. The default value is 25.
-- @arg data.freeSpace The percentage of space that is not filled with any agent
-- along the simulation. The default value is 25.
-- @arg data.preference What is the minimum number of neighbor agents be like me
-- that makes me satisfied with my current cell? The default value is 3.
-- @arg data.finalTime The final simulation time. The default value is 500.
Schelling = Model{
	finalTime  = Choice{min = 10,   default = 500},
	freeSpace  = Choice{min = 0.05, max = 0.20, step = 0.05},
	dim        = Choice{min =   25, max =   40, step =    5},
	preference = Choice{min =    3, max =    6, step =    1},
	random = true,
	init = function (model)
		-- determine the percentage of each team
		model.range = (1.0 - model.freeSpace) / 2

		model.cell = Cell{
			-- cells have only a state that can be "free", "germany" or "brazil"
			state = function(cell)
				local agent = cell:getAgent()
				if agent then return agent.state else return "free" end
			end
		}
		
		model.cs = CellularSpace{
			xdim         = model.dim,
			instance     = model.cell
		}

		model.cs:createNeighborhood{wrap = true}

		-- define an agent whose state can be "free", "germany" or "brazil"
		model.agent = Agent{
			state = Random{"brazil", "germany"},
			-- function to test if the agent is unhappy with its neighbors
			isUnhappy = function(agent)
				local mycell = agent:getCell()
				local likeme = 0
				forEachNeighbor(mycell, function(_, neigh)
					local other = neigh:getAgent()
					if other and other.state == agent.state then
						likeme = likeme + 1
					end
				end)

				return likeme < model.preference -- how many are like me?
			end 
		}

		-- a society of agents
		model.society = Society{
			instance = model.agent,
			quantity = math.floor(model.dim * model.dim * (1.0 - model.freeSpace)),
			
			-- execute is the central function of the model
			-- 1. Select all unhappy agents
			-- 2. Select all empty cells
			-- 3. Choose a random unhappy agent and put it in an empty cell
			-- (repeat until final time)
			execute = function()
				-- a group of unhappy agents
				model.unhappy_agents:filter()

				-- are there unhappy agents?
				if #model.unhappy_agents > 0 then
					-- get a random unhappy agent
					local myagent = model.unhappy_agents:sample()
					
					-- a trajectory of empty cells
					local empty_cells = Trajectory{
						target = model.cs, 
						select = function(cell) 
							return cell:state() == "free"
						end
					}
					
					-- get a random empty cell
					local newcell = empty_cells:sample()
					
					-- move the agent to the empty cell
					myagent:move (newcell)
				end
			end
		}

		-- an environment puts a society in a cell space
		model.env = Environment{model.cs, model.society}

		-- agents are place randomly
		model.env:createPlacement{}

		model.unhappy_agents = Group{
			target = model.society,
			select = function(agent)
				return agent:isUnhappy()
			end
		}

		-- a map to plot the cell space
		model.map = Map{
			target = model.cs,
			select = "state",
			color  = "RdYlGn",
			value  = {"germany", "free", "brazil"}
		}
	
		model.unhappy  = function()
			return 100 * #model.unhappy_agents / #model.society
		end

		-- a chart to plot the percentage of unhappy agents
		model.chart = Chart{
			target = model,
			select = "unhappy",
			label  = "%-unhappy",
		}

		-- timer 
		-- 1. execute the society (put an unhappy agent in an empty cell)
		-- 2. execute the cell space (colors the cell space)
		-- 3. execute the map (refresh the map)
		-- 4. execute the chart (update the chart)
		model.timer = Timer{
			Event{action = model.society},
			Event{action = model.map    },
			Event{action = model.chart  }
		}
	end
}

