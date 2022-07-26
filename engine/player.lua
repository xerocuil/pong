-- ## Init Player/ActivePlayer tables
local Player = {}
Player.__index = Player
local ActivePlayer = {}

function Player:load()
  -- ## Player.new def
  function Player.new(name, color)
    local instance = setmetatable({}, Player)
    instance.name = name
    instance.type = "human"
    instance.default_x = 50
    instance.default_y = love.graphics.getHeight() / 2
    instance.x = instance.default_x
    instance.y = instance.default_y
    instance.color = color
    instance.img = love.graphics.newImage("assets/paddles/"..instance.color..".png")
    instance.width = instance.img:getWidth() * SCALE
    instance.height = instance.img:getHeight() * SCALE
    instance.yVel = 0
    instance.speed = 500
    instance.timer = 0
    instance.rate = 0.5 / Settings.difficulty
    table.insert(ActivePlayer, instance)
  end


  -- ## Init Players
  Player.new("Player 1", "red")

  if Game.type == "1P" then
    Player.new("CPU", "green")
    ActivePlayer[2].type = "ai"
    ActivePlayer[2].timer = 0
    ActivePlayer[2].rate = 0.5 / Settings.difficulty
    ActivePlayer[2].speed = 500 * (((Settings.difficulty - 1) / 10) + 1)
  elseif Game.type == "2P" then
    Player.new("Player 2", "blue")
  end

  Player1 = ActivePlayer[1]
  Player2 = ActivePlayer[2]

  --- Set Player 2 Position
  Player2.default_x = love.graphics.getWidth() - Player2.width - 50
  Player2.x = Player2.default_x
end


-- ## Update
function Player:update(dt)
  self:checkBoundaries()
end

function Player:updateAll(dt)
  for i, instance in ipairs(ActivePlayer) do
    instance:update(dt)
  end
end


-- ## Draw
function Player:draw()
  love.graphics.draw(self.img, self.x, self.y, 0, SCALE, SCALE)
end

function Player:drawAll()
  for i,instance in ipairs(ActivePlayer) do
    instance:draw()
  end
end


-- ## Functions
--- Check boundaries
--- Stop player at top height / bottom height - player height
function Player:checkBoundaries()
  if self.y < 0 then 
    self.y = 0
  elseif self.y + self.height > love.graphics.getHeight() then
    self.y = love.graphics.getHeight() - self.height
  end
end

return Player
