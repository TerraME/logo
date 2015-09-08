
Overpopulation = LogoModel{
	quantity = 10,
	dim = 20,
	chart = true,
	finalTime = 300,
	changes = function(agent)
		if Random():number() < 0.3 then
			agent:breed()
		end

		agent:walk()
	
		if agent:countNeighbors() > 3 then
			agent:die()
		end
	end
}

