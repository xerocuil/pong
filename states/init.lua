Game = require 'states.game'
Menu = require 'states.menu'
Paused = require 'states.paused'
GameOver = require 'states.game_over'

local Background = require 'background'

-- ## Init/Load State Table
local State = {}

function State:load()
  self:init("game", false)
  self:init("game_over", false)
  self:init("menu", true)
  self:init("options", false)
  self:init("paused", false)

  gs_game = State[1]
  gs_game_over = State[2]
  gs_menu = State[3]
  gs_options = State[4]
  gs_paused = State[5]

  Background:load()
  Game:load()
  Menu:load()
end

-- ## Update
function State:update(dt)
  if not gs_paused.on then
    Background:update(dt)
  end

  if gs_game.on then
    Game:update(dt)
  end

  if gs_game_over.on then
    GameOver:draw()
  end

  if gs_menu.on then
    Menu:update(dt)
  end

  if gs_options.on then

  end

  if gs_paused.on then
    Paused:draw()
  end
end

-- ## Draw
function State:draw()
  Background:draw()
  if gs_menu.on then
    Menu:draw()
  elseif gs_game.on then
    Game:draw()
  elseif gs_paused.on then
    Paused:draw()
  elseif gs_game_over.on then
    GameOver:draw()
  end
end

-- ## Functions

--- Init States
function State:init(name, on)
  table.insert(State, {name = name, on = on})
end

--- Switch States
function State:switch(name)
  for i,v in ipairs(State) do
    if v.name == name then
      v.on = true
      Game.state = name
    elseif v.name ~= name then
      v.on = false
    else
      print("Not a valid state name.")
    end
  end
end

return State
