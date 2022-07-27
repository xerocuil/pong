
Controls = {}

-- ## Load

-- Load Baton library
baton = require 'engine.lib.baton'

function Controls:load()
  -- Load Player 1
  Player1Input = baton.new {
    controls = {
      up = {'key:w', 'axis:lefty-', 'button:dpup'},
      down = {'key:s', 'axis:lefty+', 'button:dpdown'},
      menu = {'key:escape', 'button:start'},
      select = {'key:return', 'key:space', 'button:a'},
      back = {'key:backspace', 'button:b', 'button:back'},
      exit = {'key:f9'},
      fullscreen = {'key:f11', 'button:y'},
      -- ## DEBUG
      test = {'key:t'}
    },
    joystick = love.joystick.getJoysticks()[1],
    deadzone = .33,
  }

  -- Load Player 2
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
end

-- ## Update
function Controls:update()
  Player1Input:update()
  Player2Input:update()
  Controls:global()
end

-- ## Functions
-- Joystick Menu Navigation
function Controls:menu()
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
      local exec  = {menu_command = TitleScreen[menu_selection].fn}
      print(exec.menu_command())
    end
  end
end

function set_menu_selection(menu_id)
  if menu_id == nil then
    menu_id = 1
  elseif menu_id > #TitleScreen then
    menu_id = 1
  elseif menu_id < 1 then
    menu_id = #TitleScreen
  end

  love.mouse.setPosition(TitleScreen[menu_id].x, TitleScreen[menu_id].y)
  menu_selection = menu_id
  hide_mouse()
end

--- ## Global Controls
function Controls:global()

  --- Pause
  if Player1Input:pressed 'menu' or Player2Input:pressed 'menu' then
    if gs_game.on then
      State:switch("paused")
    elseif gs_paused.on then
      State:switch("game")
    end
  end

  --- Reset
  if Player1Input:pressed 'back' or Player2Input:pressed 'back' then
    if gs_paused.on or gs_game_over.on then
      resetGame()
      State:switch("title_screen")
    end
  end

  --- Fullscreen
  if Player1Input:pressed 'fullscreen' then
    toggle_fullscreen()
  end

  --- Exit
  if Player1Input:pressed 'exit' then
    quit_game()
  end

  --- ## DEBUG
  if Player1Input:pressed 'test' then
    State:switch("game_over")
  end
end

return Controls