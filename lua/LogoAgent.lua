LogoAgent_ = {
	type_ = "Agent",
	--- Return an empty neighbor Cell. If there is no empty neighbor
	-- then it returns false.
	-- @arg agent An Agent.
	-- @usage import("logo")
	--
	-- Empty = LogoModel{
	--    quantity = 6,
	--    dim = 3,
	--    finalTime = 10,
	--    changes = function(agent)
	--        if not agent:emptyNeighbor() then
	--            print("not empty")
	--        end
	--    end
	-- }
	--
	-- Empty:execute()
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
	end,
	--- Count the number of Agents in the neighbor cells.
	-- @arg agent An Agent.
	-- @usage import("logo")
	--
	-- Count = LogoModel{
	--    quantity = 3,
	--    dim = 3,
	--    finalTime = 2,
	--    changes = function(agent)
	--        print(agent:countNeighbors())
	--    end
	-- }
	--
	-- Count:execute()
	countNeighbors = function(agent)
		local count = 0
		forEachNeighbor(agent:getCell(), function(_, neigh)
			if not neigh:isEmpty() then
				count = count + 1
			end
		end)

		return count
	end,
	--- Walk to a random neighbor Cell. If there is no
	-- empty neighbor then this function returns false.
	-- @arg agent An Agent.
	-- @usage import("logo")
	--
	-- Relocate = LogoModel{
	--    quantity = 10,
	--    dim = 10,
	--    finalTime = 10,
	--    changes = function(agent)
	--        agent:relocate()
	--    end
	-- }
	--
	-- Relocate:execute()
	relocate = function(agent)
		local empty = agent:emptyNeighbor()

		if not empty then
			return false
		end

		agent:move(empty)
		return true
	end,
	--- Reproduce the Agent to a random neighbor Cell.
	-- If there is no empty neighbor cell then this
	-- function returns nil.
	-- @arg agent An Agent.
	-- @usage import("logo")
	--
	-- Breed = LogoModel{
	--    quantity = 10,
	--    dim = 10,
	--    finalTime = 10,
	--    changes = function(agent)
	--        agent:breed()
	--        agent:relocate()
	--    end
	-- }
	--
	-- Breed:execute()
	breed = function(agent)
		local empty = agent:emptyNeighbor()

		if not empty then
			return nil
		end

		local newborn = agent:reproduce()
		newborn:move(empty)
		return newborn
	end
}

setmetatable(LogoAgent_, metaTableAgent_)

metaTableLogoAgent_ = {
	__index = LogoAgent_
}

--- Basic Agent for Logo models.
-- @arg data.init A function that gets the agent itself as argument and
-- will be executed when the agent is initialized.
-- @arg data.execute A function that gets the agent itself as argument and
-- is called every time step. 
-- @usage import("logo")
--
-- LogoAgent{}
function LogoAgent(data)
	setmetatable(data, metaTableLogoAgent_)
	return data
end

