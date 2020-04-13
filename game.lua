
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local sky = require('sky')
local physics =  require('physics')
physics.start()
local font = "Font/Pixellari.ttf"

physics.setGravity( 0, 8 )


local colors = {
    {224,229,229}, --Steel (1)
    --RainBow
    {230, 38, 31}, --Red(2),
    {235, 117, 50}, --Orange(3),
    {247, 208, 56}, --Yellow(4),
    {163, 224, 72}, --Green(5),
    {52, 187, 230},  --lyseblå(6),
    {67, 85, 219},  --blå(7),
    {210, 59, 231}  --blå(8),
}

local boxSheetMapper = {
  frames =
  {
    {--Brun
      x = 0,
      y = 0,
      width = 32,
      height = 32
    },
    {--Blå
      x = 0,
      y = 32,
      width = 32,
      height = 32
    },
    {--Grønn
      x = 0,
      y = 32*2,
      width = 32,
      height = 32
    },
    {--Gul
      x = 0,
      y = 32*3,
      width = 32,
      height = 32
    },
    {--Rosa
      x = 0,
      y = 32*4,
      width = 32,
      height = 32
    }
  }
}

local boxSheet = graphics.newImageSheet( "Sprites/boxes.png", boxSheetMapper )

local colorIndexer = 2
function getChosenColor()
  local temp = colorIndexer
  colorIndexer = colorIndexer + 1
  if(colorIndexer+1 > 6)then
    colorIndexer = 2
  end
  return temp
end

local function rgb(val)
  return val/255
end

--Skjermreferanser
local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH =  screenW*0.5, screenH*0.5
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
local brikkeHastighet, OGBrikkeHastighet = 150,150

local hastighetsFaktor = 10
local okningsTid = 3000
local maksBrikkeHastighet = 20

local debrisTable = {}
local statiskeBlokkerTable = {}

local currentColor = getChosenColor()

--Lyder og myikk
local proceedLyd
local byggLyd

local crowd2Lyd
local partyHornLyd


local maximumSpeedAnnouncer
local maxSpeedLyd
local doYouEvenTry
local ggLyd
local manYouCrazyLyd
local heyPrettyGoodLyd
local omgThatsEmbaressingLyd
local wow2Lyd
local ohYeahNowWereTalkin
local youSuckLyd
local iMeanItsOkIGuessLyd
local ringadingdingdonMotherfuckerLyd

--Legger inn bakken, slik at brikken faller på bakken

local veggValg = {
	friction = 0.1,
}


local function flyttBrikker()
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
      table.insert(boksReferanse, addBuildingBlock(aktuelleKolonner[i], aktuellRad, currentColor))
    end
end

local function restart()
  audio.play( proceedLyd  )
  composer.gotoScene( 'lobby' )
  --local thisScene = composer.getSceneName( 'current' )
  --composer.gotoScene( thisScene )
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
  local components = {}
  local buttonFrame = display.newImageRect( "Sprites/knapp.png", 260, 85 )
  buttonFrame.x = halfW
  buttonFrame.y = screenH-100
  uiGroup:insert(buttonFrame)
  local playAgain = display.newText("Spill igjen", halfW, screenH-100, font, 50)
  playAgain:setFillColor(1,1,1)
  uiGroup:insert(playAgain)
  buttonFrame:addEventListener( "tap", restart )
  table.insert(components, buttonFrame)
  table.insert(components, playAgain)
  return components
end



