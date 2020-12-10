
--- Predator-prey dynamics.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.finalTime The final simulation time.
-- @image predatorprey.bmp
PredatorPrey = Model{
	finalTime = 500,
	dim = 30,
	init = function(model)
		model.cell = Cell{
			state = "pasture",
			count = 0,
			who = function(self)
				if self:isEmpty() then
					return "empty"
				else
					return self:getAgent().name
				end
			end,
			execute = function(self)
				if self.state == "soil" then
					self.count = self.count + 1

					if self.count == 4 then
						self.state = "pasture"
						self.count = 0
					end
				end
			end
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = model.cell
		}

		model.cs:createNeighborhood()

		model.rabbit = Agent{
			energy = 40,
			name = "rabbit",
			eat = function(self)
				if self:getCell().state == "pasture" then
					self:getCell().state = "soil"
					self.energy = self.energy + 20
				end
			end,
			execute = function(self)
				local cell = self:getCell():getNeighborhood():sample()

				if cell:isEmpty() then
					self:move(cell)
				end

				self.energy = self.energy - 1

				self:eat()

				cell = self:getCell():getNeighborhood():sample()

				if self.energy >= 30 and cell:isEmpty() then
					local child = self:reproduce()
					child:move(cell)

					self.energy = self.energy / 2
					child.energy = self.energy
				end

				if self.energy < 0 then
					self:die() -- SKIP
				end
			end
		}

		model.rabbits = Society{
			instance = model.rabbit,
			quantity = 20
		}

		model.wolf = Agent{
			energy = 40,
			name = "wolf",
			execute = function(self)
				local cell = self:getCell():getNeighborhood():sample()

				if cell:isEmpty() then
					if self.energy >= 50 then
						local child = self:reproduce()
						child:move(cell)
						self.energy = self.energy / 2
					else
						self:move(cell)
					end
				elseif cell:getAgent().name == "rabbit" then
					local prey = cell:getAgent()

					self.energy = self.energy + prey.energy * 0.2
					prey:die()
				end

				self.energy = self.energy - 4

				if self.energy < 0 then
					self:die()
				end
			end
		}

		model.wolves = Society{
			instance = model.wolf,
			quantity = 20
		}

		model.env = Environment{model.rabbits, model.wolves, model.cs}

		model.env:createPlacement{}

		model.qwolves = function()
			return #model.wolves
		end

		model.qrabbits = function()
			return #model.rabbits
		end

		model.chart = Chart{
			target = model,
			select = {"qrabbits", "qwolves"},
			color = {"blue", "red"}
		}

		model.map1 = Map{
			target = model.cs,
			select = "state",
			value = {"soil", "pasture"},
			color = {"brown", "green"}
		}

		model.map2 = Map{
			target = model.cs,
			select = "who",
			value = {"empty", "wolf", "rabbit"},
			color = {"white", "red", "blue"}
		}

		model.timer = Timer{
			Event{action = model.cs},
			Event{action = model.map1},
			Event{action = model.map2},
			Event{action = model.rabbits},
			Event{action = model.wolves},
			Event{action = model.chart}
		}
	end
}

