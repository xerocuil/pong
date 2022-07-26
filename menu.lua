Controls = require 'lib/baton'

--## Init/Load Menu
local Menu = {}

menu_selection = 0

local btn_height = 64
local title_height = love.graphics.getHeight() * 0.1
local menu_height = love.graphics.getHeight() * 0.5

-- ## Load Menu Buttons
function Menu:load()
  self:load_button(
    "1 Player Game",
    function()
      start1p()
    end
  )

  self:load_button(
    "2 Player Game",
    function()
      start2p()
    end
  )

  self:load_button(
    "Exit Game",
    function()
      print "Exiting..."
      love.event.quit()
    end
  )
end


-- ## Update
function Menu:update()
  joystickNav()
end


-- ## Draw
function Menu:draw()
  local btn_width = W_WIDTH * 0.4
  local margin = 16
  local menu_height = (btn_height + margin) * #Menu
  local cursor_y = 0
  
  love.graphics.setColor(unpack(white))
  love.graphics.setFont(titleFont)
  love.graphics.printf("Pong", 0, title_height, love.graphics.getWidth(), "center")
  love.graphics.setFont(font)

  for i,btn in ipairs(Menu) do
    btn.last = btn.now
    local btn_x = (W_WIDTH * 0.5) - (btn_width * 0.5)
    local btn_y = (W_HEIGHT * 0.5) - (menu_height * 0.5) + cursor_y
    btn.x = (W_WIDTH * 0.5)
    btn.y = (W_HEIGHT * 0.5) - (menu_height * 0.5) + cursor_y + (btn_height * 0.5)

    local mouse_x, mouse_y = love.mouse.getPosition()
    local selected = mouse_x > btn_x and mouse_x < btn_x + btn_width and
                mouse_y > btn_y and mouse_y < btn_y + btn_height

    if selected then
      love.graphics.setColor(unpack(higlight))
    else
      love.graphics.setColor(unpack(shade))
    end

    btn.now = love.mouse.isDown(1)
    if btn.now and not btn.last and selected then
      btn.fn()
    end

    if btn.now then
      show_mouse()
    end

    love.graphics.rectangle(
      "fill",
      btn_x,
      btn_y,
      btn_width,
      btn_height
    )

    local text_width = font:getWidth(btn.text)
    local text_height = font:getHeight(btn.text)
    
    love.graphics.setColor(unpack(white))
    love.graphics.print(
      btn.text,
      font,
      (W_WIDTH * 0.5) - (text_width * 0.5),
      btn_y + (text_height * 0.5)
    )

    cursor_y = cursor_y + (btn_height + margin)
  end
end

-- ## Functions
--- Add Menu Buttons to table
function Menu:load_button(text, fn)
  table.insert(Menu, {text = text, fn = fn, now = false, last = false, x = 0, y = 0})
end

--- Game Over Screen
function Menu:gameOverScreen()
  love.graphics.setFont(titleFont)
  love.graphics.printf("Game Over", 0, title_height, love.graphics.getWidth(), "center")
  love.graphics.setFont(font)
  love.graphics.printf("Winner: "..tostring(Game.winner), 0, menu_height, love.graphics.getWidth(), "center")
  love.graphics.printf("Press 'Start / Enter' to restart", 0, menu_height + (40 * SCALE), love.graphics.getWidth(), "center")
  love.graphics.printf("Press 'Back / Backspace' to return to Title Screen", 0, menu_height + (80 * SCALE), love.graphics.getWidth(), "center")
end

--- Pause Screen
function Menu:pauseMenu()
  love.graphics.setColor(unpack(shade))
  love.graphics.rectangle("fill", 0, 0, W_WIDTH, W_HEIGHT)
  love.graphics.setColor(unpack(white))
  love.graphics.setFont(titleFont)
  love.graphics.printf("Paused", 0, title_height, love.graphics.getWidth(), "center")
  love.graphics.setFont(font)
  love.graphics.printf("Press 'Start / Enter' to resume", 0, menu_height, love.graphics.getWidth(), "center")
  love.graphics.printf("Press 'Back / Backspace' to return to Title Screen", 0, menu_height + (40 * SCALE), love.graphics.getWidth(), "center")
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

return Menu
