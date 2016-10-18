-- Test file for PredatorPrey.lua
-- Author: Pedro R. Andrade

return{
	PredatorPrey = function(unitTest)
		local model = PredatorPrey{finalTime = 5}

		unitTest:assertSnapshot(model.map1, "PredatorPrey-map-1-begin.bmp", 0.1)
		unitTest:assertSnapshot(model.map2, "PredatorPrey-map-2-begin.bmp", 0.1)

		model:run()

		unitTest:assertSnapshot(model.chart, "PredatorPrey-chart-1.bmp", 0.1)
		unitTest:assertSnapshot(model.map1, "PredatorPrey-map-1-end.bmp", 0.1)
		unitTest:assertSnapshot(model.map2, "PredatorPrey-map-2-end.bmp", 0.1)
	end,
}

