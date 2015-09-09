-- Test file for SingleAgent.lua
-- Author: Pedro R. Andrade

return{
	SingleAgent = function(unitTest)
		local s = SingleAgent{}

		s:execute()

		unitTest:assertEquals(#s.soc, 1)
	end,
}

