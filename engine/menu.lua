
--## Init/Load Menu
local Menu = {}
Menu.__index = Menu

local GameOverMenu = {}
local OptionsMenu = {}
local PausedMenu = {}
local TitleScreenMenu = {}

menu_selection = 0


function Menu:load()

  function Menu.new(menu, text, fn, options)
    local instance = setmetatable({}, Menu)
    instance.menu_name = menu
    instance.text = text
    instance.fn = fn
    instance.now = false
    instance.last = false
    x = 0
    y = 0
    options = {options}
    table.insert(menu, instance)
  end


  -- ## Init GameOverMenu
  Menu.new(OptionsMenu, "Restart", function() resetGame() end)
  Menu.new(OptionsMenu, "Return to Title Screen", function() State:switch("title_screen") end)
  Menu.new(OptionsMenu, "Exit Game", function() love.event.quit() end)

  -- ## Init OptionsMenu
  Menu.new(OptionsMenu, "Toggle Fullscreen", function() toggle_fullscreen() end)
  Menu.new(OptionsMenu, "Scale", '', 1,2,3)
  OptionsMenu[2].options = {1,2,3}
  Menu.new(OptionsMenu, "Exit Game", function() love.event.quit() end)

  -- ## Paused Menu
  Menu.new(PausedMenu, "Resume", function() State:switch("game") end)
  Menu.new(PausedMenu, "Return to Title Screen", function() State:switch("title_screen") end)
  Menu.new(PausedMenu, "Exit Game", function() love.event.quit() end)

  -- ## Init TitleScreenMenu
  Menu.new(TitleScreenMenu, "1 Player Game", function() start1p() end)
  Menu.new(TitleScreenMenu, "2 Player Game", function() start2p() end)
  Menu.new(TitleScreenMenu, "Exit Game", function() love.event.quit() end)

  
  -- ## DEBUG
  print("#### TitleScreenMenu")
  for i,v in ipairs(TitleScreenMenu) do
    print("text: "..v.text.."   fn: "..tostring(v.fn).."    options: "..tostring(v.options))
  end

  print("#### OptionsMenu")
  for i,v in ipairs(OptionsMenu) do

    print("text: "..v.text.."   fn: "..tostring(v.fn).."    options: "..tostring(v.options))
    if v.options then
      for i,v in ipairs(v.options) do
        print("   option"..i..": "..v)
      end
    end
  end
  --

end

-- ## Update
function Menu:update()
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

return Menu
