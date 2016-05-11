-- Test file for LifeCycle.lua
-- Author: Pedro R. Andrade

return{
	LifeCycle = function(unitTest)
		local model = LifeCycle{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.map, "LifeCycle-map-1-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.chart, "LifeCycle-chart-1.bmp")
		unitTest:assertSnapshot(model.map, "LifeCycle-map-1-end.bmp")
	end,
}

