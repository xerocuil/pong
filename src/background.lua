Background = {}

function Background:load()
	self.mainBackground = love.graphics.newImage("assets/mainBackground.png")
	self.mainForeground = love.graphics.newImage("assets/mainForeground.png")
	self.width = self.mainForeground:getWidth()
	self.height = self.mainForeground:getHeight()
	self.rotation = 0
end


function Background:update(dt)
	self.rotation = self.rotation + 0.05 * dt
end


function Background:draw()
	love.graphics.draw(self.mainBackground, 0, 0)
	love.graphics.draw(self.mainForeground, self.width / 2, self.height / 2, self.rotation, 1, 1, self.width / 2, self.height / 2)
end