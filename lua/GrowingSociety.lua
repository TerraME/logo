
GrowingSociety = LogoModel{
	quantity = 1,
	dim = 20,
	finalTime = 100,
	init = function()
	end,
	changes = function(agent)
		if Random():number() < 0.2 then
			agent:reproduce()
		end

		agent:walk()
	end
}

