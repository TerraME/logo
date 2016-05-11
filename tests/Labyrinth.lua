-- Test file for Labyrinth.lua
-- Author: Pedro R. Andrade

return{
	Labyrinth = function(unitTest)
		local model = Labyrinth{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.background, "Labyrinth-map-1-begin.bmp")
		unitTest:assertSnapshot(model.map, "Labyrinth-map-2-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.background, "Labyrinth-map-1-end.bmp")
		unitTest:assertSnapshot(model.map, "Labyrinth-map-2-end.bmp")
	end,
}

