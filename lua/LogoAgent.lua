--LogoAgent_ = {
--	type_ = "Agent",
	--- Return an empty neighbor Cell. If there is no empty neighbor
	-- then it returns false.
	emptyNeighbor = function(agent)
		local empty = {}
		forEachNeighbor(agent:getCell(), function(_, neigh)
			if neigh:isEmpty() then
				table.insert(empty, neigh)
			end
		end)

		if #empty == 0 then
			return false
		end

		return Random():sample(empty)
	end
	--- Count the number of Agents in the neighbor cells.
	countNeighbors = function(agent)
		local count = 0
		forEachNeighbor(agent:getCell(), function(_, neigh)
			if not neigh:isEmpty() then
				count = count + 1
			end
		end)

		return count
	end
	--- Walk to a random neighbor Cell. If there is no
	-- empty neighbor then this function returns false.
	-- @usage agent:walk()
	walk = function(agent)
		local empty = agent:emptyNeighbor()

		if not empty then
			return false
		end

		agent:move(empty)
		return true
	end
	--- Reproduce the Agent to a random neighbor Cell.
	-- If there is no empty neighbor cell then this
	-- function returns nil.
	-- @usage agent:reproduce()
	breed = function(agent)
		local empty = agent:emptyNeighbor()

		if not empty then
			return nil
		end

		local newborn = agent:reproduce()
		newborn:move(empty)
		return newborn
	end
--}

--[[
setmetatable(LogoAgent_, metaTableAgent_)

metaTableLogoAgent_ = {
	__index = LogoAgent_
}

function LogoAgent(data)
	print("Logo Agent")
	print(type(data.breed))
	setmetatable(data, metaTableLogoAgent_)
	print(type(data.breed))
	return data
end
--]]
