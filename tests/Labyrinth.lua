-- Test file for Labyrinth.lua
-- Author: Pedro R. Andrade

return{
	Labyrinth = function(unitTest)
		local model = Labyrinth{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.background, "Labyrinth-map-1-begin.bmp", 0.1)
		unitTest:assertSnapshot(model.map, "Labyrinth-map-2-begin.bmp", 0.1)

		model:run()

		unitTest:assertSnapshot(model.background, "Labyrinth-map-1-end.bmp", 0.1)
		unitTest:assertSnapshot(model.map, "Labyrinth-map-2-end.bmp", 0.1)
	end,
}

