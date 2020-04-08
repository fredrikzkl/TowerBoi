
display.setStatusBar( display.HiddenStatusBar )

-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
--Pakker
local physics =  require('physics')
physics.start()

local gameLoopTimer

-- Screen size
local screenW, screenH, halfW, halfH = display.viewableContentWidth, display.viewableContentHeight, display.viewableContentWidth*0.5, display.viewableContentHeight*0.5

-- Grid
numberOfColumns = 11
numberOfRows = 20
columnWidth = math.floor( screenW / numberOfColumns )
rowHeight = math.floor(screenH / numberOfRows)
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
local brikkeHastighet = 100
local brikkeHastighetsFaktor = 1

--Legger den nederste raden med blokker
for i = minGrense, ovreGrense do
  local temp = addBuildingBlock(i,numberOfRows)
  physics.addBody(temp, "static")
end

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
end


gameLoopTimer = timer.performWithDelay( brikkeHastighet, gameLoop, 0  )


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


local function klikk()
  local nyAktuelleKolonner = {}
  --Må sjekke hvilke som henger ut
  for i=1, #aktuelleKolonner do
    if(aktuelleKolonner[i] >= minGrense and aktuelleKolonner[i] <= ovreGrense) then
      table.insert(nyAktuelleKolonner, aktuelleKolonner[i])
    end
  end

  --NyeAktuelleKolonner skal inneholde de verdiene som erinnenfor
  for i=1, #nyAktuelleKolonner do
    addBuildingBlock(nyAktuelleKolonner[i],aktuellRad)
  end

  minGrense = nyAktuelleKolonner[1]
  ovreGrense = nyAktuelleKolonner[#nyAktuelleKolonner]

  fjernAlleBokser()
  aktuelleKolonner = {}
  for i = 1, #nyAktuelleKolonner do
    table.insert(aktuelleKolonner, nyAktuelleKolonner[i])
  end

  aktuellRad = aktuellRad - 1
  --brikkeHastighet = brikkeHastighet - brikkeHastighetsFaktor
  print("Brikkehastighet: " .. brikkeHastighet)
  --gameLoopTimer = timer.performWithDelay( brikkeHastighet, gameLoop, 0  )

end

Runtime:addEventListener( "tap", klikk )
