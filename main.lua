-- ## Version check
local loveversion = string.format("%02d.%02d.%02d", love._version_major, love._version_minor, love._version_revision)
if loveversion < "00.10.01" then
	error("You have an outdated version of Love! Get 0.10.1 or higher and retry.")
end

-- ## Set Filter
love.graphics.setDefaultFilter("nearest", "nearest")

-- ## Set Variables
local AI = require 'ai'
local Background = require 'background'
local Ball = require 'ball'
local Stage = require 'stage'
local Player = require 'player'
local Settings = require 'settings'

Game = {}
Game = {state = "title", winner = ""}

-- ## Load
function love.load()
	AI:load()
	Background:load()
	Ball:load()
	Player:load()
	
	Score = {player = 0, ai = 0}
	font = love.graphics.newFont('assets/digital-disco-thin.ttf', 48)
	titleFont = love.graphics.newFont('assets/digital-disco.ttf', 128)
end

-- ## Update
function love.update(dt)
	if Game.state == "game" then
		Player:update(dt)
		Ball:update(dt)
		AI:update(dt)
		AIMovement(dt)
		checkScore()
		Background:update(dt)
	elseif Game.state == "title" then
		Background:update(dt)
		Player:update(dt)
	elseif Game.state == "game_over" then
		Background:update(dt)
		Player:update(dt)
	end
end

-- ## Draw
function love.draw()
	if Game.state == "title" then
		Background:draw()
		titleScreen()
	elseif Game.state == "game" then
		Background:draw() -- Draw background first to not cover up sprites.
		Player:draw()
		Ball:draw()
		AI:draw()
		drawScore()
	elseif Game.state == "game_over" then
		Background:draw()
		gameOverScreen()
	end
end

-- ## Functions
--- Title Screen
function titleScreen()
	love.graphics.setFont(titleFont)
	love.graphics.printf("Pong", 0, 200, love.graphics.getWidth(), "center")
	love.graphics.setFont(font)
	love.graphics.printf("Press Start to begin", 0, 400, love.graphics.getWidth(), "center")
end

--- Game Over
function gameOverScreen()
	love.graphics.setFont(titleFont)
	love.graphics.printf("Game Over", 0, 200, love.graphics.getWidth(), "center")
	love.graphics.setFont(font)
	love.graphics.printf("Press Start to restart", 0, 400, love.graphics.getWidth(), "center")
	Score = {player = 0, ai = 0}
	Player.x = Player.default_x
	Player.y = Player.default_y
end

--- Scoreboard
function drawScore()
	love.graphics.setFont(font)
	love.graphics.print("Player: "..Score.player, 50, 50)
	love.graphics.print("CPU: "..Score.ai, love.graphics.getWidth() - 150, 50)
end

function checkScore()
	if Score.player == Settings.match_win then
		Game.winner = "Player"
		Game.state = "game_over"
	elseif Score.ai == Settings.match_win then
		Game.winner = "CPU"
		Game.state = "game_over"
	end
end

--- AI
---- Acquire Target
function acquireTarget()
	if Ball.y + Ball.height < AI.y then
		AI.yVel = -AI.speed
	elseif Ball.y > AI.y + AI.height then
		AI.yVel = AI.speed
	else
		AI.yVel = 0
	end
end
---- Movement
function AIMovement(dt)
	if AI.timer > AI.rate then
		AI.timer = 0
		acquireTarget()
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
