Game = require 'states.game'
TitleScreen = require 'states.title_screen'
Paused = require 'states.paused'
GameOver = require 'states.game_over'



-- ## Init/Load State Table
local State = {}

function State:load()
  self:init("game", false)
  self:init("game_over", false)
  self:init("title_screen", true)
  self:init("options", false)
  self:init("paused", false)

  gs_game = State[1]
  gs_game_over = State[2]
  gs_title_screen = State[3]
  gs_options = State[4]
  gs_paused = State[5]

  
  Game:load()
  TitleScreen:load()
end

-- ## Update
function State:update(dt)

  if gs_game.on then
    Game:update(dt)
  end

  if gs_game_over.on then
  end

  if gs_title_screen.on then
    TitleScreen:update(dt)
  end

  if gs_options.on then
  end

  if gs_paused.on then
  end
end

-- ## Draw
function State:draw()
  
  if gs_title_screen.on then
    TitleScreen:draw()
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
  query = false
  for i,v in ipairs(State) do
    if v.name == name then
      query = true
    end
  end

  if query then
    for i,v in ipairs(State) do
      if v.name == name then
        v.on = true
        Game.state = name
      else
        v.on = false
      end
    end
  else
    print("Not a valid state request.")
  end
end

return State
