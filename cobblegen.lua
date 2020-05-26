local arg = {...}

local component = require("component")
local robot = require("robot")
local computer = component.computer
local inventory = component.inventory_controller
local sides = require("sides")

-- water bucket slot
local water = 13

-- lava bucket slot
local lava = 14

-- chests slot
local chest = 15

-- blocks slot
local blocks = 16
local requiredBlocks = 32

function validateSlot( index, type, num)

  local n = robot.count(index)
  if num > n then
    print(num, ",", n)
    return false
  end

  return true
end

function validateInventory()

  local v = true
  
  v = v and validateSlot(water, "Water Bucket", 1)  
  v = v and validateSlot(lava, "Lava Bucket", 1)
  v = v and validateSlot(chest, "Oak Chest", 1)
  v = v and validateSlot(blocks, "Cobblestone", requiredBlocks)

  if not v then
    print("Pleace place the following in the given order in")
    print("the bottom four slots of the robots inventory.")
    print("1 bucket of water")
    print("1 bucket of lava")
    print("At least one oak chest")
    print("At least 16 cobblestone")
  end

  return v  

end

function buildGenerator()
  robot.select(blocks)

-- 1,2  
  robot.forward() 
  robot.turnRight()
  robot.place()    

-- 1,1
  robot.turnRight()
  robot.place()

-- 1,2
  robot.turnRight()
  robot.place()

-- 1,3
  robot.turnRight()  
  robot.forward()
  robot.turnRight()
  robot.place()

-- 1,2 
  robot.turnRight()
  robot.place()

-- 1,3
  robot.turnRight()
  robot.place()

-- 1,4
  robot.turnRight() 
  robot.forward()
  robot.turnRight()
  robot.select(chest)
  robot.place()
  robot.select(blocks)

 
-- 1,4
  robot.turnAround()
  robot.place()

-- 1,6  
  robot.turnRight()
  robot.forward()
  robot.place()

-- 1,5
  robot.turnRight()
  robot.place()

-- 1,5
  robot.turnAround()
  robot.place()

-- 2,5
  robot.up()
  robot.place()

-- 2,6
  robot.turnRight()
  robot.place()

-- 2,5
  robot.turnRight()
  robot.place()

-- 1,5
  robot.turnRight()
  robot.placeDown()

-- 2,3
  robot.forward()
  robot.forward()
  robot.turnRight()
  robot.place()

-- 2,3
  robot.turnAround()
  robot.place()

-- 2,1
  robot.turnRight()
  robot.forward()
  robot.place()

-- 2,2
  robot.turnRight()
  robot.place()
  
-- 2,2
  robot.turnAround()
  robot.place()

-- lava
  robot.turnRight()
  robot.back()
  robot.select(water)
  inventory.equip()
  robot.use()  
  inventory.equip()

-- water
  robot.turnAround()
  robot.forward()
  robot.select(lava)
  inventory.equip()
  robot.use()
  inventory.equip()

-- sit
  robot.turnLeft()
  robot.back()

end

function destroyGenerator()

-- break

  robot.select(2)  
  
  repeat
    robot.swing()
  until robot.forward()

-- lava
  robot.turnRight()
  robot.select(lava)
  inventory.equip()
  robot.use()
  inventory.equip()

-- water
  robot.turnAround()
  robot.forward()
  robot.select(water)
  inventory.equip()
  robot.use()
  inventory.equip()
  
-- 2,1
  robot.select(blocks)
  robot.forward()
  robot.swing()

-- 2,2
  robot.turnLeft()
  robot.swing()

-- 2,2 
  robot.turnAround()
  robot.swing()

-- 2,3
  robot.turnRight()
  robot.forward()
  robot.turnLeft()
  robot.swing()

-- 2,3
  robot.turnAround()
  robot.swing()

--2,6
  robot.turnLeft()
  robot.forward()
  robot.forward()
  robot.swing()

-- 2,5
  robot.turnLeft()
  robot.swing()

-- 2,5
  robot.turnAround()
  robot.swing()

-- 1,5
  robot.swingDown()

-- 1,5
  robot.down()
  robot.swing()

-- 1,6
  robot.turnLeft()
  robot.swing()

-- 1,5
  robot.turnLeft()
  robot.swing()

-- 1,4
  robot.turnLeft()
  robot.forward()
  robot.turnRight()
  robot.swing()

-- 1,2
  robot.turnLeft()
  robot.forward()
  robot.swing()

-- 1,3
  robot.turnLeft()
  robot.swing()

-- 1.3
  robot.turnAround()
  robot.swing()

-- 1,1
  robot.turnLeft()
  robot.forward()
  robot.swing()

-- 1,2
  robot.turnLeft()
  robot.swing()

-- 1,2
  robot.turnAround()
  robot.swing()

-- sit
  robot.turnRight()
  robot.back()

end

local demo = false
local count = 0

function placeOutput()

  if demo then
    if count > 1 then
      return false
    end
    count = count + 1
  end
  
  return robot.dropDown(robot.count())

end

function mineTillFull()

  robot.select(1)
  local r = 0
  if demo then
    r = 54
  end

  repeat
    
    repeat
      robot.swing()
      os.sleep(0.1)
    until robot.space() <= r

  until not placeOutput()   

end

if arg then
  demo = arg[1] == "demo"
  if demo then
    print("Running in demo mode")
  end
end

if validateInventory() then
 
  buildGenerator()
 
  mineTillFull()

  destroyGenerator()

end
