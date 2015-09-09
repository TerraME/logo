-- Test file for Overpopulation.lua
-- Author: Pedro R. Andrade

return{
	Overpopulation = function(unitTest)
		local o = Overpopulation{}

		o:execute()

		unitTest:assertEquals(#o.soc, 39)
	end,
}

