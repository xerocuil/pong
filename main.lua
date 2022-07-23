-- ## Set Filter
love.graphics.setDefaultFilter("nearest", "nearest")

-- ## Input Config
Controls = require 'lib/baton'

Input = Controls.new {
  controls = {
    up = {'key:up', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'axis:lefty+', 'button:dpdown'},
    select = {'key:space', 'button:a'},
    start = {'key:return', 'button:start'},
    exit = {'key:escape', 'button:back'},
    fullscreen = {'key:f11', 'button:y'}
  },
  joystick = love.joystick.getJoysticks()[1],
  deadzone = .33,
}

-- ## Init Game Table
Game = {}
Game = {
	state = "title",
	score = {player = 0, ai = 0},
	winner = "none"
}

-- ## Set Variables
local AI = require 'ai'
local Background = require 'background'
local Ball = require 'ball'
local Menu = require 'menu'
local Player = require 'player'
local Settings = require 'settings'

-- ## Load
function love.load()
  -- Fonts
	font = love.graphics.newFont('assets/digital-disco-thin.ttf', 20 * SCALE)
	titleFont = love.graphics.newFont('assets/digital-disco.ttf', 64 * SCALE)

	--- Classes
	AI:load()
	Background:load()
	Ball:load()
	Player:load()
	TitleMenu:load()
end

-- ## Update
function love.update(dt)
	Input:update()
	exitGame()
	fullscreen(fullscreen)
	start()

	if Game.state == "game" then
		Background:update(dt)
		AI:update(dt)
		Ball:update(dt)
		Player:update(dt)
		AIMovement(dt)
		checkScore()
	elseif Game.state == "title" then
		Background:update(dt)
	elseif Game.state == "game_over" then
		Background:update(dt)
    resetGame()
	end

	if love.window.getFullscreen() then
		print(love.window.getFullscreen())
	end
end

-- ## Draw
function love.draw()
	if Game.state == "title" then
		Background:draw()
		TitleMenu:draw()
	elseif Game.state == "game" then
		Background:draw() -- Draw background first to not cover up sprites.
		Player:draw()
		Ball:draw()
		AI:draw()
		drawScore()
	elseif Game.state == "paused" then
		Background:draw()
    Player:draw()
    Ball:draw()
    AI:draw()
		pauseMenu()
	elseif Game.state == "game_over" then
		Background:draw()
		gameOverScreen()
	end
end

-- ## Functions
--- Scoreboard
function drawScore()
	love.graphics.setFont(font)
	love.graphics.print("Player: "..Game.score.player, 50, 50)
	love.graphics.print("CPU: "..Game.score.ai, love.graphics.getWidth() - 150, 50)
end

function checkScore()
	if Game.score.player == Settings.match_win then
		Game.winner = "Player"
		Game.state = "game_over"
	elseif Game.score.ai == Settings.match_win then
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

-- ## Input
--- Start
function start()
	if Input:pressed 'start' then
		if Game.state == "game" then
			Game.state = "paused"
		elseif Game.state == "paused" or Game.state == "title"then
			Game.state = "game"
		elseif Game.state == "game_over" then
      resetGame()
    end
	end
end

--- Fullscreen
function fullscreen()
  if Input:pressed 'fullscreen' then
    if love.window.getFullscreen() then
      love.window.setMode(W_WIDTH, W_HEIGHT)
    else
      love.window.setFullscreen(true, "exclusive")
    end
  end
end

-- Restart
function resetGame()
  if Input:pressed 'start' then
    Game = {state = "title", score = {player = 0, ai = 0}, winner = "none"}
    Player.x = Player.default_x
    Player.y = Player.default_y
    AI.y = AI.default_x
    AI.y = AI.default_y
    Game.state = "game"
  end
end

--- Exit
function exitGame()
  if Input:pressed 'exit' then
    love.event.quit()
  end
end

-- -- ## Version check
-- local loveversion = string.format("%02d.%02d.%02d", love._version_major, love._version_minor, love._version_revision)
-- if loveversion < "00.10.01" then
--   error("You have an outdated version of Love! Get 0.10.1 or higher and retry.")
-- end