local winning = false
local function gameLoop()

  if(#aktuelleKolonner == 0) then --Dersom listen er tom, har man tapt
    local result = (numberOfRows - aktuellRad) - 1
    if(winning) then
      result = 20
    end
    --Lydeffekt
      if(result < 3) then
        audio.play( youSuckLyd )
      elseif(result >= 3 and result < 5) then
        audio.play( omgThatsEmbaressingLyd )
      elseif(result >= 5 and result < 8) then
        audio.play(iMeanItsOkIGuessLyd)
      elseif(result >= 8 and result < 10) then
        audio.play(ggLyd)
      elseif(result >= 10 and result < 13) then
        audio.play(ohYeahNowWereTalkin)
      elseif(result >= 13 and result < 15) then
        audio.play(heyPrettyGoodLyd)
      end
    --
    aktuelleKolonner = {}
		Runtime:removeEventListener( "touch", klikk )
		timer.cancel(gameLoopTimer)

		print("Ferdig! Du bygget et hus på " .. result )

		local ggbro = display.newEmbossedText("GG, bro", halfW, halfH*0.5+45, font, 50)
    local adas =
    {
        highlight = { r=1, g=1, b=1 },
        shadow = { r=0.3, g=0.3, b=0.3 }
    }

    ggbro:setEmbossColor( adas )
		uiGroup:insert(ggbro)
		local points = display.newText("Poeng: " .. result, halfW, halfH*0.65+45, font, 30)
		uiGroup:insert(points)


		--display.newText("GG, bro", halfW, halfH, font, 40)
    timer.performWithDelay(1000, generatePlayAgainButton)
  end

  flyttBrikker()
end



-----------------------------------------------------------------------------------------
--
-- Input
--
-----------------------------------------------------------------------------------------
local function ringaDing()
  audio.play(ringadingdingdonMotherfuckerLyd)
  local playAgainButton = generatePlayAgainButton()
  playAgainButton[1].alpha = 0
  playAgainButton[2].alpha = 0
  local winText = display.newEmbossedText("You son of a bitch,\n      you did it!", halfW, halfH*0.5+85, font, 50)
  uiGroup:insert(winText)
  winText.alpha = 0
  transition.fadeIn( winText, { time=2000 } )
  transition.fadeIn( playAgainButton[1], { time=2000 } )
  transition.fadeIn( playAgainButton[2], { time=2000 } )
end

local function winning()
  winning = true
  audio.play(crowd2Lyd)
  audio.play(party_horn)
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

local five_streak = 0
local function klikk(event)
	if event.phase == 'began' and (#aktuelleKolonner > 0)  then
    audio.play( byggLyd  )

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

    if(teller == 5)then
      five_streak = five_streak + 1
      if(five_streak == 3) then
        audio.play(wow2Lyd)
      end
    end


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


		--Øker hastigheten!
		if(brikkeHastighet - hastighetsFaktor >= maksBrikkeHastighet)then
			--brikkeHastighet = brikkeHastighet - hastighetsFaktor
      brikkeHastighet = brikkeHastighet - 0
		else
      if(#nyAktuelleKolonner > 0) then
        audio.play(maxSpeedLyd)
        maxSpeedLyd = nil
      end
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


  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)
  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)

  minGrense = 4
  ovreGrense = 8



  local gradient = {
    type="gradient",
    color1={rgb(20),rgb(71),rgb(153)}, color2={rgb(52),rgb(237),rgb(212)}, direction="down"
  }

  local background = display.newRect(display.contentCenterX,display.contentCenterY ,screenW,screenH)
  background:setFillColor(gradient)
  mainGroup:insert(background)

  local bakke = display.newRect(halfW ,screenH, screenW, 1)
  physics.addBody( bakke, 'static', veggValg )

  local veggVenstre = display.newRect(0,halfH,1, screenH)
  physics.addBody(veggVenstre, 'static', veggValg)
  local hoyreVegg = display.newRect(screenW+1,halfH,1, screenH)
  physics.addBody(hoyreVegg, 'static', veggValg)
  mainGroup:insert(bakke)
  mainGroup:insert(veggVenstre)
  mainGroup:insert(hoyreVegg)



  --Legger den nederste raden med blokker
  for i = minGrense, ovreGrense do
    local temp = addBuildingBlock(i,numberOfRows,1) --Stålfarge = 1
    physics.addBody(temp, "static" , { friction=0.5 })
  end

  gameLoopTimer = nil
  gameLoopTimer = timer.performWithDelay(brikkeHastighet, gameLoop, 0)

  byggLyd = audio.loadSound("Sound/build.wav")
  maxSpeedLyd = audio.loadSound( "Sound/maxSpeed.wav")
  proceedLyd = audio.loadSound("Sound/proceed.wav")
  crowd2Lyd =  audio.loadSound("Sound/Crowd_2.mp3")
  party_horn =  audio.loadSound("Sound/party_horn.mp3")

  wow2Lyd = audio.loadSound("Sound/Announcer/wow-2.wav")
  heyPrettyGoodLyd = audio.loadSound("Sound/Announcer/hey-thats-pretty-good.wav")
  maximumSpeedAnnouncer = audio.loadSound('Sound/Announcer/maximum-speed-2.wav')
  omgThatsEmbaressingLyd = audio.loadSound( "Sound/Announcer/omg-thats-embaressing.wav" )
  ohYeahNowWereTalkin = audio.loadSound("Sound/Announcer/ah-yeah-now-were-talkin.wav")
  youSuckLyd = audio.loadSound( "Sound/Announcer/you-suck.wav"  )
  iMeanItsOkIGuessLyd = audio.loadSound( "Sound/Announcer/i-mean-its-ok-i-guess.wav"  )

  ggLyd = audio.loadSound("Sound/Announcer/gg.wav")
  manYouCrazyLyd = audio.loadSound("Sound/Announcer/man-you-crazy.wav")
  ringadingdingdonMotherfuckerLyd = audio.loadSound("Sound/Announcer/ringadingdingdong-motherfucker.wav")
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

    aktuelleKolonner = {-4,-3,-2,-1,0}
    brikkeHastighet = OGBrikkeHastighet
    boksReferanse = {}
    debrisTable = {}
    retning = "hoyre"
    aktuellRad = numberOfRows-1

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
