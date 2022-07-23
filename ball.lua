-- ## Set Variables
local AI = require 'ai'
local Player = require 'player'
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
	self:collide(dt)
end

-- ## Draw
function Ball:draw()
	love.graphics.draw(self.img, self.x, self.y, 0, SCALE, SCALE)
end

-- ## Functions
--- ### Collision Detection
function Ball:collide()
	self:collideWall()
	self:collidePlayer()
	self:collideAI()
	self:score()
end

--- Wall
function Ball:collideWall()
	if self.y < 0 then
		self.y = 0
		self.yVel = -self.yVel
		self.hitWall:play()
	elseif self.y + self.height > love.graphics.getHeight() then
		self.y = love.graphics.getHeight() - self.height
		self.yVel = -self.yVel
		self.hitWall:play()
	end
end

--- Player
function Ball:collidePlayer()
	if checkCollision(self, Player) then
		self.xVel = self.speed
		local middleBall = self.y + self.height /2
		local middlePlayer = Player.y + Player.height /2
		local collisionPosition = middleBall - middlePlayer
		self.yVel = collisionPosition * 5
		self:increaseSpeed()
		self.hitPlayer:play()
	end
end

--- AI
function Ball:collideAI()
	if checkCollision(self, AI) then
		self.xVel = -self.speed
		local middleBall = self.y + self.height /2
		local middleAI = AI.y + AI.height /2
		local collisionPosition = middleBall - middleAI
		self.yVel = collisionPosition * 5
		self:increaseSpeed()
		self.hitPlayer:play()
	end
end

-- Movement
function Ball:move(dt)
	self.x = self.x + self.xVel * dt
	self.y = self.y + self.yVel * dt
end

-- Reset
function Ball:resetPosition(modifier)
	self.x = love.graphics.getWidth() / 2 - self.width / 2
	self.y = love.graphics.getHeight() / 2 - self.height / 2
	self.speed = self.default_speed
	self.yVel = 0
	self.xVel = self.speed
end

-- Score
function Ball:score()
	if self.x < 0 then
		self:resetPosition(1)
		Game.score.ai = Game.score.ai + 1
	end

	if self.x + self.width > love.graphics.getWidth() then
		self:resetPosition(-1)
		Game.score.player = Game.score.player + 1
	end
end

--- Speed
function Ball:increaseSpeed()
	self.speed = self.speed + (20 * Settings.difficulty)
end

return Ball
