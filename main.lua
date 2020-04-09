
display.setStatusBar( display.HiddenStatusBar )

-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
--Pakker
math.randomseed( os.time() )
local physics =  require('physics')
physics.start()
physics.setGravity( 0, 8 )


local time = system.getTimer()
local gameLoopTimer

-- Screen size
local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH =  screenW*0.5, screenH*0.5

-- Grid
local gridHeight = 0.99
numberOfColumns = 11
numberOfRows = 20
columnWidth = math.floor( screenW / numberOfColumns )
rowHeight = math.floor(screenH*gridHeight / numberOfRows)
local boksReferanse = {}


function getColumnPosition( columnNumber )
	return (columnNumber - 0.5) * columnWidth
end
function getColumnWidth( numberOfColumns )
	return numberOfColumns * columnWidth
end
function getRowPosition(rowNumber)
  return (rowNumber) * rowHeight
end

-- DisplayGroups
local mainGroup = display.newGroup()


function addBuildingBlock(x,y)
  local newBlock = display.newImageRect(mainGroup, "Sprites/box.png", columnWidth, rowHeight)
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
    --addBuildingBlock(i, y)
	end
end


-----------------------------------------------------------------------------------------
--
-- Spillet
--
-----------------------------------------------------------------------------------------
local minGrense = 4
local ovreGrense = 8
--La oss sette opp spill Variabler

local aktuellRad = numberOfRows-1 --Raden spilleren er på
local aktuelleKolonner = {-4,-3,-2,-1,0} --Raden de ligger på, startsbrikker
local retning = "hoyre"
local brikkeHastighet = 150
local hastighetsFaktor = 10
local okningsTid = 3000

local debrisTable = {}



--Legger den nederste raden med blokker
for i = minGrense, ovreGrense do
  local temp = addBuildingBlock(i,numberOfRows)
  physics.addBody(temp, "static" , { friction=0.5 })
end

--Legger inn bakken, slik at brikken faller på bakken

local veggValg = {
	friction = 0.1,
}

local bakke = display.newRect(halfW ,screenH, screenW, 15)
physics.addBody( bakke, 'static', veggValg )
local veggVenstre = display.newRect(0,halfH,1, screenH)
physics.addBody(veggVenstre, 'static', veggValg)
local hoyreVegg = display.newRect(screenW+1,halfH,1, screenH)
physics.addBody(hoyreVegg, 'static', veggValg)



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
      table.insert(boksReferanse, addBuildingBlock(aktuelleKolonner[i], aktuellRad))
    end
end




local function gameLoop()

  if(#aktuelleKolonner == 0) then --Dersom listen er tom, har man tapt
  end

  flyttBrikker()

	local t = system.getTimer()
	--Time Management - øker hastigheten over tid
	--[[
	if(t - time > okningsTid and brikkeHastighet > 50)then
		print("Øker hastigheten!")
		brikkeHastighet = brikkeHastighet - 10
		timer.cancel(gameLoopTimer)
		gameLoopTimer = nil
		gameLoopTimer = timer.performWithDelay(brikkeHastighet, gameLoop, 0)
		time = system.getTimer()
	end
	]]
end

gameLoopTimer = timer.performWithDelay(brikkeHastighet, gameLoop, 0)




-----------------------------------------------------------------------------------------
--
-- Input
--
-----------------------------------------------------------------------------------------

local function fjernAlleBokser()
  for i = 1, #boksReferanse do
    display.remove( boksReferanse[i] )
  end
  boksReferanse = {}
end

--physics.setDrawMode( 'hybrid' )
local function lagRester(colPos) --Lager blokker som er påvirket av fysikken, men har ingen funksjonalitet
	local tempDeb = addBuildingBlock(colPos, aktuellRad)
	table.insert(debrisTable, tempDeb)
	physics.addBody( tempDeb , 'dynamic', {bounce = 0.4} )
	local torque = 0
	if retning == "hoyre" then
		torque = -1
	elseif retning == "venstre" then
		torque = 1
	end

	tempDeb:applyTorque(torque)
end


local function klikk(event)
	if event.phase == 'began' then
	  local nyAktuelleKolonner = {}
	  --Må sjekke hvilke som henger ut
	  for i=1, #aktuelleKolonner do
	    if(aktuelleKolonner[i] >= minGrense and aktuelleKolonner[i] <= ovreGrense) then
	      table.insert(nyAktuelleKolonner, aktuelleKolonner[i])
			else
				lagRester(aktuelleKolonner[i])
	    end
	  end

	  --NyeAktuelleKolonner skal inneholde de verdiene som erinnenfor
	  for i=1, #nyAktuelleKolonner do
	    local temp = addBuildingBlock(nyAktuelleKolonner[i],aktuellRad)
			physics.addBody( temp, "static", { friction=0.5 } )
	  end

	  minGrense = nyAktuelleKolonner[1]
	  ovreGrense = nyAktuelleKolonner[#nyAktuelleKolonner]

	  fjernAlleBokser()
	  aktuelleKolonner = {}
	  for i = 1, #nyAktuelleKolonner do
	    table.insert(aktuelleKolonner, nyAktuelleKolonner[i])
	  end

	  aktuellRad = aktuellRad - 1


		--Øker hastigheten!
		brikkeHastighet = brikkeHastighet - hastighetsFaktor
		timer.cancel(gameLoopTimer)
		gameLoopTimer = nil
		gameLoopTimer = timer.performWithDelay(brikkeHastighet, gameLoop, 0)
		print("Rad: " .. aktuellRad .. " Brikkehastighet: " .. brikkeHastighet)
	end
end

Runtime:addEventListener( "touch", klikk )
