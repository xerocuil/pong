-- ## Init/Load Player
local Player = {}

function Player:load()
	self.default_x = 50
	self.default_y = love.graphics.getHeight() / 2
	self.x = self.default_x
	self.y = self.default_y
	self.img = love.graphics.newImage("assets/1.png")
	self.width = self.img:getWidth() * SCALE
	self.height = self.img:getHeight() * SCALE
	self.speed = 500
end

-- ## Update
function Player:update(dt)
	self:move(dt)
	self:checkBoundaries()
end

-- ## Draw
function Player:draw()
	love.graphics.draw(self.img, self.x, self.y, 0, SCALE, SCALE)
end

-- ## Functions
--- Check Boundaries
--- Stop player at top height / bottom height minus player height
function Player:checkBoundaries()
	if self.y < 0 then 
		self.y = 0
	elseif self.y + self.height > love.graphics.getHeight() then
		self.y = love.graphics.getHeight() - self.height
	end
end

--- ### Player Input
---- Player Movement
function Player:move(dt)
	if Input:down 'up' then
		self.y = self.y - self.speed * dt
	elseif Input:down 'down' then
		self.y = self.y + self.speed * dt
	end
end

return Player
