-- ## Set Filter
love.graphics.setDefaultFilter("nearest", "nearest")

-- ## Set Variables
local Controls = require 'lib/baton'

-- ## Input Config
local Input = Controls.new {
  controls = {
    up = {'key:up', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'axis:lefty+', 'button:dpdown'},
    select = {'key:space', 'button:a'},
    exit = {'key:escape', 'button:back'}
  },
  joystick = love.joystick.getJoysticks()[1],
  deadzone = .33,
}

-- ## Init Player
local Player = {}
Player = {default_x = 50, default_y = love.graphics.getHeight() / 2}

-- ## Load
function Player:load()
	self.x = self.default_x
	self.y = self.default_y
	self.img = love.graphics.newImage("assets/1.png")
	self.width = self.img:getWidth()
	self.height = self.img:getHeight()
	self.height = 100
	self.speed = 500
end

-- ## Update
function Player:update(dt)
	self:move(dt)
	self:start(dt)
	self:exitGame()
	self:checkBoundaries()
	Input:update()
end

-- ## Draw
function Player:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

-- ## Functions
--- Check Boundaries
function Player:checkBoundaries() -- Keep Player in-bounds
	if self.y < 0 then --- Stop player at top
		self.y = 0
	elseif self.y + self.height > love.graphics.getHeight() then -- Stop player at bottom height minus player height
		self.y = love.graphics.getHeight() - self.height
	end
end

-- ### Player Input
--- Player Movement
function Player:move(dt)
	if Input:down 'up' then
		self.y = self.y - self.speed * dt
	elseif Input:down 'down' then
		self.y = self.y + self.speed * dt
	end
end

--- Menu
function Player:start(dt)
	if Input:down 'select' then
		Game.state = "game"
	end
end

--- Exit
function Player:exitGame()
  if Input:down 'exit' then
    love.event.push('quit')
  end
end

return Player
