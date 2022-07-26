-- ## Global

-- Functions
function hide_mouse() love.mouse.setVisible(false) end
function show_mouse() love.mouse.setVisible(true) end

-- Variables
love.graphics.setDefaultFilter("nearest", "nearest")
palette = require 'engine.palette'
font = love.graphics.newFont('assets/digital-disco-thin.ttf', 20 * SCALE)
titleFont = love.graphics.newFont('assets/digital-disco.ttf', 64 * SCALE)

-- ## Init Game Engine
Game = require 'engine.game'
local Background = require 'background'
local Ball = require 'engine.ball'
local Collision = require 'engine.collision'
local Controls = require 'engine.controls'
local Debugger = require 'engine.debugger'
local Menu = require 'menu'
local Player = require 'engine.player'
local Settings = require 'engine.settings'


-- ## Load
function love.load()
  Background:load()
  Ball:load()
  Menu:load()
end


-- ## Update
function love.update(dt)
  controlsUpdate()

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
    Menu:update()
    Background:update(dt)
  elseif Game.state == "game_over" then
    Menu:update()
    Background:update(dt)
  end

  if DEBUG then debugger() end
end


-- ## Draw
function love.draw()
  if Game.state == "title" then
    Background:draw()
    Menu:draw()
  elseif Game.state == "game" then
    Background:draw()
    Ball:draw()
    Player:drawAll()
    drawScore()
  elseif Game.state == "paused" then
    Background:draw()
    Ball:draw()
    Menu:pauseMenu()
    Player:drawAll()
  elseif Game.state == "game_over" then
    Background:draw()
    Menu:gameOverScreen()
    drawScore()
  end
end
