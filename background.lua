-- ## Init Background
local Background = {}

-- ## Load
function Background:load()
	self.mainBackground = love.graphics.newImage("assets/mainBackground.jpg")
	self.mainForeground = love.graphics.newImage("assets/mainForeground.png")
	self.width = self.mainForeground:getWidth()
	self.height = self.mainForeground:getHeight()
	self.rotation = 0
end

-- ## Update
function Background:update(dt)
	self.rotation = self.rotation + 0.01 * dt
end

-- ## Draw
function Background:draw()
	love.graphics.draw(self.mainBackground, 0, 0)
	love.graphics.draw(self.mainForeground, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, self.rotation, 1, 1, self.width / 2, self.height / 2)
end

return Background
