
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local sky = require('sky')
local physics =  require('physics')
physics.start()
local tidsur
physics.setGravity( 0, 8 )

local save = require('Data.HighScoreHandler')
local time = require('Utils.TimeManagement')
local colors = require('Graphics.Colors')
local announcer = require('Sound.Announcer')
local sfx = require('Sound.SFX')


local buttonGraphics = require('Graphics.Buttons')
local boxSheet = require('Graphics.Boxes')

hardMode = 0

local currentColor
local colorIndexer
local colorSelectorStart
local colorSelectorEnd

function getChosenColor()
  local temp = colorIndexer
  colorIndexer = colorIndexer + 1
  if(colorIndexer+1 > colorSelectorEnd)then
    colorIndexer = colorSelectorStart
  end
  return temp
end




local gridHeight = 0.99
--Grid verdier
numberOfColumns = 11
numberOfRows = 20
columnWidth = math.floor( screenW / numberOfColumns )
rowHeight = math.floor(screenH*gridHeight / numberOfRows)

function getColumnPosition( columnNumber )
	return (columnNumber - 0.5) * columnWidth
end
function getColumnWidth( numberOfColumns )
	return numberOfColumns * columnWidth
end
function getRowPosition(rowNumber)
  return (rowNumber) * rowHeight
end


local gameLoopTimer

-- DisplayGroups
local mainGroup = display.newGroup()
local uiGroup

local boksReferanse = {}

function addBuildingBlock(x,y, colorNr)
  local newBlock = display.newImageRect(mainGroup, boxSheet,colorNr, columnWidth, rowHeight)

  --local newBlock = display.newImageRect(mainGroup, "Sprites/box.png", columnWidth, rowHeight)
  newBlock.x = getColumnPosition(x)
  newBlock.y = getRowPosition(y)
  return newBlock
end


--Definerer matrisen av blokker
blockMatrix = {}
-- Loop columns
for i = 1, numberOfColumns do
	-- Loop thru records
  blockMatrix[i] = {}
	for y = 1, numberOfRows do
    --Definerer
    blockMatrix[i][y] = {}
	end
end


local minGrense = 4
local ovreGrense = 8
--La oss sette opp spill Variabler

local aktuellRad --Raden spilleren er på
local aktuelleKolonner
 --Raden de ligger på, startsbrikker
local retning
local brikkeHastighet, OGBrikkeHastighet

local hastighetsFaktor
local okningsTid
local maksBrikkeHastighet



local debrisTable = {}
local statiskeBlokkerTable = {}



--Starts verdier
aktuelleKolonner = {-4,-3,-2,-1,0}
brikkeHastighet = OGBrikkeHastighet
boksReferanse = {}
debrisTable = {}
retning = "hoyre"
aktuellRad = numberOfRows-1

local veggValg = {
	friction = 0.1,
}


