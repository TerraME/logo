-- Test file for LifeCycle.lua
-- Author: Pedro R. Andrade

return{
	LifeCycle = function(unitTest)
		local model = LifeCycle{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.map, "LifeCycle-map-1-begin.bmp", 0.1)

		model:run()

		unitTest:assertSnapshot(model.chart, "LifeCycle-chart-1.bmp", 0.1)
		unitTest:assertSnapshot(model.map, "LifeCycle-map-1-end.bmp", 0.1)
	end,
}

