-- Test file for Heatbugs.lua
-- Author: Pedro R. Andrade

return{
	Heatbugs = function(unitTest)
		local model = Heatbugs{}

		unitTest:assertSnapshot(model.heatmap, "Heatbugs-map-1-begin.bmp")
		unitTest:assertSnapshot(model.map, "Heatbugs-map-2-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.chart, "Heatbugs-chart-1.bmp")
		unitTest:assertSnapshot(model.chartUnhappy, "Heatbugs-chart-2.bmp")
		unitTest:assertSnapshot(model.heatmap, "Heatbugs-map-1-end.bmp")
		unitTest:assertSnapshot(model.map, "Heatbugs-map-2-end.bmp")
	end,
}

