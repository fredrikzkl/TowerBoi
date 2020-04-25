
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local buttonGraphics = require('Graphics.Buttons')
local save = require('Data.HighScoreHandler')
local innstillinger = require('Data.SettingsHandler')
local colors = require('Graphics.Colors')
local sfx = require('Sound.SFX')
local announcer = require('Sound.Announcer')



local saveFile


local backgroundGroup
local menuUiGroup

local settingsButton

local function gotoGame()
  settingsButton:removeSelf()
  sfx.play('proceed')
  announcer.letsGo()
  composer.gotoScene( 'game' , {time=transitionTime,effect="slideLeft", params={mode=saveFile['hardMode']}})
end

local function gotoCredits()
  sfx.click()
  composer.gotoScene('credits', {time=transitionTime,effect="slideUp", params={mode=saveFile['hardMode']}})
end

local function gotoStats()
  sfx.click()
  local options =  {time=transitionTime,
                    effect="slideRight",
                    params = {save = saveFile}
                  }
  composer.gotoScene('stats',options)
end

local function goToSettings()
  sfx.click()
  local options =  {time=transitionTime, effect="fade", params={mode=saveFile['hardMode']}}
  composer.gotoScene('Scenes.Settings', options)
end

local function enableSecret()
  sfx.play("disabled")
end

local function toggleHardMode()
  if(saveFile['hardMode'] == 0)then
    sfx.play('hardMode')
  else
    sfx.play('normalMode')
  end
  save.toggleHardMode()
  composer.gotoScene('Scenes.MenuLobby', {time=500, effect='crossFade'})

end



function createButton(y, color, text)
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
  local buttonText = display.newEmbossedText(options)
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
  saveFile = save.loadScores()
  local isCheating = save.checkForCheat(saveFile)

  innstillinger.updateVolume()

  local hardMode = saveFile.hardMode;

  backgroundGroup = display.newGroup()
  sceneGroup:insert(backgroundGroup)
  menuUiGroup = display.newGroup()
  sceneGroup:insert(menuUiGroup)

  --audio.setVolume( 1, {channel=3} )

  local background = display.newRect(display.contentCenterX,display.contentCenterY ,screenW,screenH)

  local mighty = display.newEmbossedText("Mighty", halfW-120, halfH/2-80, font, 100)
  mighty.anchorX = 0
  local heightText = display.newEmbossedText("Height", mighty.x-37, mighty.y+100, font, 100)
  heightText.anchorX = 0
  menuUiGroup:insert(mighty)
  menuUiGroup:insert(heightText)


  if(isCheating)then
    display.newEmbossedText("Hello there, Mr.Cheater", halfW, halfH-80, font, 50)
    display.newEmbossedText("Did you really think it would be that easy?",  halfW, halfH, font, 25)

    --display.newEmbossedText("I suggest you revert back",  halfW, halfH+50, font, 25)

    announcer.say('microPenis')
    --display.newEmbossedText("Did you really think it would be that that easy?",  halfW, halfH+50, font, 25)

    background:setFillColor(unpack(colors.mursteinsRod))
    return
  end

  if(hardMode == 1)then
    background:setFillColor(colors.hardSkyGradient)
    --header:setFillColor(unpack(colors.mursteinsRod))
  else
    background:setFillColor(colors.skyGradient)
  end

  backgroundGroup:insert(background)



  local playButton = createButton(halfH, 1, "Start")
  local statsButton = createButton(playButton.y+playButton.height + 50, 3, "Stats")
  local creditsButton = createButton(statsButton.y+statsButton.height + 50, 4, "Credits")


  if(saveFile.results[20] > 0) then
    if(hardMode == 0)then
      local hardModeButton = createButton(creditsButton.y+creditsButton.height + 50, 6, "Expert")
      hardModeButton:addEventListener("tap", toggleHardMode)
    else
      local regularButton = createButton(creditsButton.y+creditsButton.height + 50, 7, "Normal")
      regularButton:addEventListener("tap", toggleHardMode)
    end

    else
      local secretsButton = createButton(creditsButton.y+creditsButton.height + 50, 5, "Secret")
      secretsButton:addEventListener("tap", enableSecret)
  end

  playButton:addEventListener("tap", gotoGame)
  creditsButton:addEventListener("tap", gotoCredits)
  statsButton:addEventListener("tap", gotoStats)

  settingsButton = display.newImageRect( "Sprites/helpSprites.png",40,40 )
  settingsButton.x = screenW-30
  settingsButton.y = screenH-30
  settingsButton:addEventListener("tap", goToSettings)
  sceneGroup:insert(settingsButton)

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
    composer.removeScene( "menu" )
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
