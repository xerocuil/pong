--## Init/Load TitleMenu
TitleMenu = {}

title_height = love.graphics.getHeight() * 0.15
menu_height = love.graphics.getHeight() * 0.40

-- ## Load
function TitleMenu:load()
	self:load_button(0, menu_height, "Press 'Start / Enter' to play", "start")
	--self:load_button(0, menu_height + (40 * SCALE), "Options", "options")
	self:load_button(0, menu_height + (80 * SCALE), "Press 'Back / Esc' to exit", "exit")
end

-- ## Draw
function TitleMenu:draw()
	love.graphics.setFont(titleFont)
	love.graphics.printf("Pong", 0, title_height, love.graphics.getWidth(), "center")
	for i,v in ipairs(TitleMenu) do
		love.graphics.setFont(font)
		love.graphics.printf(v.text, v.x, v.y, love.graphics.getWidth(), "center")
	end
end

-- ## Functions
--- Title Screen Options
function TitleMenu:load_button(x,y,text)
	table.insert(TitleMenu, {x=x, y=y, text=text, id = id})
end

-- function button_click(x,y)
-- 	for i,v in ipairs(TitleMenu) do
		
-- 		if love.mouse.getX() > v.x and
-- 		love.mouse.getX() < v.x + font:getWidth(v.text) and
-- 		love.mouse.getY() > v.y and
-- 		love.mouse.getY() < v.y + font:getHeight() then
-- 			if v.id == "quit" then
-- 				love.event.push("quit")
-- 			end
-- 		end
-- 	end
-- end

--- Game Over
function gameOverScreen()
	love.graphics.setFont(titleFont)
	love.graphics.printf("Game Over", 0, title_height, love.graphics.getWidth(), "center")
	love.graphics.setFont(font)
	love.graphics.printf("Winner: "..tostring(Game.winner), 0, menu_height, love.graphics.getWidth(), "center")
	love.graphics.printf("Press 'Start / Enter' to restart", 0, menu_height + (40 * SCALE), love.graphics.getWidth(), "center")
end

--- Pause Menu
function pauseMenu()
	
	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", 0, 0, W_WIDTH, W_HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(titleFont)
	love.graphics.printf("Paused", 0, title_height, love.graphics.getWidth(), "center")
	love.graphics.setFont(font)
	love.graphics.printf("Press 'Start / Enter' to resume", 0, menu_height, love.graphics.getWidth(), "center")
	love.graphics.printf("Press 'Back / Esc' to exit", 0, menu_height + (40 * SCALE), love.graphics.getWidth(), "center")
end