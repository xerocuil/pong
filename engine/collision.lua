-- # Collision Detection

local Ball = require 'engine.ball'
local Settings =  require 'engine.settings'

-- ## Functions
-- Check Collision
function checkCollision(a, b)
  if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
    return true
  else
    return false
  end
end

-- Wall Collision
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

-- Player 1 Collision
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

-- Player 2 Collision
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

-- Check All Collisions
function collideAll()
  collideWall()
  collidePlayer1()
  collidePlayer2()
  score()
end
