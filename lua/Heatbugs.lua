
local setUnhappiness = function(self)
	self.unhappiness = math.abs(self.idealTemp - self:getCell().temp)
end

-- diffuse defined amount to neighbours
local diffuse = function(self)
	local cell = self:getCell()
	local amount = (cell.temp * self.diffusionRate) / 8
	forEachNeighbor(cell, function(c, n) 
		n.temp = n.temp + amount
	end)
end

-- choose best neighbour according to unhappiness, move there
local step = function(self)
	self:setUnhappiness()
	if self.unhappiness > 0 then
		local bestCell = nil
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
local decideBestCell = function(self)
	local currCell = self:getCell()
	local diff = 0
	local bestCell = currCell

	if currCell.temp < self.idealTemp then -- if i am cold
		-- choose max temp
		diff = currCell.temp
		forEachNeighbor(currCell, function(c, n) 
			if n.temp > diff and n:isEmpty() then
				diff = n.temp
				bestCell = n
			end
		end)
	else -- if i am hot
		-- choose minimum temp
		diff = currCell.temp

		forEachNeighbor(currCell, function(c, n)
			if n.temp < diff and n:isEmpty() then
				diff = n.temp
				bestCell = n
			end
		end)
	end
	return bestCell
end

-- increase a temp of current cell
local heatCell = function(self)
	self:getCell().temp = self:getCell().temp + self.outputHeat -- heat up my cell
end


--- Heatbugs is an agent-based model inspired by the behavior of biological agents that seek to regulate the temperature of their surrounding environment around an optimum level.
-- This model demonstrates how agents can organize themselves within a population. The agents can detect and alter the environmental conditions in their neighborhood, though they can only interact with other agents indirectly.
-- Although this model does not match the behavior of any specific organism, it can be used to show how emergent behavior can arise as a result of different rules that govern the behavior of agents.
-- The bugs (agents) exist in an environment composed of a grid of square patches. Each bug can move to another, more suitable patch, as long as it is not occupied by another bug.
-- Each bug has an ideal temperature, though it is not the same for every bug. The bugs emit a certain amount of heat into the environment at each time step. This heat slowly disperses throughout the environment, though some is lost to cooling.
-- The larger the discrepancy between the bug's patch temperature and its ideal temperature, the more unhappy it is. If the bug is not happy in its patch, it will move to an adjacent empty patch that most closely resembles its ideal temperature. A patch that is too warm will cause the bug to move to the coolest adjacent empty patch. In the same way, a patch that is too cold will cause the bug to move to the warmest adjacent empty patch.
-- However, as the bugs only search their immediate neighborhood, it cannot be guaranteed that the bugs will always move to the most suitable patch available.
-- The first version of this implementation was developed by Ondrej and Linda, as final work for Environmental Modeling course in
-- Erasmus Mundus program, Munster University, 2014. It still needs further development.
-- @arg data.finalTime The final simulation time.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.initialCellTemperature Initial temperature of each cell. Default is 10.
-- @arg data.evaporationRate The speed of heat loss of each cell. This occurs in every iteration, for every cell. Default is 0.04.
-- @arg data.idealTemperature Upper and lower edges of ideal temperature. Default ranges from 45 to 60.
-- @arg data.outputHeat Upper and lower edges of amount of heat emitted by agent in each iteration to its neighbors.  Default ranges from 10 to 20.
-- @arg data.diffusionRate The rate of amount emitted by agent in each iteration. Default value is 0.9. 
-- @arg data.randomMoveChance Probability to move randomly, instead of choosing coolest/hottest neighbor. Default is 0.5.
-- @arg data.chart A boolean value indicating whether a Chart
-- with the number of Agents along the simulation should be drawn.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.map A boolean value indicating whether a Map.
-- @arg data.temperature Sets minimum and maximum extend of legend. Default ranges from 0 to 150.
-- @image Heatbugs-map-1-end.bmp
Heatbugs = LogoModel{
	quantity = 50,
	dim = 100,
	chart = true,
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
	space = function(instance)
		local cell = Cell{
			evaporationRate = instance.evaporationRate,
			maxTemp = instance.temperature.max,
			init = function(cell)
				cell.temp = instance.initialCellTemperature
				cell.color = 0
			end,
			state = function(cell)
				if #cell:getAgents() == 0 then
					return "empty"
				else
					return "full"
				end
			end
		}

		local cs = CellularSpace{
			xdim = instance.dim,
			instance = cell,
			unhappiness = function(self)
				local sum = 0
				forEachCell(self, function(cell)
					if not cell.placement or not cell.placement.agents[1] then return end
					local ag = cell:getAgent()

					sum = sum + ag.unhappiness
				end)
				return sum
			end,
			currentCellTemperature = function(self)
				local sum = 0
				forEachCell(self, function(cell)
					if not cell.placement or not cell.placement.agents[1] then return end

					sum = sum + cell.temp
				end)
				return sum
			end,
		}
		cs:createNeighborhood{}

		if instance.chart then
			instance.chartUnhappy = Chart{
				target = cs,
				select = {"unhappiness", "currentCellTemperature"}
			}
		end

		if instance.map then
			instance.heatmap = Map{
				target = cs,
				select = "color",
				slices = 9,
				min = instance.temperature.min,
				max = instance.temperature.max,
				color = {"black", "red"}
			}
		end

		return cs
	end,
	init = function(agent, instance)
		agent.minIdealTemp = instance.idealTemperature.min
		agent.maxIdealTemp = instance.idealTemperature.max
	    agent.minOutputHeat = instance.outputHeat.min
	    agent.maxOutputHeat = instance.outputHeat.max
	    agent.diffusionRate = instance.diffusionRate
	    agent.randomMoveChance = instance.randomMoveChance
		agent.unhappiness = 1
		agent.idealTemp = agent.minIdealTemp + Random():number(agent.maxIdealTemp - agent.minIdealTemp)
		agent.outputHeat = agent.minOutputHeat + Random():number(agent.maxOutputHeat - agent.minOutputHeat)
		agent.diffuse = diffuse
		agent.step = step
		agent.heatCell = heatCell
		agent.setUnhappiness = setUnhappiness
		agent.decideBestCell = decideBestCell
	end,
	cell = function(cell)
		cell.temp = cell.temp * (1 - cell.evaporationRate)
		cell.color = (cell.temp > cell.maxTemp) and cell.maxTemp or cell.temp
	end,
	changes = function(self)
		self:diffuse()
		self:step()
		self:heatCell()
	end
}

