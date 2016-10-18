-- Test file for Utils.lua
-- Author: Pedro R. Andrade

return{
	getLabyrinth = function(unitTest)
		local error_func = function()
			getLabyrinth(2)
		end

		unitTest:assertError(error_func, incompatibleTypeMsg(1, "string", 2))

		error_func = function()
			getLabyrinth("abc")
		end

		unitTest:assertError(error_func, "File 'logo/data/abc.labyrinth' does not exist in package 'logo'. Do you mean 'maze.labyrinth'?")

		local maze = getLabyrinth("maze")

		unitTest:assertType(maze, "CellularSpace")
	end
}