local function flyttBrikker()
  --print("SetterFarge! " .. currentColor)
    --print("Første:[" .. aktuelleKolonner[1] .. "] Siste:[" .. aktuelleKolonner[#aktuelleKolonner] .. "]" .. " - Retning: " .. retning)
    if(aktuelleKolonner[#aktuelleKolonner] == numberOfColumns) then
      retning = "venstre"
    end
    if(aktuelleKolonner[1] == 1 and retning == "venstre") then
      retning = "hoyre"
    end

    if retning == "hoyre" then
      for i = #aktuelleKolonner,1,-1 do
        display.remove(boksReferanse[i])
        table.remove(boksReferanse, i)
        aktuelleKolonner[i] = aktuelleKolonner[i] + 1
      end
    elseif retning == "venstre" then --Må tegne andre veien
       for i = #aktuelleKolonner,1,-1 do
        display.remove(boksReferanse[i])
        table.remove(boksReferanse, i)
        aktuelleKolonner[i] = aktuelleKolonner[i] - 1
      end
    end

    for i = 1, #aktuelleKolonner do
      if(aktuelleKolonner[i] > -1) then
        table.insert(boksReferanse, addBuildingBlock(aktuelleKolonner[i], aktuellRad, currentColor))

      end
    end
end

local function restart()
  sfx.play('proceed')
  composer.gotoScene( 'lobby' , {params={mode=hardMode}})
  --local thisScene = composer.getSceneName( 'current' )
  --composer.gotoScene( thisScene )
end

function gotoMenu()
  sfx.click()
  composer.gotoScene( 'menu' , {time=transitionTime, effect="slideRight"})
end


local function fjernAlleBokser()
  for i = 1, #boksReferanse do
    display.remove( boksReferanse[i] )
  end
  boksReferanse = {}
end


function clearScene()
  for i = 0, uiGroup.numChildren do
    display.remove(uiGroup[i])

  end
  --Tømmer
  for i = 1, #debrisTable do
    display.remove(debrisTable[i])
  end
  debrisTable = {}
  fjernAlleBokser()
  for i = 1, #statiskeBlokkerTable do
    display.remove(statiskeBlokkerTable[i])
  end
end

local function generatePlayAgainButton()
  local buttonFrame = display.newImageRect(uiGroup, buttonGraphics,1, 260, 85 )
  buttonFrame.x = halfW
  buttonFrame.y = screenH-150

  local playAgain = display.newEmbossedText("Spill igjen", buttonFrame.x, buttonFrame.y, font, 50)
  playAgain:setFillColor(1,1,1)
  uiGroup:insert(playAgain)
  buttonFrame:addEventListener( "tap", restart )
  buttonFrame.alpha = 0
  playAgain.alpha = 0
  transition.fadeIn( buttonFrame, { time=2000 } )
  transition.fadeIn( playAgain, { time=2000 } )

  local backButtonFrame = display.newImageRect(uiGroup, buttonGraphics,3, 260, 85 )
  backButtonFrame.x = halfW
  backButtonFrame.y = playAgain.y-150
  local backButtonText = display.newEmbossedText("Tilbake", backButtonFrame.x, backButtonFrame.y, font, 50)

  uiGroup:insert(backButtonFrame)
  uiGroup:insert(backButtonText)
  backButtonFrame:addEventListener( "tap", gotoMenu )
  backButtonFrame.alpha = 0
  backButtonText.alpha = 0

  transition.fadeIn( backButtonFrame, { time=2000 } )
  transition.fadeIn( backButtonText, { time=2000 } )

end



local winning = false
local function gameLoop()
  if(#aktuelleKolonner ~= nil)then

  if(#aktuelleKolonner == 0) then --Dersom listen er tom, har man tapt
    local result = (numberOfRows - aktuellRad) - 1
    save.addHighScore(result, nil)
    if(winning) then
      result = 20
    end
    announcer.react(result)
    aktuelleKolonner = {}
		Runtime:removeEventListener( "touch", klikk )
		timer.cancel(gameLoopTimer)

		--print("Ferdig! Du bygget et hus på " .. result )

		local ggbro = display.newEmbossedText("GG, bro", halfW, halfH*0.5+45, font, 50)

		uiGroup:insert(ggbro)
		local points = display.newEmbossedText("Høyde: " .. result, halfW, halfH*0.65+45, font, 30)
		uiGroup:insert(points)

    if(hardMode == 1)then
      --ggbro:setFillColor(0,0,0)
      --points:setFillColor(0,0,0)
    end

		--display.newEmbossedText("GG, bro", halfW, halfH, font, 40)
    timer.performWithDelay(1000, generatePlayAgainButton)
  end
  end
  flyttBrikker()

end



-----------------------------------------------------------------------------------------
--
-- Input
--
-----------------------------------------------------------------------------------------
local function ringaDing()
  generatePlayAgainButton()

  local winningText
  if(hardMode == 0)then
    announcer.say('youCrazySonABitch')
    winningText = "You crazy son of a bitch,\n           you did it!"
  else
    announcer.say("ringaDingDingDong")
    winningText = "Ding-dong motherfucker, \n            you did it!"
  end

  local winText = display.newEmbossedText(winningText, halfW, halfH*0.5+90, font, 50)
  uiGroup:insert(winText)
  winText.alpha = 0
  transition.fadeIn( winText, { time=2000 } )

  --Timer
  local totalTid = system.getTimer() - tidsur

  save.addHighScore(20, totalTid)

  local formattedTime = time.toFormatedTime(totalTid)

  local tidsText = display.newEmbossedText("Tid: " .. formattedTime, halfW, halfH*0.5+280, font, 30)
  uiGroup:insert(tidsText)
  tidsText.alpha = 0
  transition.fadeIn( tidsText, { time=2500 } )

end

local function winning()
  winning = true
  sfx.winning(hardMode)
  timer.performWithDelay( 2000, ringaDing )
end



--physics.setDrawMode( 'hybrid' )
local function lagRester(colPos) --Lager blokker som er påvirket av fysikken, men har ingen funksjonalitet
	local tempDeb = addBuildingBlock(colPos, aktuellRad, currentColor)
	table.insert(debrisTable, tempDeb)
	physics.addBody( tempDeb , 'dynamic', {bounce = 0.4} )
	local torque = 0
	local factor = 1
	if retning == "hoyre" then
		torque = -1 * factor
	elseif retning == "venstre" then
		torque = 1 * factor
	end

	tempDeb:applyTorque(torque)
end

local streak = 5
local streakCounter = 0

--
-- CLICK Functions
--

local restFart = 0 --Variabel brukt i hardMode. Siden det er random hvor mye
--Hastingheten endrer seg hver gang (ergo, ødelegger rytmen), blir "ekstra" fart spart
--i denne variablen

local function klikk(event)
	if event.phase == 'began' and (#aktuelleKolonner > 0)  then


    --Debug: Announcer
    --local result = (numberOfRows - aktuellRad)
    --announcer.react(result)


	  local nyAktuelleKolonner = {}
	  --Må sjekke hvilke som henger ut

    local teller = 0
	  for i=1, #aktuelleKolonner do
	    if(aktuelleKolonner[i] >= minGrense and aktuelleKolonner[i] <= ovreGrense) then
	      table.insert(nyAktuelleKolonner, aktuelleKolonner[i])
        teller = teller + 1
			else
				lagRester(aktuelleKolonner[i])
	    end
	  end




    if(teller == 0) then
      sfx.play('dead')
    elseif(#aktuelleKolonner-#nyAktuelleKolonner >= 3) then
      sfx.play('bigFail')
    elseif(teller < #aktuelleKolonner) then
      sfx.play('fail')
    else
      sfx.play('build')
    end


    if(teller == streak)then
      streakCounter = streakCounter + 1
    else
      streakCounter = 0
      streak = teller
    end

    announcer.streak(streakCounter)


	  --NyeAktuelleKolonner skal inneholde de verdiene som erinnenfor
	  for i=1, #nyAktuelleKolonner do
	    local temp = addBuildingBlock(nyAktuelleKolonner[i],aktuellRad, currentColor)
			physics.addBody( temp, "static", { friction=0.5 } )
			table.insert( statiskeBlokkerTable, temp )
	  end

	  minGrense = nyAktuelleKolonner[1]
	  ovreGrense = nyAktuelleKolonner[#nyAktuelleKolonner]

	  fjernAlleBokser()
	  aktuelleKolonner = {}
	  for i = 1, #nyAktuelleKolonner do
	    table.insert(aktuelleKolonner, nyAktuelleKolonner[i])
	  end

	  aktuellRad = aktuellRad - 1
    currentColor = getChosenColor()

    if(hardMode == 1)then

    end


		--Øker hastigheten!
		if(brikkeHastighet - hastighetsFaktor >= maksBrikkeHastighet)then
		  brikkeHastighet = brikkeHastighet - hastighetsFaktor
      --brikkeHastighet = brikkeHastighet - 0 --DEBUG: Winning
		end
		timer.cancel(gameLoopTimer)
		gameLoopTimer = nil

    --Sjekke winCondition
    if(aktuellRad == 0 and #nyAktuelleKolonner > 0)then
      --Winning!
      winning()
      aktuelleKolonner = {}
      return
    end

		gameLoopTimer = timer.performWithDelay(brikkeHastighet, gameLoop, 0)
		--print("Rad: " .. aktuellRad .. " Brikkehastighet: " .. brikkeHastighet)
	end
end

local function spawnSkies()

end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

	-- Code here runs when the scene is first created but has not yet appeared on screen
  hardMode = event.params.mode


  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)
  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)

  minGrense = 4
  ovreGrense = 8

  tidsur = system.getTimer()


  local bakke = display.newRect(halfW ,screenH, screenW, 1)
  physics.addBody( bakke, 'static', veggValg )

  local veggVenstre = display.newRect(0,halfH,1, screenH)
  veggVenstre:setFillColor(0,0,0,0)
  physics.addBody(veggVenstre, 'static', veggValg)
  local hoyreVegg = display.newRect(screenW+1,halfH,1, screenH)
  hoyreVegg:setFillColor(0,0,0,0)

  physics.addBody(hoyreVegg, 'static', veggValg)
  mainGroup:insert(bakke)
  mainGroup:insert(veggVenstre)
  mainGroup:insert(hoyreVegg)

  local background = display.newRect(display.contentCenterX,display.contentCenterY ,screenW,screenH)


  local groundColor = 1
  if(hardMode == 1)then
    background:setFillColor(colors.hardSkyGradient)
    colorIndexer = 7
    colorSelectorStart = 7
    colorSelectorEnd = 11
    groundColor = 6

    hastighetsFaktor = 12
    maksBrikkeHastighet = 10
    brikkeHastighet, OGBrikkeHastighet = 150,150
  else
    background:setFillColor(colors.skyGradient)
    colorIndexer = 2
    colorSelectorStart = 2
    colorSelectorEnd = 6

    hastighetsFaktor = 10
    maksBrikkeHastighet = 20
    brikkeHastighet, OGBrikkeHastighet = 150,150
  end
  currentColor = getChosenColor()





  mainGroup:insert(background)

  --Legger den nederste raden med blokker
  for i = minGrense, ovreGrense do
    local temp = addBuildingBlock(i,numberOfRows,groundColor) --Stålfarge = 1
    physics.addBody(temp, "static" , { friction=0.5 })
  end

  gameLoopTimer = nil
  gameLoopTimer = timer.performWithDelay(brikkeHastighet, gameLoop, 0)






end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

    local letsGo = math.random(1,2)
    if(letsGo == 1) then
      --audio.play(audio.loadSound("Sound/Announcer/lets-go-3.wav"))
    elseif (letsGo == 2 ) then
      --audio.play(audio.loadSound("Sound/Announcer/lets-go-2.wav"))
    end



	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen


    physics.start()
    Runtime:addEventListener( "touch", klikk )

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
    --timer.cancel( gameLoopTimer )
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
    physics.pause()
    Runtime:removeEventListener( "touch", klikk )
		composer.removeScene( "game" )

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
