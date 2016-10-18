-- Test file for Schelling.lua
-- Author: Pedro R. Andrade

return{
	Schelling = function(unitTest)
		local model = Schelling{finalTime = 10}

		unitTest:assertSnapshot(model.map, "Schelling-map-1-begin.bmp", 0.1)

		model:run()

		unitTest:assertSnapshot(model.chart, "Schelling-chart-1.bmp", 0.1)
		unitTest:assertSnapshot(model.map, "Schelling-map-1-end.bmp", 0.1)
	end,
}

