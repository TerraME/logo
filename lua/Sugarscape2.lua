
Sugarscape = Model{
    finalTime = 1000,
    init = function(model)
        model.cs = getSugar("default")

        model.cs:createNeighborhood{}
       
        forEachCell(model.cs, function(cell)
            cell.sugar = cell.maxSugar
        end)
    
        model.cs.execute = function()
            forEachCell(model.cs, function(cell)
                cell.sugar = cell.sugar + 1
                
                if cell.sugar > cell.maxSugar then
                    cell.sugar = cell.maxSugar
                end
            end)
        end
       
        model.agent = Agent{
            sugar = 10,
            execute = function(self)
                local cell = self:getCell()
                local neighs = {cell}
                
                forEachNeighbor(self:getCell(), function(c, n)
                    if n.sugar > neighs[1].sugar and n:isEmpty() then
                        neighs = {n}
                    elseif n.sugar == neighs[1].sugar and n:isEmpty() then
                        table.insert(neighs, n)
                    end
                end)
                
                self:move(Random(neighs):sample())
                
                self.sugar = self.sugar + self:getCell().sugar
                self:getCell().sugar = 0
                
                self.sugar = self.sugar - 1
                
                if self.sugar < 0 then
                    self:die()
                elseif self.sugar > 100 then
                    child = self:reproduce()
                    self.sugar = self.sugar / 2
                    child.sugar = self.sugar
                end
            end
        }
            
        model.society = Society{
            instance = model.agent,
            quantity = 100,
            wealth = function(self)
                sum = 0
                
                forEachAgent(self, function(agent)
                    sum = sum + agent.sugar
                end)
            
                return sum / #self
            end
        }
       
        model.chart2 = Chart{
            target = model.society
        }
       
        model.chart1 = Chart{
            target = model.society,
            select = "wealth"
        }
       
        model.env = Environment{
            model.cs,
            model.society
        }
        
        model.env:createPlacement{}

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

       model.timer = Timer{
           Event{action = model.cs},
           Event{action = model.map1},
           Event{action = model.map2},
           Event{action = model.society},
           Event{action = model.chart1},
           Event{action = model.chart2}
       }
    end
}

Sugarscape:run()
