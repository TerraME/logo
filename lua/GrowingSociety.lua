
GrowingSociety = LogoModel{
	quantity = 1,
	dim = 20,
	chart = true,
	background = {color = "green"},
	finalTime = 100,
	init = function()
	end,
	changes = function(agent)
		if Random():number() < 0.2 then
			agent:breed()
		end

		agent:walk()
	end
}

