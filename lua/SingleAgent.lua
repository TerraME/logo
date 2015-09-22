
--- A single agent moving around randomly.
-- @image single-agent.bmp
SingleAgent = LogoModel{
	quantity = 1,
	dim = 15,
	background = "green",
	finalTime = 100,
	changes = function(agent)
		agent:relocate()
	end
}

