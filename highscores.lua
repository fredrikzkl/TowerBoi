
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local buttonGraphics = require('Graphics.Buttons')

-- Initialize variables

local save = require('Data.HighScoreHandler')
local time = require('Utils.TimeManagement')


local function gotoMenu()
	composer.gotoScene( "menu", { time=transitionTime, effect="slideLeft" } )
end

local function deleteData(event)

	if ( event.action == "clicked" ) then
			 local i = event.index
			 if ( i == 1 ) then
					 composer.gotoScene( "menu", { time=2000, effect="fade" } )
					 save.deleteHighScore()
			 elseif ( i == 2 ) then
				 	--Do nothing; dialog will simply dismiss

			 end
	 end

end

local function deleteWarning()
	local alert = native.showAlert( "Slette spilldata", "Sikker på at du vil fjerne dine episke rekorder?", { "Slett", "Avbryt" }, deleteData )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Load the scores
    local saveFile = save.loadScores()

		OGSkyGradient = {
	    type="gradient",
	    color1={rgb(20),rgb(71),rgb(153)}, color2={rgb(52),rgb(237),rgb(212)}, direction="down"
	  }


	  local background = display.newRect(display.contentCenterX,display.contentCenterY ,screenW,screenH)
	  background:setFillColor(OGSkyGradient)
		sceneGroup:insert(background)

    local highScoresHeader = display.newText( sceneGroup, "Stats", display.contentCenterX, 100, font, 60 )
		sceneGroup:insert(highScoresHeader)



		local bestHeight = display.newText( sceneGroup, "Best Height:" .. saveFile["bestHeight"], display.contentCenterX, 250, font, 40 )
		sceneGroup:insert(bestHeight)


		local convertedTime = time.toFormatedTime(saveFile["bestTime"])
		local bestTime = display.newText( sceneGroup, "Best Time:\n " .. convertedTime, display.contentCenterX, 350, font, 40 )
		sceneGroup:insert(bestTime)




		local margin = 40
		local options = {
		  text = "Tilbake",
		  x = halfW,
		  y = screenH-180,
		  width = 250,
		  height= 50,
		  font = font,
		  fontSize = 50,
		  align = "center"
		}

		local buttonText = display.newText(options)
		local buttonFrame = display.newImageRect(sceneGroup, buttonGraphics,3, buttonText.width, buttonText.height+margin)
		buttonFrame.x = buttonText.x
		buttonFrame.y = buttonText.y
		sceneGroup:insert(buttonFrame)
		sceneGroup:insert(buttonText)

		buttonFrame:addEventListener( "tap", gotoMenu )


		local margin = 20
		local options = {
		  text = "Slett data",
		  x = halfW,
		  y = screenH-50,
		  width = 150,
		  height= 20,
		  font = font,
		  fontSize = 20,
		  align = "center"
		}

		local slettText = display.newText(options)
		local slettButton = display.newImageRect(sceneGroup, buttonGraphics,4, slettText.width, slettText.height+margin)
		slettButton.x = slettText.x
		slettButton.y = slettText.y
		sceneGroup:insert(slettButton)
		sceneGroup:insert(slettText)

		slettButton:addEventListener( "tap", deleteWarning )


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
		composer.removeScene( "highscores" )
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
