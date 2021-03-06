-- Test file for Overpopulation.lua
-- Author: Pedro R. Andrade

return{
	Overpopulation = function(unitTest)
		local model = Overpopulation{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.map, "Overpopulation-map-1-begin.bmp", 0.1)

		model:run()

		unitTest:assertSnapshot(model.chart, "Overpopulation-chart-1.bmp", 0.1)
		unitTest:assertSnapshot(model.map, "Overpopulation-map-1-end.bmp", 0.1)
	end,
}

