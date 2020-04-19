
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local buttonGraphics = require('Graphics.Buttons')
local save = require('Data.HighScoreHandler')
local colors = require('Graphics.Colors')


local saveFile

local OGSkyGradient

local backgroundGroup
local menuUiGroup

local proceedLyd
local disabledLyd
local startGameLyd

local function gotoGame()
  audio.play( startGameLyd )

  composer.gotoScene( 'game' , {time=transitionTime,effect="slideLeft", params={mode=saveFile['hardMode']}})
end

local function gotoCredits()
  audio.play(proceed)
  composer.gotoScene('credits', {time=transitionTime,effect="slideUp"})
end

local function gotoStats()
  audio.play(proceed)
  local options =  {time=transitionTime,
                    effect="slideRight",
                    params = {save = saveFile}
                  }
  composer.gotoScene('stats',options)
end

local function enableSecret()
  audio.play(disabledLyd)
end

local function toggleHardMode()
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
  saveFile = save.loadScores()
  local hardMode = saveFile.hardMode;
  print("Harmode:" .. hardMode)

  backgroundGroup = display.newGroup()
  sceneGroup:insert(backgroundGroup)
  menuUiGroup = display.newGroup()
  sceneGroup:insert(menuUiGroup)


  local background = display.newRect(display.contentCenterX,display.contentCenterY ,screenW,screenH)
  if(hardMode == 1)then
    background:setFillColor(colors.hardSkyGradient)
  else
    background:setFillColor(colors.skyGradient)
  end

  backgroundGroup:insert(background)

  local header = display.newEmbossedText("TowerBoi", halfW, 100, font, 100)
  menuUiGroup:insert(header)

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

  proceedLyd = audio.loadSound("Sound/proceed.wav")
  startGameLyd = audio.loadSound("Sound/start_game.wav")
  disabledLyd = audio.loadSound("Sound/disabled.wav")

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
