--## Init/Load Menu
local Menu = {}

BTN_HEIGHT = 64
local title_height = love.graphics.getHeight() * 0.15
local menu_height = love.graphics.getHeight() * 0.40
menu_selection = 0
local function hide_mouse() love.mouse.setVisible(false) end
local function show_mouse() love.mouse.setVisible(true) end

-- ## Load
function Menu:loadTitle()
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

function Menu:update()
  joystickNav()
end


-- ## Draw
function Menu:drawTitle()
  local btn_width = W_WIDTH * 0.4
  local margin = 16
  local menu_height = (BTN_HEIGHT + margin) * #Menu
  local cursor_y = 0

  local color_white = {1.0, 1.0, 1.0, 1.0}
  local color_shade = {0.4, 0.4, 0.4, 0.4}
  local color_highlight = {0.6, 0.6, 0.6, 0.6}
  
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  love.graphics.setFont(titleFont)
  love.graphics.printf("Pong", 0, title_height, love.graphics.getWidth(), "center")
  love.graphics.setFont(font)


  for i,btn in ipairs(Menu) do
    --love.graphics.printf(v.text, v.x, v.y, love.graphics.getWidth(), "center")
    btn.last = btn.now
    local btn_x = (W_WIDTH * 0.5) - (btn_width * 0.5)
    local btn_y = (W_HEIGHT * 0.5) - (menu_height * 0.5) + cursor_y
    btn.x = (W_WIDTH * 0.5)
    btn.y = (W_HEIGHT * 0.5) - (menu_height * 0.5) + cursor_y + (BTN_HEIGHT * 0.5)
    local mouse_x, mouse_y = love.mouse.getPosition()



    local hot = mouse_x > btn_x and mouse_x < btn_x + btn_width and
                mouse_y > btn_y and mouse_y < btn_y + BTN_HEIGHT

    if hot then
      love.graphics.setColor(unpack(color_highlight))
    else
      love.graphics.setColor(unpack(color_shade))
    end

    btn.now = love.mouse.isDown(1)
    if btn.now and not btn.last and hot then
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
      BTN_HEIGHT
    )

    local text_width = font:getWidth(btn.text)
    local text_height = font:getHeight(btn.text)
    
    love.graphics.setColor(unpack(color_white))
    love.graphics.print(
      btn.text,
      font,
      (W_WIDTH * 0.5) - (text_width * 0.5),
      btn_y + (text_height * 0.5)
    )

    cursor_y = cursor_y + (BTN_HEIGHT + margin)
  end
end

-- ## Functions
--- Title Screen Options
function Menu:load_button(text, fn)
  table.insert(Menu, {text = text, fn = fn, now = false, last = false, x = 0, y = 0})
end

--- Game Over
function Menu:gameOverScreen()
  love.graphics.setFont(titleFont)
  love.graphics.printf("Game Over", 0, title_height, love.graphics.getWidth(), "center")
  love.graphics.setFont(font)
  love.graphics.printf("Winner: "..tostring(Game.winner), 0, menu_height, love.graphics.getWidth(), "center")
  love.graphics.printf("Press 'Start / Enter' to restart", 0, menu_height + (40 * SCALE), love.graphics.getWidth(), "center")
  love.graphics.printf("Press 'Back / Esc' to return to Title Screen", 0, menu_height + (80 * SCALE), love.graphics.getWidth(), "center")
end

--- Pause Menu
function Menu:pauseMenu()
  love.graphics.setColor(0, 0, 0, 0.7)
  love.graphics.rectangle("fill", 0, 0, W_WIDTH, W_HEIGHT)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(titleFont)
  love.graphics.printf("Paused", 0, title_height, love.graphics.getWidth(), "center")
  love.graphics.setFont(font)
  love.graphics.printf("Press 'Start / Enter' to resume", 0, menu_height, love.graphics.getWidth(), "center")
  love.graphics.printf("Press 'Back / Esc' to return to Title Screen", 0, menu_height + (40 * SCALE), love.graphics.getWidth(), "center")
end


---- Joystick Menu Navigation
function joystickNav()

  
  
  if Player1Input:pressed 'up' then
    menu_id = menu_selection - 1
    set_menu_selection(menu_id)
  end

  if Player1Input:pressed 'down' then
    menu_id = menu_selection + 1
    set_menu_selection(menu_id)
  end

  if Player1Input:pressed 'select' then
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
