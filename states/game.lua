local Settings = require 'engine.settings'

Ball = require 'engine.ball'
Player = require 'engine.player'
Collision = require 'engine.collision'

-- ## Init Game Table
local Game = {}
local Game = {
  state = "menu",
  score = {player1 = 0, player2 = 0},
  winner = "none",
  type = "1P"
}

-- ## Load
function Game:load()
  Ball:load()
  Player:load()
end


-- ## Update
function Game:update(dt)
  Ball:update(dt)
  Player:updateAll(dt)
  acquireTarget(dt)
  AIMovement(dt)
  playerMove(dt)
  checkScore()
  score()
  collideAll()
end


-- ## Draw
function Game:draw()
  Ball:draw()
  Player:drawAll()
  drawScore()
end


-- ## Functions
--- Player Movement
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




-- ## Functions

-- Reset Game
function resetGame()
  Game.score.player1 = 0
  Game.score.player2 = 0
  Game.winner = "none"
  Player1.x = Player1.default_x
  Player1.y = Player1.default_y
  Player2.y = Player2.default_x
  Player2.y = Player2.default_y
  resetBall(1)
  State:switch("game")
end

-- Scoring
--- Check Score
function checkScore()
  if Game.score.player1 == Settings.match_win then
    Game.winner = Player1.name
    State:switch("game_over")
  elseif Game.score.player2 == Settings.match_win then
    Game.winner = Player2.name
    State:switch("game_over")
  end
end

--- Player Score
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

--- Draw Scoreboard
function drawScore()
  love.graphics.setFont(font)
  love.graphics.print(Player1.name..": "..Game.score.player1, 50, 50)
  love.graphics.print(Player2.name..": "..Game.score.player2, love.graphics.getWidth() - 200, 50)
end

-- Reset Ball
function resetBall(modifier)
  Ball.x = love.graphics.getWidth() / 2 - Ball.width / 2
  Ball.y = love.graphics.getHeight() / 2 - Ball.height / 2
  Ball.speed = Ball.default_speed
  Ball.yVel = 0
  Ball.xVel = Ball.speed * modifier
end




-- ## Game Modes

-- 1P Start
function start1p()
  resetGame()
  Game = {type = "1P", score = {player1 = 0, player2 = 0}, winner = "none"}
  Player2.type = "ai"
  Player2.name = "CPU"
  Player2.color = "green"
  Player2.img = love.graphics.newImage("assets/paddles/"..Player2.color..".png")
  State:switch("game")
end

-- 2P Start
function start2p()
  resetGame()
  Game = {type = "2P", score = {player1 = 0, player2 = 0}, winner = "none"}
  Player2.type = "human"
  Player2.name = "Player 2"
  Player2.color = "blue"
  Player2.img = love.graphics.newImage("assets/paddles/"..Player2.color..".png")
  State:switch("game")
end




-- ## AI

-- Acquire Target
function acquireTarget()
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

-- Movement
function AIMovement(dt)
  if Player2.type == "ai" then
    if Player2.timer > Player2.rate then
      Player2.timer = 0
      acquireTarget()
    end
  end
end



return Game