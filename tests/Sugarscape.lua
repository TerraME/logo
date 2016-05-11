-- Test file for Sugarscape.lua
-- Author: Pedro R. Andrade

return{
	Sugarscape = function(unitTest)
		local model = Sugarscape{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.background, "Sugarscape-map-1-begin.bmp")
		unitTest:assertSnapshot(model.map, "Sugarscape-map-2-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.background, "Sugarscape-map-1-end.bmp")
		unitTest:assertSnapshot(model.map, "Sugarscape-map-2-end.bmp")
	end,
}

