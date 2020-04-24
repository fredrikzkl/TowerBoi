

local composer = require( "composer" )
local widget = require('widget')

local buttonGraphics = require('Graphics.Buttons')
local colors = require('Graphics.Colors')
local sfx = require('Sound.SFX')

local settingsHandler = require('Data.SettingsHandler')

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local mode
local settingsFile

local masterVolumeSlider, musicVolumeSlider, sfxVolumeSlider, announcerVolumeSlider

local function goBack()
	sfx.click()
	--Updating SettingsFile
	settingsFile['master'] = (masterVolumeSlider.value/10)
	settingsFile['music'] = (musicVolumeSlider.value/100)
	settingsFile['sfx'] = (sfxVolumeSlider.value/100)
	settingsFile['announcer'] = (announcerVolumeSlider.value/100)
	settingsHandler.saveSettings(settingsFile)

	composer.gotoScene( "menu", { time=transitionTime, effect="fade" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------


-- create()
function scene:create( event )

	local sceneGroup = self.view
	mode = event.params.mode
	-- Code here runs when the scene is first created but has not yet appeared on screen
	settingsFile = settingsHandler.loadSettings()



	local background = display.newRect(display.contentCenterX,display.contentCenterY ,screenW,screenH)
	if(mode == 1)then
		background:setFillColor(colors.hardSkyGradient)
	else
		background:setFillColor(colors.skyGradient)
	end

	sceneGroup:insert(background)

	local header = display.newEmbossedText( sceneGroup, "Settings", display.contentCenterX, 100, font, 80 )


	local masterVolumeText = display.newEmbossedText( sceneGroup, "Master Volume", display.contentCenterX, 250, font, 40 )
	masterVolumeSlider = widget.newSlider(
    {
        x = display.contentCenterX,
        y = 300,
        width = 400,
        value = settingsFile['master']*10,  -- Start slider at 10% (optional)
    })
		sceneGroup:insert(masterVolumeSlider)


		local musicVolumeText = display.newEmbossedText( sceneGroup, "Musikk", display.contentCenterX, 400, font, 40 )
		musicVolumeSlider = widget.newSlider(
		{
				x = display.contentCenterX,
				y = musicVolumeText.y+50,
				width = 400,
				value = settingsFile['music']*100,  -- Start slider at 10% (optional)
		})
		sceneGroup:insert(musicVolumeSlider)


		local sfxText = display.newEmbossedText( sceneGroup, "SFX", display.contentCenterX, 550, font, 40 )
		sfxVolumeSlider = widget.newSlider(
	   {
	        x = display.contentCenterX,
	        y = sfxText.y+50,
	        width = 400,
	        value = settingsFile['sfx']*100,  -- Start slider at 10% (optional)
	   })
		sceneGroup:insert(sfxVolumeSlider)


		local announcerText =	display.newEmbossedText( sceneGroup, "Announcer", display.contentCenterX, 700, font, 40 )
		announcerVolumeSlider = widget.newSlider(
    {
		 		x = display.contentCenterX,
      	y = announcerText.y + 50,
				width = 400,
	    	value = settingsFile['announcer']*100,  -- Start slider at 10% (optional)
		 })
		sceneGroup:insert(announcerVolumeSlider)





		local options = {
			text = "Tilbake",
			x = halfW,
			y = screenH-100,
			width = 250,
			height= 50,
			font = font,
			fontSize = 50,
			align = "center"
		}

		local buttonText = display.newText(options)
		local buttonFrame = display.newImageRect(sceneGroup, buttonGraphics,3, buttonText.width, buttonText.height+40)


		buttonFrame.x = buttonText.x
		buttonFrame.y = buttonText.y
		sceneGroup:insert(buttonFrame)
		sceneGroup:insert(buttonText)
		buttonFrame:addEventListener( "tap", goBack )

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
		composer.removeScene( "Scenes.Settings" )

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
