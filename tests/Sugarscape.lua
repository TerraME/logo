-- Test file for Sugarscape.lua
-- Author: Pedro R. Andrade

return{
	Sugarscape = function(unitTest)
		local model = Sugarscape{}

		unitTest:assertSnapshot(model.background, "Sugarscape-map-1-begin.bmp")
		unitTest:assertSnapshot(model.map, "Sugarscape-map-2-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.background, "Sugarscape-map-1-end.bmp")
		unitTest:assertSnapshot(model.map, "Sugarscape-map-2-end.bmp")
	end,
}

