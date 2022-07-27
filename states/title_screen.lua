--Controls = require 'engine.lib.baton'

--## Init/Load TitleScreen
local TitleScreen = {}

menu_selection = 0

-- ## Load TitleScreen Buttons
function TitleScreen:load()
  self:load_button("1 Player Game", function() start1p() end)
  self:load_button("2 Player Game", function() start2p() end)
  self:load_button("Exit Game", function() quit_game() end)
end

-- ## Update
function TitleScreen:update()
  Controls:menu()
end

-- ## Draw
function TitleScreen:draw()
  local btn_width = W_WIDTH * 0.4
  local margin = 16
  local menu_height = (btn_height + margin) * #TitleScreen
  local cursor_y = 0
  
  love.graphics.setColor(unpack(white))
  love.graphics.setFont(titleFont)
  love.graphics.printf("Pong", 0, title_height, love.graphics.getWidth(), "center")
  love.graphics.setFont(font)

  for i,btn in ipairs(TitleScreen) do
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
--- Add TitleScreen Buttons to table
function TitleScreen:load_button(text, fn)
  table.insert(TitleScreen, {text = text, fn = fn, now = false, last = false, x = 0, y = 0})
end

return TitleScreen
