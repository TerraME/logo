
LifeCycle = LogoModel{
	quantity = 80,
	dim = 10,
	chart = true,
	finalTime = 100,
	init = function(agent)
		agent.age = 0
	end,
	changes = function(agent)
		agent.age = agent.age + 1

		if agent.age > 15 and agent.age < 30 and Random():number() < 0.2 then
			--agent:breed()
			print("breed")
		end

		agent:walk()
	
		if Random():number() < 0.05 then
			print("die")
			agent:die()
		elseif agent.age > 40 and Random():number() < 0.3 then
			print("die 2")
			agent:die()
		end
	end
}

