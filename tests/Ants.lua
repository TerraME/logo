-- Test file for Ants.lua
-- Author: Pedro R. Andrade

return{
	Ants = function(unitTest)
		local model = Ants{finalTime = 40}

		unitTest:assertSnapshot(model.map, "Ants-map-1-begin.bmp", 0.2)

		model:run()

		unitTest:assertSnapshot(model.chart, "Ants-chart-1.bmp", 0.2)
		unitTest:assertSnapshot(model.map, "Ants-map-1-end.bmp", 0.2)
	end,
}

