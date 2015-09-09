-- Test file for LogoModel.lua
-- Author: Pedro R. Andrade

return{
	LogoModel = function(unitTest)
		local s = SingleAgent{}

		s:execute()

		unitTest:assertEquals(#s.soc, 1)
	end,
}

