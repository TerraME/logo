-- Test file for Heatbugs.lua
-- Author: Pedro R. Andrade

return{
	Heatbugs = function(unitTest)
		local model = Heatbugs{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.heatmap, "Heatbugs-map-1-begin.bmp", 0.1)
		unitTest:assertSnapshot(model.map, "Heatbugs-map-2-begin.bmp", 0.1)

		model:run()

		unitTest:assertSnapshot(model.chartUnhappy, "Heatbugs-chart-2.bmp", 0.1)
		unitTest:assertSnapshot(model.heatmap, "Heatbugs-map-1-end.bmp", 0.1)
		unitTest:assertSnapshot(model.map, "Heatbugs-map-2-end.bmp", 0.1)
	end,
}

