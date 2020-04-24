
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local buttonGraphics = require('Graphics.Buttons')
local colors = require('Graphics.Colors')
local save = require('Data.HighScoreHandler')

-- Initialize variables
local sfx = require('Sound.SFX')
local time = require('Utils.TimeManagement')


local function gotoMenu()
	sfx.click()
	composer.gotoScene( "menu", { time=transitionTime, effect="slideLeft" } )
end

local function deleteData(event)

	if ( event.action == "clicked" ) then
			 local i = event.index
			 if ( i == 1 ) then
				 	 sfx.play("deleteSave")
					 save.deleteHighScore()
					 composer.gotoScene( "menu", { time=2000, effect="fade" } )
			 elseif ( i == 2 ) then
				 	--Do nothing; dialog will simply dismiss

			 end
	 end

end

local function deleteWarning()
	sfx.click()
	local alert = native.showAlert( "Slette spilldata", "Sikker på at du vil fjerne dine episke rekorder?", { "Slett", "Avbryt" }, deleteData )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
local saveFile
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Load the scores
		saveFile = event.params.save
	  local background = display.newRect(display.contentCenterX,display.contentCenterY ,screenW,screenH)


		local header = ""
		local hoydeRecord = 0
		local timeRecord = 0
		local gangerSpilt = 0
		local scores  = {}


		if(saveFile.hardMode == 1)then
			background:setFillColor(colors.hardSkyGradient)
			header = "Expert Stats"
			timeRecord = time.toFormatedTime(saveFile["hardBestTime"])
			scores = saveFile['hardResults']
		else
			background:setFillColor(colors.skyGradient)
			header = "Stats"
			timeRecord = time.toFormatedTime(saveFile["bestTime"])
			scores = saveFile['results']
		end

		local avg = 0

		for i = 1, #scores do
			print(scores[i])
			gangerSpilt = gangerSpilt + scores[i]
			avg = avg + (i * scores[i])
			if(scores[i] > 0)then
				hoydeRecord = i
			end
		end
		avg = avg / gangerSpilt

		print(gangerSpilt)

		sceneGroup:insert(background)

    local highScoresHeader = display.newEmbossedText( sceneGroup, header, display.contentCenterX, 100, font, 80 )
		sceneGroup:insert(highScoresHeader)




		local bestHeight = display.newEmbossedText( sceneGroup, "Beste tårn: " .. hoydeRecord, display.contentCenterX, 300, font, 40 )
		sceneGroup:insert(bestHeight)


		if(hoydeRecord == 20) then
			--bestHeight:setFillColor(unpack(colors.green))
			local bestTime = display.newEmbossedText( sceneGroup, "Tid: " .. timeRecord, display.contentCenterX, 350, font, 40 )
			sceneGroup:insert(bestTime)
		end



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



		local timesPlayed = display.newEmbossedText(sceneGroup, "Antall ganger spilt: " .. gangerSpilt, display.contentCenterX, buttonFrame.y - 100, font, 30)
		if hoydeRecord == 20 then
			local timesCompleted = display.newEmbossedText(sceneGroup,"Ganger rundet spillet: " .. scores[20], display.contentCenterX, timesPlayed.y - 100, font, 30)
			local avgText = display.newEmbossedText(sceneGroup,"Gjennomsnittlig høyde: " .. string.format("%.2f",avg), display.contentCenterX, timesPlayed.y - 50, font, 30)
		end

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


		local versionControl = getPlatformInfo(sceneGroup)



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
		composer.removeScene( "stats" )
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
