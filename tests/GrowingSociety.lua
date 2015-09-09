-- Test file for GrowingSociety.lua
-- Author: Pedro R. Andrade

return{
	GrowingSociety = function(unitTest)
		local g = GrowingSociety{}

		g:execute()

		unitTest:assertEquals(#g.soc, 400)
	end,
}

