-- ## Set Filter
love.graphics.setDefaultFilter("nearest", "nearest")

-- ## Set Variables
local AI = require("ai")
local Background = require("background")
local Ball = require("ball")
local Player = require("player")
local Settings = require("settings")

game_state = "title"
game_winner = ""

-- ## Load
function love.load()
	AI:load()
	Background:load()
	Ball:load()
	Player:load()
	Score = {player = 0, ai = 0}
	font = love.graphics.newFont(30)
end

-- ## Update
function love.update(dt)
	Player:update(dt)
	Ball:update(dt)
	AI:update(dt)
	Background:update(dt)

	checkScore()

	if AI.timer > AI.rate then
		AI.timer = 0
		acquireTarget()
	end
end

-- ## Draw
function love.draw()
	if game_state == "title" then
		Background:draw()
		titleScreen()
	elseif game_state == "game" then
		Background:draw() -- Draw background first to not cover up sprites.
		Player:draw()
		Ball:draw()
		AI:draw()
		drawScore()
	elseif game_state == "game_over" then
		Background:draw()
		gameOverScreen()
	end
end

-- ## Functions
--- Title Screen
function titleScreen()
	love.graphics.setFont(font)
	love.graphics.print("Pong")
end

--- Game Over
function gameOverScreen()
	love.graphics.setFont(font)
	love.graphics.print("Game Over\n" .. game_winner .. " Wins")
end

--- Scoreboard
function drawScore()
	love.graphics.setFont(font)
	love.graphics.print("Player: "..Score.player, 50, 50)
	love.graphics.print("CPU: "..Score.ai, love.graphics.getWidth() - 150, 50)
end

function checkScore()
	if Score.player == Settings.match_win then
		game_winner = "Player"
		game_state = "game_over"
	elseif Score.ai == Settings.match_win then
		game_winner = "CPU"
		game_state = "game_over"
	end
end

--- AI Acquire Target
function acquireTarget()
	if Ball.y + Ball.height < AI.y then
		AI.yVel = -AI.speed
	elseif Ball.y > AI.y + AI.height then
		AI.yVel = AI.speed
	else
		AI.yVel = 0
	end
end

--- Check Collision
function checkCollision(a, b)
	if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
		return true
	else
		return false
	end
end
