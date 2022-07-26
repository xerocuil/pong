baton = require 'lib/baton'

-- Load baton
Player1Input = baton.new {
  controls = {
    up = {'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:s', 'axis:lefty+', 'button:dpdown'},
    menu = {'key:escape', 'button:start'},
    select = {'key:return', 'key:space', 'button:a'},
    back = {'key:backspace', 'button:b', 'button:back'},
    exit = {'key:f9'},
    fullscreen = {'key:f11', 'button:y'}
  },
  joystick = love.joystick.getJoysticks()[1],
  deadzone = .33,
}

Player2Input = baton.new {
  controls = {
    up = {'key:up', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'axis:lefty+', 'button:dpdown'},
    menu = {'button:start'},
    select = {'key:lctrl', 'button:a'},
    back = {'button:b'}
  },
  joystick = love.joystick.getJoysticks()[2],
  deadzone = .33,
}

function controlsUpdate()
  Player1Input:update()
  Player2Input:update()
  globalControls()
end

--- Global Controls
function globalControls()

  ---- Menu
  if Player1Input:pressed 'menu' or Player2Input:pressed 'menu' then
    if Game.state == "game" then
      Game.state = "paused"
    elseif Game.state == "paused" then
      Game.state = "game"
    end
  end

  if Player1Input:pressed 'back' or Player2Input:pressed 'back' then
    if Game.state == "paused" or Game.state == "game_over" then
      resetGame()
      Game.state = "title"
    end
  end

  ---- Fullscreen
  if Player1Input:pressed 'fullscreen' then
    if love.window.getFullscreen() then
      love.window.setMode(W_WIDTH, W_HEIGHT)
    else
      love.window.setFullscreen(true, "exclusive")
    end
  end

  ---- Exit
  if Player1Input:pressed 'exit' then
    love.event.quit()
  end
end