-- ## Set Variables
local Settings = require("settings")

local AI = {}

function AI:load()
	self.img = love.graphics.newImage("assets/2.png")
	self.width = self.img:getWidth()
	self.height = self.img:getHeight()
	self.x = love.graphics.getWidth() - self.width - 50
	self.y = love.graphics.getHeight() / 2
	self.yVel = 0
	self.speed = 500 * (((Settings.difficulty - 1) / 10) + 1)
	self.timer = 0
	self.rate = 0.5 / Settings.difficulty
end

function AI:update(dt)
	self:checkBoundaries()
	self:move(dt)
	self.timer = self.timer + dt
end

function AI:move(dt)
	self.y = self.y +self.yVel * dt
end

function AI:checkBoundaries() -- Keep AI in-bounds
	if self.y < 0 then -- Stop AI at top
		self.y = 0
	elseif self.y + self.height > love.graphics.getHeight() then -- Stop AI at bottom height minus AI height
		self.y = love.graphics.getHeight() - self.height
	end
end

function AI:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

return AI
