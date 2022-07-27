-- ## Global

-- Functions
function hide_mouse() love.mouse.setVisible(false) end
function show_mouse() love.mouse.setVisible(true) end
function quit_game() love.event.quit() end

function toggle_fullscreen()
  if love.window.getFullscreen() then
    love.window.setMode(W_WIDTH, W_HEIGHT)
  else
      love.window.setFullscreen(true, "exclusive")
  end
end

-- Variables
love.graphics.setDefaultFilter("nearest", "nearest")
palette = require 'engine.palette'
font = love.graphics.newFont('assets/digital-disco-thin.ttf', 20 * SCALE)
titleFont = love.graphics.newFont('assets/digital-disco.ttf', 64 * SCALE)

btn_height = 64
title_height = love.graphics.getHeight() * 0.1
menu_height = love.graphics.getHeight() * 0.5

-- ## Init Game Engine
State = require 'states'

local Controls = require 'engine.controls'
local Background = require 'background'
local Debugger = require 'engine.debugger'
local Settings = require 'engine.settings'

local Menu = require 'engine.menu'

-- ## Load
function love.load()
  Background:load()
  Controls:load()
  State:load()
  Menu:load()
end

-- ## Update
function love.update(dt)
  if not gs_paused.on then
    Background:update(dt)
  end
  Controls:update()
  State:update(dt)

  if DEBUG then displayDebugger(dt) end
end

-- ## Draw
function love.draw()
  Background:draw()
  State:draw()
end
