-- Test file for Disease.lua
-- Author: Pedro R. Andrade

return{
	Disease = function(unitTest)
		local model = Disease{}

		model:run()

		unitTest:assertSnapshot(model.chart, "Disease-chart-1.bmp", 0.2)
	end,
}

