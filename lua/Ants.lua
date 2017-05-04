-- Model: Agents - Schelling's segregation model 
--
-- Author: Fesseha Belay & Javier Morata
--
-- Lesson: Agent based models in TerraME.
-- 		   Before add agents to an environment, add all cellular space the will need.
--		   Model MUST have the following structure
--				1) Define space
--				2) Define behavior (agents or societies or groups)
--				3) Define time
--				4) Define environments (adding (1) cellular spaces, then (2) agents, then (3) timers )
--				5) Run simulations 
--

--------------------------------------------------------------
-- GLOBAL 
--------------------------------------------------------------
-- Possible states
EMPTY	 = 0
FOOD     = 1
NEST     = 2
CHEMICAL = 3
LESSCHEM = 4	
ANT 	 = 5  	

SEARCHING_FOOD = 5
BRINGING_FOOD = 6

-- Possible movements
MOVE_CHEM = 7
MOVE_LESS = 8
MOVE_RAND = 9

COUNTER_FOOD = 100   -- Pieces of food (This is the amount of food depending on the cells painted as FOOD)

-- random number generator

MAX_TIME = 450


--------------------------------------------------------------
-- MODEL 
--------------------------------------------------------------

AntsModel = Model{

	SPACE_DIMENSION = 50,
	
	--------------------------------------------------------------
	-- PARAMETER 
	--------------------------------------------------------------

	-- simulationn temporal extent
	finalTime = MAX_TIME,

	-- size of the society of agents
	societySize	= Choice{min = 10, max = 500},
	
	-- controls the diffusion rate of the chemical
	rateDiffusion = Choice{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},    -- 3,  4

	-- controls the evaporation rate of the chemical
	rateEvaporation = Choice{min = 0.000001, max = 0.999999}, -- 0.5,  0.75

	lastFoodTime = MAX_TIME,
	
	init = function(model)
		rand = Random()
		-------------
		--# SPACE #
		-------------

		model.cs = CellularSpace {
			xdim = model.SPACE_DIMENSION,
			food = COUNTER_FOOD
		}

		model.cs:createNeighborhood {
			strategy = "moore", --"vonneumann"
				self = false
		}

		forEachCell (model.cs, function (cell)
			cell.cover = EMPTY
			cell.chemical = 0		
		end)

		-------------------------------------------------------------------
		-- DRAW NEST on the center
		-------------------------------------------------------------------
		center_cell = { x = model.SPACE_DIMENSION/2, y = model.SPACE_DIMENSION/2}
		nest_cell = model.cs:get(math.floor(center_cell.x), math.floor(center_cell.y))
		nest_cell.cover = NEST
		forEachNeighbor (nest_cell, function (nest_cell, neigh)
			neigh.cover = NEST
		end)

		-- Prepare the start cells for the ANTS
		right = { x = nest_cell.x + 2, y = nest_cell.y}
		left = { x = nest_cell.x -2, y = nest_cell.y}
		up = { x = nest_cell.x, y = nest_cell.y - 2}
		down = { x = nest_cell.x, y = nest_cell.y + 2}	
		nest_cell_right = model.cs:get(right.x, right.y)
		nest_cell_left = model.cs:get(left.x, left.y)
		nest_cell_up = model.cs:get(up.x, up.y)
		nest_cell_down = model.cs:get(down.x, down.y)

		-------------------------------------------------

		-------------------------------------------------------------------
		-- DRAW 3 pieces of food
		-------------------------------------------------------------------
		
		function drawFood(x, y)
			coordf1 = { x = x, y = y}
			cell = model.cs:get(math.floor(coordf1.x), math.floor(coordf1.y))
			cell.cover = FOOD
			forEachNeighbor (cell, function (cell, neigh)
				neigh.cover = FOOD
				forEachNeighbor (neigh, function (neig, neigh2)
					neigh2.cover = FOOD
				end)
			end)
		end
		
		drawFood(model.SPACE_DIMENSION/8, model.SPACE_DIMENSION/8)
		
		drawFood(model.SPACE_DIMENSION/7, model.SPACE_DIMENSION*3/4)
		
		drawFood(model.SPACE_DIMENSION*3/4, model.SPACE_DIMENSION/3)
		
		drawFood(model.SPACE_DIMENSION*3/4, model.SPACE_DIMENSION*4/5)
		
		function getNextCoordinateTowardDestiny(cell, destiny)
					
			-- Search next coordinate X to come bak to the nest
			if (cell.x < destiny.x) then
				new_x = cell.x + 1
			elseif (cell.x > destiny.x) then
				new_x = cell.x - 1
			else
				new_x = cell.x
			end
			
			-- Search next coordinate Y to come bak to the nest
			if (cell.y < destiny.y) then
				new_y = cell.y + 1
			elseif (cell.y > destiny.y) then
				new_y = cell.y - 1
			else
				new_y = cell.y
			end
		
			return { x = new_x, y = new_y}
		end
		
		function moveAnts(agent)
			if agent.state == SEARCHING_FOOD then
			
				if (findFood(agent)==false) then
					
					cell = agent:getCell()
					
					any_chem = false
					
					-- If ANT find lesschemical go there
					forEachNeighbor (cell, function (cell, neigh)
							if neigh.cover == LESSCHEM and not any_chem then
								cell.cover = EMPTY
								agent:move(neigh)
								--neigh.cover = ANT
								any_chem = true
							end
					end)
				
					-- If ANT find chemical go there
					forEachNeighbor (cell, function (cell, neigh)
							if neigh.cover == CHEMICAL and not any_chem then
								cell.cover = EMPTY
								agent:move(neigh)
								--neigh.cover = ANT
								any_chem = true
							end
					end)
					
					if ( any_chem == false) then
						if ( agent.dest ~=nil) then	
							goto_cell(agent)
						else
							agent.dest = model.cs:sample()
							goto_cell(agent)
						end
					end					
				end	

			elseif agent.state == BRINGING_FOOD then  
				
				if (findNest(agent)  == false) then
					
					cell = agent:getCell()
			
					new_coord = getNextCoordinateTowardDestiny(cell, nest_cell)
					new_cell = model.cs:get(new_coord.x, new_coord.y)
					
					if (new_cell.cover ~= FOOD) and (new_cell.cover ~= NEST) then
						agent:getCell().cover = CHEMICAL	
						agent:getCell().chemical = agent:getCell().chemical + model.rateDiffusion
						
						forEachNeighbor (cell, function (cell, neigh)
							if (neigh.cover ~= FOOD) and (neigh.cover ~= NEST) and (neigh.cover ~= CHEMICAL) then
								neigh.chemical = neigh.chemical + (model.rateDiffusion / 2)
								if (neigh.chemical > 0) and (neigh.chemical <= 1) then
									neigh.cover = LESSCHEM
								elseif (neigh.chemical>1) then
									neigh.cover = CHEMICAL
								end
							end
						end)
						
						agent:move(new_cell)
						new_cell.cover = ANT
						
					elseif new_cell.cover == FOOD then
						cell = agent:getCell():getNeighborhood():sample()
						if cell.cover == EMPTY then
							agent:move(cell)
							cell.cover = ANT
						end
					end
				
				end
				
			end	
				
		end

		-- Searching for FOOD
		function findFood(agent) 
			cell = agent:getCell()
			forEachNeighbor (cell, function (cell, neigh)
				if neigh.cover == FOOD then
					neigh.cover = CHEMICAL
					
					cell = agent:getCell()
					forEachNeighbor (cell, function (cell, neigh)
						if (neigh.cover ~= FOOD) and (neigh.cover ~= NEST) then
							neigh.cover = CHEMICAL
							neigh.chemical = neigh.chemical + model.rateDiffusion
							forEachNeighbor (neigh, function (neigh, neigh2)
								if (neigh2.cover ~= FOOD) and (neigh2.cover ~= NEST) then
									neigh2.cover = LESSCHEM
									neigh2.chemical = neigh2.chemical + model.rateDiffusion/2
							
								end
							end)
						end
					end)
					
					agent.state = BRINGING_FOOD
					model.cs.food = model.cs.food - 1
					return true
				end
				
			end)
			return false
		end

		-- Checks if NEST has been found
		function findNest(agent) 
			cell = agent:getCell()
			forEachNeighbor (cell, function (cell, neigh)
				if neigh.cover == NEST then
					agent.state = SEARCHING_FOOD
					return true
				end
				
			end)
			return false
		end

		function goto_cell(agent)
			dest = agent.dest
			cell = agent:getCell()
				
			new_coord = getNextCoordinateTowardDestiny(cell, dest)
			new_cell = model.cs:get(new_coord.x, new_coord.y)
				
			if (new_cell.cover ~= FOOD) and (new_cell.cover ~= NEST) then
				agent:move(new_cell)
				new_cell.cover = ANT
				cell.cover = EMPTY
			else
				new_cell = agent:getCell():getNeighborhood():sample()
				if (new_cell.cover ~= FOOD) and (new_cell.cover ~= NEST) then
					agent:move(new_cell)
					new_cell.cover = ANT
					cell.cover = EMPTY
				end
			end
			
			if (new_cell == dest) then
				agent.dest = nil
			end
		end

		------------
		--# TIME #--
		------------

		function myTimePrinter( ) 
			print(t:getTime().." "..model.COUNTER_FOOD)
		end

		function chemicalEvaporation() 
			forEachCell (model.cs, function (cell)
				if cell.chemical > 0 then	
					cell.chemical = cell.chemical - model.rateEvaporation
				end
				if cell.chemical <= 0 and (cell.cover == CHEMICAL or cell.cover == LESSCHEM) then
					cell.cover = EMPTY
				elseif cell.chemical < 1 and cell.cover == CHEMICAL then
					cell.cover = LESSCHEM
				end			
			end) 
		end		
		
		----------------
		--# BEHAVIOR #
		----------------

		familyAnt = Agent {
			-- initialize the agent internal state
			init = function (self)
				self.state = SEARCHING_FOOD
				self.parent = soc
				self.dest = nil
			end,

			execute = function (self)
				moveAnts(self)
				--[[ Uncomment for stopping simulation when last food is taken
				if model.cs.food > 0 then
					moveAnts(self)
				end
				if model.cs.food == 0 and model.lastFoodTime == MAX_TIME then
					model.lastFoodTime = model.timer.time
				end
				]]--
			end
		}

		soc = Society {
			instance = familyAnt, 
			quantity = model.societySize
		}

		map = Map{
			target = model.cs,
			select = "cover",
			value = {EMPTY, FOOD, NEST, CHEMICAL, LESSCHEM, ANT},
			color = {"brown", "blue", "red", "green", "darkGreen", "black"}
		}
		
			
		-------------------------------------------
		--# ENVIRONMENT ( SCALE or VIRTUAL WORLD) #
		-------------------------------------------

		-- creates the virtual world 
		-- before add agents to a environment, add all cellular space the will need
		env = Environment {model.cs, soc, t}

		-- how agents will be placed inside a environment
		env:createPlacement {
			strategy = "void"
		}
		
        chart = Chart{
			target = model.cs
		}
		
		model.cell = model.cs
        model.timer = Timer {
			Event {time = 1, period = 1, action = soc},
			Event {time = 1, period = 1, action = chemicalEvaporation},
			Event {time = 1, period = 1, action = function (ev) 
				model.cs:synchronize()
			end},
			Event {time = 1, period = 1, action = map}
		}
		-- initialize cells with the same color of agents living on it 
		forEachAgent (soc, function (agent)
			
			random_start = math.random(1,4)
			
			if (random_start == 1) then
				agent:enter(nest_cell_right)
			elseif (random_start == 2) then
				agent:enter(nest_cell_left)
			elseif (random_start == 3) then
				agent:enter(nest_cell_up)
			elseif (random_start == 4) then
				agent:enter(nest_cell_down)
			end

		end)
	end

}

ants = AntsModel{societySize=50, rateDiffusion=5, rateEvaporation=0.5}
ants:run()
