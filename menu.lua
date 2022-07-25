--## Init/Load Menu
local Menu = {}

local title_height = love.graphics.getHeight() * 0.15
local menu_height = love.graphics.getHeight() * 0.40


-- ## Load
function Menu:loadTitle()
	self:load_button(0, menu_height, "Press '1' or 'Start' for 1 Player", "start1p")
	self:load_button(0, menu_height + (40 * SCALE), "Press '2' or 'X' for 2 Players", "start2p")
	self:load_button(0, menu_height + (80 * SCALE), "Press 'Back / Esc' to exit", "exit")
end


-- ## Draw
function Menu:drawTitle()
	love.graphics.setFont(titleFont)
	love.graphics.printf("Pong", 0, title_height, love.graphics.getWidth(), "center")
	for i,v in ipairs(Menu) do
		love.graphics.setFont(font)
		love.graphics.printf(v.text, v.x, v.y, love.graphics.getWidth(), "center")
	end
end


-- ## Functions
--- Title Screen Options
function Menu:load_button(x,y,text)
	table.insert(Menu, {x=x, y=y, text=text, id = id})
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

return Menu
