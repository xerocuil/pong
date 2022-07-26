-- # Debugger

function debugger()
  loveversion = string.format("%02d.%02d.%02d", love._version_major, love._version_minor, love._version_revision)
  local getPositionX, getPositionY = love.mouse.getPosition()

  print("\n## DEBUG (main.lua)\n")
  print("---")
  print("### Game")
  print("menu_selection: "..menu_selection)
  print("Game.state: "..Game.state)
  print("type: "..Game.type.."  score.player1: "..Game.score.player1.." score.player2: "..Game.score.player2)
  print("---")
  print("### Players")
  print("name: "..Player1.name.."   type: "..Player1.type.."  color: "..Player1.color)
  print("name: "..Player2.name.."   type: "..Player2.type.."  color: "..Player2.color)
  print("---")
  print("### System")
  print("LÖVE Version: "..loveversion)
  print("DIMENSIONS (SCALE): "..W_WIDTH.." X "..W_HEIGHT.." ("..SCALE..")")
  print("MOUSE_POS(X,Y): "..getPositionX..","..getPositionY)
  print("FPS: "..love.timer.getFPS())
  print("---")
  print("### States")
  for i,v in ipairs(State) do
    if v.on then
      print(v.name.."   on")
    else
      print(v.name)
    end
  end
  print("---\n")
end

timer_reset = 1
timer = 0
function displayDebugger(dt)
  if timer <= 0 then
    timer = timer_reset
    debugger()
  end
  timer = timer - dt
end

  
