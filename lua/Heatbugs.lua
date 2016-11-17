
local function setUnhappiness(self)
	self.unhappiness = math.abs(self.idealTemp - self:getCell().temp)
end

-- diffuse defined amount to neighbours
local function diffuse(self)
	local cell = self:getCell()
	local amount = (cell.temp * self.diffusionRate) / 8
	forEachNeighbor(cell, function(_, n)
		n.temp = n.temp + amount
	end)
end

-- choose best neighbour according to unhappiness, move there
local function step(self)
	self:setUnhappiness()
	if self.unhappiness > 0 then
		local bestCell
		-- do step only if probability is reached
		if Random():number(0, 1) < self.randomMoveChance then
			bestCell = self:decideBestCell() -- decide which cell is the best
		else
			bestCell = self:getCell():getNeighborhood():sample()
		end

		if bestCell then
			self:move(bestCell)
		end
	end
end

-- decide which cell is best for me according to my unhappiness type (cold/hot)
-- choose the cell with maximum property (hottest/coldest)
local function decideBestCell(self)
	local currCell = self:getCell()
	local diff
	local bestCell = {currCell}

	if currCell.temp < self.idealTemp then -- if i am cold
		-- choose max temp
		diff = currCell.temp
		forEachNeighbor(currCell, function(_, n)
			if n.temp > diff and n:isEmpty() then
				diff = n.temp
				bestCell = {n}
			elseif n.temp == diff and n:isEmpty() then
				table.insert(bestCell, n)
			end
		end)
	else -- if i am hot
		-- choose minimum temp
		diff = currCell.temp

		forEachNeighbor(currCell, function(_, n)
			if n.temp < diff and n:isEmpty() then
				diff = n.temp
				bestCell = {n}
			elseif n.temp == diff and n:isEmpty() then
				table.insert(bestCell, n)
			end
		end)
	end

	return Random(bestCell):sample()
end

-- increase a temp of current cell
local function heatCell(self)
	self:getCell().temp = self:getCell().temp + self.outputHeat -- heat up my cell
end

