local package = {}

local json = require( "json" )

local filePath = system.pathForFile( "savefile.json", system.DocumentsDirectory )

--Denne er bare for å vise hvordan filen ser ut
local saveStructure  = {
  bestHeight = 0, --Om bestHeigh == 20, så har man runnet spillet
  bestTime = 0 --Er bare triggered dersom bestHeight == 20,
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


function addHighScore(newHeight, newTime)
  local score = loadScores()
  if(newHeight > score.bestHeight)then
    --print("Saved! Old:" .. score.bestHeight .. " new: "..newHeight)
    score.bestHeight = newHeight
  end
  if newTime ~= nil then

    local currentTime = score.bestTime
    if newTime < currentTime or currentTime == 0 then
      score.bestTime  = newTime
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

return package
