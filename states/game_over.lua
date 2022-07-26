local GameOver = {}

-- ## Load
function GameOver:load()

end


-- ## Update
function GameOver:update()

end


-- ## Draw
function GameOver:draw()
  love.graphics.setFont(titleFont)
  love.graphics.printf("Game Over", 0, title_height, love.graphics.getWidth(), "center")
  love.graphics.setFont(font)
  love.graphics.printf("Winner: "..tostring(Game.winner), 0, menu_height, love.graphics.getWidth(), "center")
  love.graphics.printf("Press 'Start / Enter' to restart", 0, menu_height + (40 * SCALE), love.graphics.getWidth(), "center")
  love.graphics.printf("Press 'Back / Backspace' to return to Title Screen", 0, menu_height + (80 * SCALE), love.graphics.getWidth(), "center")
end

return GameOver
