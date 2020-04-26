 local composer = require( "composer" )

--DENNE MÅ OPPDATERS NÅR SPILLET OPPDATERS
version = "1.2.0"
-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

--font
font = "Font/Pixellari.ttf"

transitionTime = 700

function rgb(val)
  return val/255
end

--Skjermreferanser
screenW, screenH = display.contentWidth, display.contentHeight
halfW, halfH =  screenW*0.5, screenH*0.5



--
function getPlatformInfo(group)
  local deviceInfo = display.newEmbossedText(group, system.getInfo( 'platform' ), 10, screenH-10, font, 20)
  deviceInfo.anchorX = 0
  --deviceInfo:setFillColor(0,0,0)
  local version = display.newEmbossedText(group, version, 10, screenH-25, font, 20)
  --version:setFillColor(0,0,0)
  version.anchorX = 0
end

-- Go to the menu screen , params={mode=1}
composer.gotoScene( 'menu', { time=transitionTime, effect="fade" })