--- Heatbugs is an agent-based model inspired by the behavior of biological agents that seek 
-- to regulate the temperature of their surrounding environment around an optimum level.
-- This model demonstrates how agents can organize themselves within a population. The agents
-- can detect and alter the environmental conditions in their neighborhood, though they can
-- only interact with other agents indirectly.
-- Although this model does not match the behavior of any specific organism, it can be used to
-- show how emergent behavior can arise as a result of different rules that govern the behavior
-- of agents.
-- The bugs (agents) exist in an environment composed of a grid of square patches. Each bug can
-- move to another, more suitable patch, as long as it is not occupied by another bug.
-- Each bug has an ideal temperature, though it is not the same for every bug. The bugs emit a
-- certain amount of heat into the environment at each time step. This heat slowly disperses
-- throughout the environment, though some is lost to cooling.
-- The larger the discrepancy between the bug's patch temperature and its ideal temperature,
-- the more unhappy it is. If the bug is not happy in its patch, it will move to an adjacent
-- empty patch that most closely resembles its ideal temperature. A patch that is too warm will
-- cause the bug to move to the coolest adjacent empty patch. In the same way, a patch that is
-- too cold will cause the bug to move to the warmest adjacent empty patch.
-- However, as the bugs only search their immediate neighborhood, it cannot be guaranteed that
-- the bugs will always move to the most suitable patch available.
-- The first version of this implementation was developed by Ondrej and Linda, as final work
-- for Environmental Modeling course in
-- Erasmus Mundus program, Munster University, 2014. It still needs further development.
-- @arg data.finalTime The final simulation time.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.initialCellTemperature Initial temperature of each cell. Default is 10.
-- @arg data.evaporationRate The speed of heat loss of each cell. This occurs in every
-- iteration, for every cell. Default is 0.04.
-- @arg data.idealTemperature Upper and lower edges of ideal temperature. Default ranges from
-- 45 to 60.
-- @arg data.outputHeat Upper and lower edges of amount of heat emitted by agent in each
-- iteration to its neighbors.  Default ranges from 10 to 20.
-- @arg data.diffusionRate The rate of amount emitted by agent in each iteration. Default
-- value is 0.9. 
-- @arg data.randomMoveChance Probability to move randomly, instead of choosing
-- coolest/hottest neighbor. Default is 0.5.
-- with the number of Agents along the simulation should be drawn.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.temperature Sets minimum and maximum extend of legend. Default ranges from 0 to 150.
-- @image Heatbugs-map-1-end.bmp
Heatbugs = Model{
	quantity = 50,
	dim = 100,
	finalTime = 100,
	evaporationRate = 0.04,
	initialCellTemperature = 10,
	temperature = {
		max = 150,
		min = 0
	},
	idealTemperature = {
		min = 45,
		max = 60
	},
	outputHeat = {
		min = 10,
		max = 20
	},
	diffusionRate = 0.9,
	randomMoveChance = 0.5,
	interface = function()
		return {
			{"number"},
			{"idealTemperature", "outputHeat"}, 
			{"temperature"}
		}
	end,
	init = function(model)
		local cell = Cell{
			evaporationRate = model.evaporationRate,
			maxTemp = model.temperature.max,
			init = function(cell)
				cell.temp = model.initialCellTemperature
				cell.color = 0
			end,
			state = function(cell)
				if #cell:getAgents() == 0 then
					return "empty"
				else
					return "full"
				end
			end,
			execute = function(cell)
				cell.temp = cell.temp * (1 - cell.evaporationRate)
				cell.color = (cell.temp > cell.maxTemp) and cell.maxTemp or cell.temp
			end
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = cell,
			unhappiness = function(self)
				local sum = 0
				forEachCell(self, function(mcell)
					if not mcell.placement or not mcell.placement.agents[1] then return end
					local ag = mcell:getAgent()

					sum = sum + ag.unhappiness
				end)
				return sum
			end,
			currentCellTemperature = function(self)
				local sum = 0
				forEachCell(self, function(mcell)
					if not mcell.placement or not mcell.placement.agents[1] then return end

					sum = sum + mcell.temp
				end)
				return sum
			end,
		}

		model.cs:createNeighborhood{}

		model.chartUnhappy = Chart{
			target = model.cs,
			select = {"unhappiness", "currentCellTemperature"}
		}

		model.heatmap = Map{
			target = model.cs,
			select = "color",
			slices = 9,
			min = model.temperature.min,
			max = model.temperature.max,
			color = {"black", "red"}
		}

		local agent = Agent{
			diffuse = diffuse,
			step = step,
			heatCell = heatCell,
			setUnhappiness = setUnhappiness,
			decideBestCell = decideBestCell,
			minIdealTemp = model.idealTemperature.min,
			maxIdealTemp = model.idealTemperature.max,
			minOutputHeat = model.outputHeat.min,
			maxOutputHeat = model.outputHeat.max,
			diffusionRate = model.diffusionRate,
			randomMoveChance = model.randomMoveChance,
			unhappiness = 1,
			init = function(agent)
				agent.idealTemp = agent.minIdealTemp + Random():number(agent.maxIdealTemp - agent.minIdealTemp)
				agent.outputHeat = agent.minOutputHeat + Random():number(agent.maxOutputHeat - agent.minOutputHeat)
			end,
			execute = function(self)
				self:diffuse()
				self:step()
				self:heatCell()
			end
		}

		model.soc = Society{
			quantity = model.quantity,
			instance = agent
		}

		model.env = Environment{model.cs, model.soc}

		model.env:createPlacement()

		model.map = Map{
			target = model.cs,
			select = "state",
			value = {"empty", "full"},
			color = {"lightGray", "red"}
		}

		model.timer = Timer{
			Event{action = model.soc},
			Event{action = model.cs},
			Event{action = model.map},
			Event{action = model.chartUnhappy}
		}
	end
}

