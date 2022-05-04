require("ai")
require("background")
require("ball")
require("player")

function love.load()
	Player:load()
	Ball:load()
	AI:load()
	Background:load()
	Score = {player = 0, ai = 0}
	font = love.graphics.newFont(30)
end

function love.update(dt)
	Player:update(dt)
	Ball:update(dt)
	AI:update(dt)
	Background:update(dt)
end

function love.draw()
	Background:draw() -- Draw background first to not cover up sprites.
	Player:draw()
	Ball:draw()
	AI:draw()
	drawScore()
end

function drawScore()
	love.graphics.setFont(font)
	love.graphics.print("Player: "..Score.player, 50, 50)
	love.graphics.print("CPU: "..Score.ai, love.graphics.getWidth() - 150, 50)
end

function checkCollision(a, b)
	if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
		return true
	else
		return false
	end

end
