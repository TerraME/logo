
-- Sex, culture and conflict in Sugarscape
-- Andre R. Goncalves and Frederico F. Avila
Sugarscape = Model{
	finalTime = 50,
	initPop = 400,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				cell.sugar = cell.maxSugar
			end,
			execute = function(cell)
				-- Rule G1: sugargrows 1 per time step
				cell.sugar = cell.sugar + 1

				if cell.sugar > cell.maxSugar then
					cell.sugar = cell.maxSugar
				end
			end,
			howFit = function(cell)
				if cell:isEmpty() then
					return 0
				else
					return cell:getAgent().vision / cell:getAgent().metabolism
				end
			end
		}

		model.cs = CellularSpace{
			file = filePath("default.pgm", "logo"),
			attrname = "maxSugar",
			instance = model.cell
		}

		model.cs:createNeighborhood{
			strategy = "mxn",
			m = 13,
			filter = function(cell, candidate)
				return cell.x == candidate.x or cell.y == candidate.y -- same line or colunm
			end
		}

		model.agent = Agent{
			age          = 0,
			metabolism   = Random{1, 2, 3, 4},
			vision       = Random{1, 2, 3, 4, 5, 6},
			sex          = Random{"female", "male"},
			sugar        = Random{min = 5, max = 25, step = 1},
			dieby        = Random{min = 60, max = 100, step = 1},
			fertileStart = Random{12, 13, 14, 15}, -- initial fertile period
			fertileEnd   = Random{min = 40, max = 50, step = 1},
			init = function(agent)
				agent.initSugar = agent.sugar -- initial sugar
				agent.kids      = {} -- list of sons for inheritance

				if agent.sex == "male" then
					agent.fertileEnd = agent.fertileEnd + 10
				end
			end,
			isFertile = function(self)
				local sexAge = self.age > self.fertileStart and self.age < self.fertileEnd
				return sexAge and self.sugar > 2 * self.initSugar
			end,
			-- neighborhood will depend on agents vison
			withinVision = function(self, neighbor)
				local cell = self:getCell()
				local distx = math.abs(neighbor.x - cell.x) -- horizontal distance
				local disty = math.abs(neighbor.y - cell.y) -- vertical distance
				return math.max(distx, disty) <= self.vision
			end,
			execute = function(self)
				-- Rule S: Find a mate and reproduce
				local mates = {} -- potential mates
				local emptycell = {} -- in beginning there is no empty cell
				forEachNeighbor(self:getCell(), function(_, neigh)
					if not self:withinVision(neigh) then return end

					local other = neigh:getAgent()
					if neigh:isEmpty() then
						table.insert(emptycell, neigh)
					elseif self:isFertile() and other:isFertile() and self.sex ~= other.sex then
						table.insert(mates, other)
					end
				end)

				-- Find a mate and reproduce
				for i = 1, #mates do
					local partner = mates[i]
					local nest

					if #emptycell > 0 then -- if there is empty cells
						nest = emptycell[1]
						table.remove(emptycell, 1) --exclude empty cell from list
					else
						-- look for an empty space in partner neighbors
						forEachNeighbor(partner:getCell(), function(_, n) --scan partner neighbors
							-- local agent and distance to neigh
							if self:withinVision(n) and n:isEmpty() then
								nest = n -- updates nest
							end
						end)
					end

					if nest then -- reproduce if there is a place to put children
						local child = self:reproduce() -- reproduce
						child:move(nest) -- move to empty cell

						-- average genetic transmitance - not yet Mendel's law
						child.vision = math.floor((self.vision + partner.vision) / 2)
						child.metabolism = math.floor((self.metabolism + partner.metabolism) / 2)
						child.sugar = (self.sugar + partner.sugar) / 2 -- child got parents sugar
						self.sugar = self.sugar / 2 -- deplet half of parents sugar
						partner.sugar = partner.sugar / 2
						table.insert(self.kids, child) -- append to kids list
						table.insert(partner.kids, child) -- append to kids list
					end
				end

				-- Rule M: Move to the best neighbor and get all the sugar
				-- gets agent actual cell and creates neighs table
				local cell = self:getCell()
				local neighs = {cell} -- cells to move
				-- neighborhood will depend on agents vison
				forEachNeighbor(self:getCell(), function(_, n)
					if not self:withinVision(n) then return end

					-- if finds empty neigh with more sugar: replace element
					if n.sugar > neighs[1].sugar and n:isEmpty() then
						neighs = {n}
					-- if finds empty neigh with same sugar: append element
					elseif n.sugar == neighs[1].sugar and n:isEmpty() then
						table.insert(neighs, n)
					end
				end)

				-- Rule M: Move to the best neighbor and get all the sugar
				self:move(Random(neighs):sample()) -- move
				self.sugar = self.sugar + self:getCell().sugar -- collect sugar
				self:getCell().sugar = 0 -- deplet cell

				-- Consumes sugar according to metabolism
				self.sugar = self.sugar - self.metabolism

				-- Get old
				self.age = self.age + 1

				-- die
				if self.sugar < 0 then
					self:die()
				elseif self.age >= self.dieby then
					--self:reproduce() --only for chapter II
					-- Rule I: Inheritance
					if #self.kids > 0 then
						local share = self.sugar / #self.kids
						for i = 1, #self.kids do
							local each = self.kids[i]
							if each then -- if that kid is still alive
								each.sugar = each.sugar + share
							end
						end
					end

					self:die()
				end
			end
		}

		model.society = Society{
			instance = model.agent,
			quantity = model.initPop,
			wealth = function(self)
				local sum = 0
				forEachAgent(self, function(agent)
					sum = sum + agent.sugar
				end)

				return sum / #self
			end,
			fit = function(self)
				local sum = 0
				forEachAgent(self, function(agent)
					sum = sum + (agent.vision / agent.metabolism)
				end)

				return sum / #self
			end
		}

		model.group = Group{
			target = model.society,
			random = true
		}

		model.chart1 = Chart{
			target = model.society,
			select = "wealth",
			title = "Wealth"
		}

		model.chart2 = Chart{
			target = model.society,
			title = "Population",
			yLabel = "# Society"
		}

		model.chart3 = Chart{
			target = model.society,
			select = "fit",
			title = "Fit"
		}

		model.env = Environment{
			model.cs,
			model.society
		}

		model.env:createPlacement()

		model.map1 = Map{
			target = model.cs,
			grouping = "placement",
			min = 0,
			max = 1,
			slices = 2,
			color = "Blues"
		}

		model.map2 = Map{
			target = model.cs,
			select = "sugar",
			min = 0,
			max = 4,
			slices = 5,
			color = "Reds"
		}

		model.map3 = Map{
			target = model.cs,
			select = "howFit",
			min = 0,
			max = 6,
			slices = 6,
			color = {"white", "red", "red", "blue", "blue", "blue"}
		}

		model.timer = Timer{
			Event{action = model.cs},
			Event{action = model.group},
			Event{action = model.map1},
			Event{action = model.map2},
			Event{action = model.map3},
			Event{action = model.chart3},
			Event{action = model.chart2}
		}
	end
}

Sugarscape:run()

