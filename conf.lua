TITLE = "Pong"
BASE_WIDTH = 640
BASE_HEIGHT = 360
SCALE = 2
W_WIDTH = BASE_WIDTH * SCALE
W_HEIGHT = BASE_HEIGHT * SCALE

function love.conf(t)
	t.title = TITLE
	t.version = "11.4"
	t.window.icon = "assets/ball.png"
	t.console = true
	t.window.fullscreen = false
	t.window.width = W_WIDTH
	t.window.height = W_HEIGHT
end
