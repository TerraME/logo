-- Test file for Labyrinth.lua
-- Author: Pedro R. Andrade

return{
	Labyrinth = function(unitTest)
		local l = Labyrinth{}

		l:execute()
		unitTest:assertEquals(#l.soc, 1)
	end,
}

