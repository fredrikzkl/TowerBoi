 local composer = require( "composer" )

--DENNE MÅ OPPDATERS NÅR SPILLET OPPDATERS
version = "1.0.0"
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



-- Go to the menu screen , params={mode=1}
composer.gotoScene( 'menu', { time=transitionTime, effect="fade" })
