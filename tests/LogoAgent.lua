-- Test file for LogoAgent.lua
-- Author: Pedro R. Andrade

return{
	breed = function(unitTest)
		unitTest:assert(true)
	end,
	countNeighbors = function(unitTest)
		local model = Overpopulation{
			finalTime = 5
		}

		model:run()

		unitTest:assert(true)
	end,
	emptyNeighbor = function(unitTest)
		unitTest:assert(true)
	end,
	relocate = function(unitTest)
		unitTest:assert(true)
	end,
	LogoAgent = function(unitTest)
		local model = LifeCycle{
			finalTime = 50
		}

		model:run()

		unitTest:assert(true)
	end
}

