-- Test file for SingleAgent.lua
-- Author: Pedro R. Andrade

return{
	SingleAgent = function(unitTest)
		local model = SingleAgent{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.map, "SingleAgent-map-2-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.map, "SingleAgent-map-2-end.bmp")
	end,
}

