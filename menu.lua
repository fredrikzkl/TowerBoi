
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local buttonGraphics = require('Graphics.Buttons')


local function rgb(val)
  return val/255
end

local OGSkyGradient

local backgroundGroup
local menuUiGroup

local function gotoGame()
  composer.gotoScene( 'game' )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- ----------------------- ------------------------------------------------------------

-- create()
function scene:create( event )
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen


  backgroundGroup = display.newGroup()
  sceneGroup:insert(backgroundGroup)
  menuUiGroup = display.newGroup()
  sceneGroup:insert(menuUiGroup)

  OGSkyGradient = {
    type="gradient",
    color1={rgb(20),rgb(71),rgb(153)}, color2={rgb(52),rgb(237),rgb(212)}, direction="down"
  }


  local background = display.newRect(display.contentCenterX,display.contentCenterY ,screenW,screenH)
  background:setFillColor(OGSkyGradient)
  backgroundGroup:insert(background)

  local header = display.newEmbossedText("KnixBrix", halfW, 100, font, 100)
  menuUiGroup:insert(header)
  header:addEventListener( "tap", gotoGame )


  local playButton = display.newImageRect(menuUiGroup, buttonGraphics,1, 128, 64)
  sceneGroup:insert(playButton)
  playButton.x = halfW
  playButton.y = screenH - 100

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
