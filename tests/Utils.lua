-- Test file for Utils.lua
-- Author: Pedro R. Andrade

return{
	getLabyrinth = function(unitTest)
		local error_func = function()
			getLabyrinth(2)
		end

		unitTest:assertError(error_func, incompatibleTypeMsg(1, "string", 2))

		error_func = function()
			getLabyrinth("error/error-line")
		end
		unitTest:assertError(error_func, "Line 3 of file 'error/error-line' does not have the same length (12) of the first line (13).")

		error_func = function()
			getLabyrinth("error/error-char")
		end
		unitTest:assertError(error_func, "Invalid character 'p' in file 'error/error-char' (line 3).")

		error_func = function()
			getLabyrinth("abc")
		end

		unitTest:assertError(error_func, "File 'data/abc.labyrinth' does not exist in package 'logo'. Do you mean 'maze.labyrinth'?")

		local maze = getLabyrinth("maze")

		unitTest:assertType(maze, "CellularSpace")
	end
}

