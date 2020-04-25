local package = {}

local json = require( "json" )
local crypto = require( "crypto" )

local filePath = system.pathForFile( "savefile.json", system.DocumentsDirectory )


function getHash(file)
  local str = ""

  for i=1, #file['results'] do
    str = str .. file['results'][i]
  end
  str = str .. file['bestTime'] .. file['bestTimeDate'].min .. file['bestTimeDate'].sec
  str = str .. file['bestTimeDate'].day .. file['bestTimeDate'].month .. file['bestTimeDate'].year
  for i=1, #file['hardResults'] do
    str = str .. file['hardResults'][i]
  end
  str = str .. file['hardBestTime'] .. file['bestHardTimeDate'].min .. file['bestHardTimeDate'].sec
  str = str .. file['bestHardTimeDate'].day .. file['bestHardTimeDate'].month .. file['bestHardTimeDate'].year

  return crypto.digest( crypto.sha1, str )
end

--Denne er bare for å vise hvordan filen ser ut
local saveStructure  = {
  hardMode = 0,

  bestTime = 0,
  bestTimeDate = os.date("*t"),
  results = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},


  hardBestTime = 0,
  bestHardTimeDate = os.date("*t"),
  hardResults = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},

  saveKey = ""
}

local function checkForCheat(saveFile)
  local testHash = getHash(saveFile)
  if(testHash ~= saveFile.saveKey)then
    return true
  end
  return false
end

local function loadScores()
	local file = io.open( filePath, "r" )

  local save

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		save = json.decode( contents )
	end

	if ( save == nil ) then
		save = saveStructure
    save.saveKey = getHash(save)
	end

  return save
end



local function saveScores(jsonVar)
  jsonVar.saveKey = getHash(jsonVar)
	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( jsonVar ) )
		io.close( file )
	end
end

local function toggleHardMode()
  local score = loadScores()
  if score.hardMode == 0 and score.results[20] > 0 then
    score.hardMode = 1
  else
    score.hardMode = 0
  end
  saveScores(score)
end


function addHighScore(newHeight, newTime)
  local score = loadScores()

  if(score.hardMode == 0) then
    score.results[newHeight] = score.results[newHeight] + 1

    if newTime ~= nil then
      local currentTime = score.bestTime
      if newTime < currentTime or currentTime == 0 then
        score.bestTime  = newTime
        score.bestTimeDate = os.date("*t")
      end
    end
  else
    score.hardResults[newHeight] = score.hardResults[newHeight] + 1

    if newTime ~= nil then
      local currentTime = score.hardBestTime
      if newTime < currentTime or currentTime == 0 then
        score.hardBestTime  = newTime
        score.bestHardTimeDate = os.date("*t")
      end
    end
  end

  saveScores(score)
end



function deleteHighScore()
  saveScores(saveStructure)
end


package["loadScores"] = (loadScores)
package["addHighScore"] = (addHighScore)
package["deleteHighScore"] = (deleteHighScore)
package['toggleHardMode'] = toggleHardMode
package['checkForCheat'] = checkForCheat

return package
