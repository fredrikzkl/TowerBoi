local package = {}

local json = require( "json" )

local filePath = system.pathForFile( "savefile.json", system.DocumentsDirectory )

--Denne er bare for å vise hvordan filen ser ut
local saveStructure  = {
  hardMode = 0,

  bestTime = 0,
  bestTimeDate = 0,
  results = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},


  hardBestTime = 0,
  bestTimeDate = 0,
  hardResults = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
}

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
	end

  return save
end



local function saveScores(jsonVar)

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
      end
    end
  else
    score.hardResults[newHeight] = score.hardResults[newHeight] + 1

    if newTime ~= nil then
      local currentTime = score.hardBestTime
      if newTime < currentTime or currentTime == 0 then
        score.hardBestTime  = newTime
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

return package
