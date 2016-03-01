-- @example Implementation of a small model where agents
-- move along a given road. If they reach the end, they
-- turn back and walk again.

local cell = Cell{
	state = function(self)
		local neigh = self:getNeighborhood("road-1")

		if neigh then
			if #self:getAgents() == 1 then
				return "agent"
			else
				return "road"
			end
		else
			return "building"
		end
	end
}


cs = CellularSpace{
	xdim = 40,
	instance = cell
}

-- create the neighborhood structure for a road
for i = 1, 20 do
	local cell = cs:get(i + 10, 5)
	local neigh = Neighborhood()
	neigh:add(cs:get(i + 11, 5))
	cell:addNeighborhood(neigh, "road-1")

	local cell = cs:get(i + 11, 5)
	local neigh = Neighborhood()
	neigh:add(cs:get(i + 10, 5))
	cell:addNeighborhood(neigh, "road-2")
end

-- create the neighborhood structure for another road
for i = 1, 25 do
	local cell = cs:get(23, i + 8)
	local neigh = Neighborhood()
	neigh:add(cs:get(23, i + 9))
	cell:addNeighborhood(neigh, "road-1")

	local cell = cs:get(23, i + 9)
	local neigh = Neighborhood()
	neigh:add(cs:get(23, i + 8))
	cell:addNeighborhood(neigh, "road-2")
end

agent = Agent{
	moving = 1,
	execute = function(self)
		local neighName = "road-"..self.moving

		local neigh = self:getCell():getNeighborhood(neighName)

		if not neigh then
			if self.moving == 1 then
				self.moving = 2
			else
				self.moving = 1
			end

			self:execute()
			return
		end

		local next = neigh:sample()

		self:move(next)
	end
}

soc = Society{
	instance = agent,
	quantity = 2
}

env = Environment{
	soc,
	cs
}

env:createPlacement{strategy = "void"}

soc.agents[1]:enter(cs:get(15, 5)) -- enter in the first road
soc.agents[2]:enter(cs:get(23, 9)) -- enter in the second road

map = Map{
	target = cs,
	select = "state",
	value = {"agent", "road", "building"},
	color = {"red", "white", "black"}
}

timer = Timer{
	Event{action = soc},
	Event{action = cs}
}

timer:run(500)

