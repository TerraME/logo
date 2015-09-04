
SingleAgent = LogoModel{
	quantity = 1,
	dim = 20,
	finalTime = 100,
	changes = function(agent)
		agent:walk()
	end
}

