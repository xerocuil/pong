Player = {}

function Player:load()
	self.x = 50
	self.y = love.graphics.getHeight() / 2
	self.img = love.graphics.newImage("assets/1.png")
	self.width = self.img:getWidth()
	self.height = self.img:getHeight()
	self.height = 100
	self.speed = 500
end

function Player:update(dt)
	self:move(dt)
	self:checkBoundaries()
end

function Player:move(dt) -- Player movement
	if love.keyboard.isDown("w") then
		self.y = self.y - self.speed * dt
	elseif love.keyboard.isDown("s") then
		self.y = self.y + self.speed * dt
	end
end

function Player:checkBoundaries() -- Keep Player in-bounds
	if self.y < 0 then --- Stop player at top
		self.y = 0
	elseif self.y + self.height > love.graphics.getHeight() then -- Stop player at bottom height minus player height
		self.y = love.graphics.getHeight() - self.height
	end
end

function Player:draw()
	love.graphics.draw(self.img, self.x, self.y)
end