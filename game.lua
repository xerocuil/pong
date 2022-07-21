-- ## Set Variables
local AI = require 'ai'

-- ## Init Game
local Game = {}


-- ## Load
function Game:load()
	AI:load()
	self.winner = ""
end

-- ## Update
function Game:update(dt)
	AI:update(dt)
end

-- ## Draw
function Game:draw()
	AI:draw()
end

-- ## Functions
--- AI
---- Acquire Target
function acquireTarget()
	if Ball.y + Ball.height < AI.y then
		AI.yVel = -AI.speed
	elseif Ball.y > AI.y + AI.height then
		AI.yVel = AI.speed
	else
		AI.yVel = 0
	end
end
---- Movement
function AIMovement(dt)
	if AI.timer > AI.rate then
		AI.timer = 0
		acquireTarget()
	end
end