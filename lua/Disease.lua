
--- A SIR model implemented with agents. It exemplifies the number of additional decisions
-- a modeller must take to switch from system dynamics to agent-based modeling.
-- @arg data.contacts Number of contacts. The default value is 6.
-- @arg data.duration Disease duration. A number with 2 as default value.
-- @arg data.finalTime Final simulation time. A number with 30 as default value.
-- @arg data.probability Probability to infect a contact. A number with 0.25 as default value.
-- @arg data.quantity Number of agents. The default value is 1000.
Disease = Model{
	quantity = 1000,
	duration = 2,
	finalTime = 30,
	contacts = 6,
	probability = 0.25,
	init = function(model)
		model.ag = Agent{
			state = "susceptible",
			sick = function(self)
				self.state = "infected"
				self.counter = 0

				model.infected = model.infected + 1
				model.susceptible = model.susceptible - 1
			end,
			on_message = function(self)
				if self.state == "susceptible" and Random{p = model.probability}:sample() then
					self:sick()
				end
			end,
			execute = function(self)
				if self.state == "infected" then
					forEachConnection(self, function(conn)
						self:message{receiver = conn, delay = 1}
					end)

					if self.counter > model.duration then
						self.state = "recovered"
						model.infected = model.infected - 1
						model.recovered = model.recovered + 1
					end

					self.counter = self.counter + 1
				end
			end
		}

		model.soc = Society{
			instance = model.ag,
			quantity = model.quantity
		}

		model.susceptible = #model.soc
		model.infected = 0
		model.recovered = 0

		model.soc:sample():sick()

		model.soc:createSocialNetwork{
			quantity = model.contacts,
			inmemory = false
		}

		model.chart = Chart{
			target = model,
		--	select = "state",
			select = {"susceptible", "infected", "recovered"}, -- it should be "value ="
			color = {"blue", "red", "green"}
		}

		model.t = Timer{
			Event{action = model.soc},
			Event{action = model.chart}
		}
	end
}

