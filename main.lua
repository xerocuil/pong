-- ## Global

-- Functions
function hide_mouse() love.mouse.setVisible(false) end
function show_mouse() love.mouse.setVisible(true) end

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
local Debugger = require 'engine.debugger'
local Settings = require 'engine.settings'

-- ## Load
function love.load()
  State:load()
end


-- ## Update
function love.update(dt)
  controlsUpdate()
  State:update(dt)

  if DEBUG then displayDebugger(dt) end
end


-- ## Draw
function love.draw()
  State:draw()
end
