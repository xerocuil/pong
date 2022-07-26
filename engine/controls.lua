baton = require 'engine.lib.baton'

-- Load baton
Player1Input = baton.new {
  controls = {
    up = {'key:w', 'axis:lefty-', 'button:dpup'},
    down = {'key:s', 'axis:lefty+', 'button:dpdown'},
    menu = {'key:escape', 'button:start'},
    select = {'key:return', 'key:space', 'button:a'},
    back = {'key:backspace', 'button:b', 'button:back'},
    exit = {'key:f9'},
    fullscreen = {'key:f11', 'button:y'},
    test = {'key:t'}
  },
  joystick = love.joystick.getJoysticks()[1],
  deadzone = .33,
}

Player2Input = baton.new {
  controls = {
    up = {'key:up', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'axis:lefty+', 'button:dpdown'},
    menu = {'button:start'},
    select = {'key:lctrl', 'key:p', 'button:a'},
    back = {'button:b'}
  },
  joystick = love.joystick.getJoysticks()[2],
  deadzone = .33,
}

function controlsUpdate()
  Player1Input:update()
  Player2Input:update()
  globalControls()
  joystickNav()
end

---- Joystick Menu Navigation
function joystickNav()
  if Player1Input:pressed 'up' or Player2Input:pressed 'up' then
    menu_id = menu_selection - 1
    set_menu_selection(menu_id)
  end

  if Player1Input:pressed 'down' or Player2Input:pressed 'down' then
    menu_id = menu_selection + 1
    set_menu_selection(menu_id)
  end

  if Player1Input:pressed 'select' or Player2Input:pressed 'select' then
    if menu_selection == 0 or menu_selection == nil then
      print("No selection: "..menu_selection)
    else
      local exec  = {menu_command = Menu[menu_selection].fn}
      print(exec.menu_command())
    end
  end
end

function set_menu_selection(menu_id)
  if menu_id == nil then
    menu_id = 1
  elseif menu_id > #Menu then
    menu_id = 1
  elseif menu_id < 1 then
    menu_id = #Menu
  end

  love.mouse.setPosition(Menu[menu_id].x, Menu[menu_id].y)
  menu_selection = menu_id
  hide_mouse()
end

--- Global Controls
function globalControls()

  ---- Menu
  if Player1Input:pressed 'menu' or Player2Input:pressed 'menu' then
    if gs_game.on then
      State:switch("paused")
    elseif gs_paused.on then
      State:switch("game")
    end
  end

  if Player1Input:pressed 'back' or Player2Input:pressed 'back' then
    if gs_paused.on or gs_game_over.on then
      resetGame()
      State:switch("menu")
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

  ---- Test
  if Player1Input:pressed 'test' then
    State:switch("game_over")
  end
end