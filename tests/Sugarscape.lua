-- Test file for Sugarscape.lua
-- Author: Pedro R. Andrade

return{
	Sugarscape = function(unitTest)
		local s = Sugarscape{}

		s:execute()
		unitTest:assertSnapshot(s.map, "Sugarscape-Map-1.bmp")
	end,
}

