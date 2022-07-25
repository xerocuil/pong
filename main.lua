-- ## Set Filter
love.graphics.setDefaultFilter("nearest", "nearest")


-- ## Set Libraries
Controls = require 'lib/baton'


-- ## Load Player Controls
Player1Input = Controls.new {
  controls = {
    up = {'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:s', 'axis:lefty+', 'button:dpdown'},
    start = {'key:return', 'button:start'},
    oneplayer = {'key:1', 'button:a'},
    twoplayers = {'key:2', 'button:x'},
    exit = {'key:escape', 'button:back'},
    fullscreen = {'key:f11', 'button:y'}
  },
  joystick = love.joystick.getJoysticks()[1],
  deadzone = .33,
}

Player2Input = Controls.new {
  controls = {
    up = {'key:up', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'axis:lefty+', 'button:dpdown'},
    twoplayers = {'button:x', 'button:start'},
    exit = {'key:escape', 'button:back'},
  },
  joystick = love.joystick.getJoysticks()[2],
  deadzone = .33,
}


-- ## Init Game Table
Game = {}
Game = {
  state = "title",
  score = {player1 = 0, player2 = 0},
  winner = "none",
  type = "1P"
}


-- ## Set Classes
local Background = require 'background'
local Ball = require 'ball'
local Menu = require 'menu'
local Player = require 'player'
local Settings = require 'settings'
local Debug = require 'debug'


-- ## Load
function love.load()
  -- Fonts
  font = love.graphics.newFont('assets/digital-disco-thin.ttf', 20 * SCALE)
  titleFont = love.graphics.newFont('assets/digital-disco.ttf', 64 * SCALE)
  Background:load()
  Ball:load()
  Menu:loadTitle()
end


-- ## Update
function love.update(dt)
  Player1Input:update()
  Player2Input:update()
  exitGame()
  fullscreen(fullscreen)
  start()

  if Game.state == "game" then
    Background:update(dt)
    Ball:update(dt)
    Player:updateAll(dt)
    checkScore()
    collideAll()
    playerMove(dt)
    acquireTarget(dt)
    AIMovement(dt)
  elseif Game.state == "title" then
    Background:update(dt)
    oneplayer()
    twoplayers()
  elseif Game.state == "game_over" then
    Background:update(dt)
  end
end


-- ## Draw
function love.draw()
  printDebug()
  if Game.state == "title" then
    Background:draw()
    Menu:drawTitle()
  elseif Game.state == "game" then
    Background:draw() -- Draw background first to not cover up sprites.
    Ball:draw()
    Player:drawAll()
    drawScore()
  elseif Game.state == "paused" then
    Background:draw()
    Ball:draw()
    Menu:pauseMenu()
  elseif Game.state == "game_over" then
    Background:draw()
    Menu:gameOverScreen()
  end
end


-- ## Functions

--- Reset Game
function resetGame()
  --Game = {score = {player1 = 0, player2 = 0}, winner = "none"}
  Game.score.player1 = 0
  Game.score.player2 = 0
  Game.winner = "none"
  Player1.x = Player1.default_x
  Player1.y = Player1.default_y
  Player2.y = Player2.default_x
  Player2.y = Player2.default_y
  resetBall(1)
  Game.state = "game"
end


--- ### Scoring
---- Check Score
function checkScore()
  if Game.score.player1 == Settings.match_win then
    Game.winner = Player1.name
    Game.state = "game_over"
  elseif Game.score.player2 == Settings.match_win then
    Game.winner = Player2.name
    Game.state = "game_over"
  end
end

---- Player Score
function score()
  if Ball.x < 0 then
    resetBall(-1)
    Game.score.player2 = Game.score.player2 + 1
  end

  if Ball.x + Ball.width > love.graphics.getWidth() then
    resetBall(1)
    Game.score.player1 = Game.score.player1 + 1
  end
end

--- Reset
function resetBall(modifier)
  Ball.x = love.graphics.getWidth() / 2 - Ball.width / 2
  Ball.y = love.graphics.getHeight() / 2 - Ball.height / 2
  Ball.speed = Ball.default_speed
  Ball.yVel = 0
  Ball.xVel = Ball.speed * modifier
end

---- Draw Scoreboard
function drawScore()
  love.graphics.setFont(font)
  love.graphics.print(Player1.name..": "..Game.score.player1, 50, 50)
  love.graphics.print(Player2.name..": "..Game.score.player2, love.graphics.getWidth() - 200, 50)
end


--- ### Input

---- Player Movement
function playerMove(dt)
  if Player1.type == "human" then
    if Player1Input:down 'up' then
      Player1.y = Player1.y - Player1.speed * dt
    elseif Player1Input:down 'down' then
      Player1.y = Player1.y + Player1.speed * dt
    end
  elseif Player1.type == "ai" then
    Player1.y = Player1.y + Player1.yVel * dt
  end

  if Player2.type == "human" then
    if Player2Input:down 'up' then
      Player2.y = Player2.y - Player2.speed * dt
    elseif Player2Input:down 'down' then
      Player2.y = Player2.y + Player2.speed * dt
    end
  elseif Player2.type == "ai" then
    Player2.y = Player2.y + Player2.yVel * dt
  end
end

