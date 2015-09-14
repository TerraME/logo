-- Test file for SingleAgent.lua
-- Author: Pedro R. Andrade

return{
	SingleAgent = function(unitTest)
		local model = SingleAgent{}

		unitTest:assertSnapshot(model.background, "SingleAgent-map-1-begin.bmp")
		unitTest:assertSnapshot(model.map, "SingleAgent-map-2-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.background, "SingleAgent-map-1-end.bmp")
		unitTest:assertSnapshot(model.map, "SingleAgent-map-2-end.bmp")
	end,
}

