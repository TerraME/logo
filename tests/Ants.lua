-- Test file for Ants.lua
-- Author: Pedro R. Andrade

return{
	Ants = function(unitTest)
		local model = Ants{finalTime = 10}

		unitTest:assertSnapshot(model.map, "Ants-map-1-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.chart, "Ants-chart-1.bmp")
		unitTest:assertSnapshot(model.map, "Ants-map-1-end.bmp")
	end,
}

