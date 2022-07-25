-- ## Load Settings
local Settings = require 'settings'


-- ## Init/Load Ball
local Ball = {}

function Ball:load()
	self.x = love.graphics.getWidth() / 2
	self.y = love.graphics.getHeight() / 2
	self.img = love.graphics.newImage("assets/ball.png")
	self.width = self.img:getWidth() * SCALE
	self.height = self.img:getHeight() * SCALE
	self.default_speed = 200 * Settings.difficulty
	self.speed = self.default_speed
	self.xVel = -self.speed
	self.yVel = 0
	self.hitWall = love.audio.newSource("sounds/hitWall.wav", "static")
	self.hitPlayer = love.audio.newSource("sounds/hitPlayer.wav", "static")
end


-- ## Update
function Ball:update(dt)
	self:move(dt)
end


-- ## Draw
function Ball:draw()
	love.graphics.draw(self.img, self.x, self.y, 0, SCALE, SCALE)
end


-- ## Functions
--- Movement
function Ball:move(dt)
	self.x = self.x + self.xVel * dt
	self.y = self.y + self.yVel * dt
end

--- Speed
function Ball:increaseSpeed()
	self.speed = self.speed + (20 * Settings.difficulty)
end

return Ball
