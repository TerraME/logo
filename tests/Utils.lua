-- Test file for Utils.lua
-- Author: Pedro R. Andrade

return{
	getLabyrinth = function(unitTest)
		local error_func = function()
			getLabyrinth(2)
		end

		unitTest:assertError(error_func, incompatibleTypeMsg(1, "string", 2))

		local error_func = function()
			getLabyrinth("abc")
		end

		unitTest:assertError(error_func, "File 'logo/data/abc.labyrinth' does not exist in package 'logo'.", 45)

		local maze = getLabyrinth("maze")

		unitTest:assertType(maze, "CellularSpace")
	end,
	getSugar = function(unitTest)
		local error_func = function()
			getSugar(2)
		end

		unitTest:assertError(error_func, incompatibleTypeMsg(1, "string", 2))

		local error_func = function()
			getSugar("abc")
		end

		unitTest:assertError(error_func, "File 'logo/data/abc.sugar' does not exist in package 'logo'.", 45)
	
		local default = getSugar("default")

		unitTest:assertType(default, "CellularSpace")
	end,
}

