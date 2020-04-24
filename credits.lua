
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local sfx = require('Sound.SFX')

local buttonGraphics = require('Graphics.Buttons')
local colors = require('Graphics.Colors')

local OGSkyGradient

local backgroundGroup
local menuUiGroup


local function gotoMenu()
  sfx.click()
  composer.gotoScene( 'menu' , {time=transitionTime,effect="slideDown"})
end



local function createButton(y, color, text)
  local margin = 40
  local options = {
    text = text,
    x = halfW,
    y = y,
    width = 250,
    height= 50,
    font = font,
    fontSize = 50,
    align = "center"
  }
  local buttonText = display.newText(options)
  local buttonFrame = display.newImageRect(menuUiGroup, buttonGraphics,color, buttonText.width, buttonText.height+margin)
  buttonFrame.x = buttonText.x
  buttonFrame.y = buttonText.y
  menuUiGroup:insert(buttonFrame)
  menuUiGroup:insert(buttonText)
  return buttonFrame
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- ----------------------- ------------------------------------------------------------

-- create()
function scene:create( event )
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen
  local mode = event.params.mode

  --backgroundGroup = display.newGroup()
  --sceneGroup:insert(backgroundGroup)
  menuUiGroup = display.newGroup()
  sceneGroup:insert(menuUiGroup)

  print("Mode Active for Credits: " .. mode)



  local background = display.newRect(display.contentCenterX,display.contentCenterY ,screenW,screenH)
  sceneGroup:insert(background)

  if(mode == 0)then
    background:setFillColor(colors.skyGradient2)
  else
    background:setFillColor(colors.hardSkyGradient2)
  end

  menuUiGroup:insert(background)

  local header = display.newEmbossedText("Credits", halfW, 100, font, 80)
  menuUiGroup:insert(header)



  local fredrikText = display.newEmbossedText("Utviklet av Fredrik Kloster", header.x, header.y + 250, font, 40,"center")
  menuUiGroup:insert(fredrikText)

  local dateText = display.newEmbossedText("April, 2020", fredrikText.x, fredrikText.y + 50, font, 40,"center")
  menuUiGroup:insert(dateText)


  local topherText = display.newEmbossedText("Stemmer av John Christopher Kruiderink", dateText.x, dateText.y + 100, font, 30)
  menuUiGroup:insert(topherText)

  local grottingText = display.newEmbossedText("Originalmusikk av Martin Sveen Grøtting", topherText.x, topherText.y + 50, font, 30,"left")
  menuUiGroup:insert(grottingText)


  local backButton = createButton(screenH-180, 2, "Tilbake")
  backButton:addEventListener("tap", gotoMenu)


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
    composer.removeScene( "credits" )
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
