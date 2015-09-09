-- Test file for LifeCycle.lua
-- Author: Pedro R. Andrade

return{
	LifeCycle = function(unitTest)
		local l = LifeCycle{}

		l:execute()

		unitTest:assertSnapshot(l.chart, "LifeCycle-chart-1.bmp")
	end,
}

