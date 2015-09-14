-- Test file for GrowingSociety.lua
-- Author: Pedro R. Andrade

return{
	GrowingSociety = function(unitTest)
		local model = GrowingSociety{}

		unitTest:assertSnapshot(model.background, "GrowingSociety-map-1-begin.bmp")
		unitTest:assertSnapshot(model.map, "GrowingSociety-map-2-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.background, "GrowingSociety-map-1-end.bmp")
		unitTest:assertSnapshot(model.chart, "GrowingSociety-chart-1.bmp")
		unitTest:assertSnapshot(model.map, "GrowingSociety-map-2-end.bmp")
	end,
}