---- Start
function start()
  if Player1Input:pressed 'start' then
    if Game.state == "game" then
      Game.state = "paused"
    elseif Game.state == "paused" then
      Game.state = "game"
    elseif Game.state == "title" then
      resetGame()
      start1p()
    elseif Game.state == "game_over" then
      resetGame()
    end
  end
end

function oneplayer()
  if Player1Input:pressed 'oneplayer' then
    start1p()
  end
end

function twoplayers()
  if Player1Input:pressed 'twoplayers' then
    start2p()
  end
end

---- 1P Start
function start1p()
  resetGame()
  Game = {type = "1P", score = {player1 = 0, player2 = 0}, winner = "none"}
  Player2.type = "ai"
  Player2.name = "CPU"
  Player2.color = "green"
  Player2.img = love.graphics.newImage("assets/paddles/"..Player2.color..".png")
  Game.state = "game"
end

---- 2P Start
function start2p()
  resetGame()
  Game = {type = "2P", score = {player1 = 0, player2 = 0}, winner = "none"}
  Player2.type = "human"
  Player2.name = "Player 2"
  Player2.color = "blue"
  Player2.img = love.graphics.newImage("assets/paddles/"..Player2.color..".png")
  Game.state = "game"
  
end

---- Fullscreen
function fullscreen()
  if Player1Input:pressed 'fullscreen' then
    if love.window.getFullscreen() then
      love.window.setMode(W_WIDTH, W_HEIGHT)
    else
      love.window.setFullscreen(true, "exclusive")
    end
  end
end

---- Exit
function exitGame()
  if Player1Input:pressed 'exit' or Player2Input:pressed 'exit'  then
    if Game.state == "title" then
      love.event.quit()
    elseif Game.state == "paused" then
      resetGame()
      Game.state = "title"
    elseif Game.state == "game" then
      Game.state = "paused"
    elseif Game.state == "game_over" then
      Game.state = "title"
    end
  end
end

--- ### AI Movement

---- Acquire Target
function acquireTarget()
  if Player1.type == "ai" then
    if Ball.y + Ball.height < Player1.y then
      Player1.yVel = -Player1.speed
    elseif Ball.y > Player1.y + Player1.height then
      Player1.yVel = Player1.speed
    else
      Player1.yVel = 0
    end
  end

  if Player2.type == "ai" then
    if Ball.y + Ball.height < Player2.y then
      Player2.yVel = -Player2.speed
    elseif Ball.y > Player2.y + Player2.height then
      Player2.yVel = Player2.speed
    else
      Player2.yVel = 0
    end
  end
end
---- AIMovement
function AIMovement(dt)
  if Player1.type == "ai" then
    if Player1.timer > Player1.rate then
      Player1.timer = 0
      acquireTarget()
    end
  end
  if Player2.type == "ai" then
    if Player2.timer > Player2.rate then
      Player2.timer = 0
      acquireTarget()
    end
  end
end

--- ### Collision Detection (Ball)

---- Check Collision def
function checkCollision(a, b)
  if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
    return true
  else
    return false
  end
end

---- Wall Collision
function collideWall()
  if Ball.y < 0 then
    Ball.y = 0
    Ball.yVel = -Ball.yVel
    Ball.hitWall:play()
  elseif Ball.y + Ball.height > love.graphics.getHeight() then
    Ball.y = love.graphics.getHeight() - Ball.height
    Ball.yVel = -Ball.yVel
    Ball.hitWall:play()
  end
end

---- Player1 Collision
function collidePlayer1()
  if checkCollision(Ball, Player1) then
    Ball.xVel = Ball.speed
    local middleBall = Ball.y + Ball.height /2
    local middlePlayer = Player1.y + Player1.height /2
    local collisionPosition = middleBall - middlePlayer
    Ball.yVel = collisionPosition * 5
    Ball:increaseSpeed()
    Ball.hitPlayer:play()
  end
end

---- Player2 Collision
function collidePlayer2()
  if checkCollision(Ball, Player2) then
    Ball.xVel = -Ball.speed
    local middleBall = Ball.y + Ball.height /2
    local middleAI = Player2.y + Player2.height /2
    local collisionPosition = middleBall - middleAI
    Ball.yVel = collisionPosition * 5
    Ball:increaseSpeed()
    Ball.hitPlayer:play()
  end
end

---- Check All Collisions
function collideAll()
  collideWall()
  collidePlayer1()
  collidePlayer2()
  score()
end


-- ## Debug
function printDebug()
  if DEBUG then
    loveversion = string.format("%02d.%02d.%02d", love._version_major, love._version_minor, love._version_revision)

    print("\n\n## DEBUG (main.lua\n")
    print("### Game")
    print(".type: "..Game.type)
    print(".score.player1: "..Game.score.player1)
    print(".score.player2: "..Game.score.player2)
    print(".winner: "..Game.winner)
    print("---")
    print("### Player")
    print(".name: "..Player1.name.."  .type: "..Player1.type.."  .color: "..Player1.color)
    print(".name: "..Player2.name.."  .type: "..Player2.type.."  .color: "..Player2.color)
    print("---")
    print("### System")
    print("LOVE Version: "..loveversion)
    print("SCALE: "..SCALE)
    print("W_WIDTH: "..W_WIDTH)
    print("W_HEIGHT: "..W_HEIGHT)
    print("---\n")
  end
end
