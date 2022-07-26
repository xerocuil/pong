Controls = require 'engine.lib.baton'

local Paused = {}

function Paused:load()
end

function Paused:update()
end

function Paused:draw()
  Ball:draw()
  Player:drawAll()
  love.graphics.setColor(unpack(shade))
  love.graphics.rectangle("fill", 0, 0, W_WIDTH, W_HEIGHT)
  love.graphics.setColor(unpack(white))
  love.graphics.setFont(titleFont)
  love.graphics.printf("Paused", 0, title_height, love.graphics.getWidth(), "center")
  love.graphics.setFont(font)
  love.graphics.printf("Press 'Start / Enter' to resume", 0, menu_height, love.graphics.getWidth(), "center")
  love.graphics.printf("Press 'Back / Backspace' to return to Title Screen", 0, menu_height + (40 * SCALE), love.graphics.getWidth(), "center")
end

return Paused
