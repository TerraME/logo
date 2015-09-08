
SingleAgent = LogoModel{
	quantity = 1,
	dim = 15,
	background = {color = "green"},
	finalTime = 100,
	changes = function(agent)
		agent:walk()
	end
}

