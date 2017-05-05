-- Test file for Sugarscape.lua
-- Author: Pedro R. Andrade

return{
	Sugarscape = function(unitTest)
		local model = Sugarscape{
			finalTime = 70,
			initPop = 40
		}

		unitTest:assertSnapshot(model.map1, "Sugarscape-map-1-begin.bmp", 0.1)
		unitTest:assertSnapshot(model.map2, "Sugarscape-map-2-begin.bmp", 0.1)
		unitTest:assertSnapshot(model.map3, "Sugarscape-map-3-begin.bmp", 0.1)

		model:run()

		unitTest:assertSnapshot(model.map1, "Sugarscape-map-1-end.bmp", 0.1)
		unitTest:assertSnapshot(model.map2, "Sugarscape-map-2-end.bmp", 0.1)
		unitTest:assertSnapshot(model.map3, "Sugarscape-map-3-end.bmp", 0.1)
	end,
}

