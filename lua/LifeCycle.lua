
LifeCycle = LogoModel{
	quantity = 10,
	dim = 20,
	chart = true,
	finalTime = 300,
	init = function(agent)
		agent.age = 0
	end,
	changes = function(agent)
		agent.age = agent.age + 1

		if agent.age > 15 and agent.age < 30 and Random():number() < 0.3 then
			agent:breed()
		end

		agent:walk()
	
		if Random():number() < 0.05 and agent.age > 20 then
			agent:die()
		end
	end
}

