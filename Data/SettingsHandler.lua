local package = {}

local json = require( "json" )

local filePath = system.pathForFile( "settings.json", system.DocumentsDirectory )

--Denne er bare for å vise hvordan filen ser ut
local settingsTemplate  = {
  master = 1.0,
  music = 1.0, --Channel 4
  sfx = 1.0, --Channel 2?
  announcer = 1.0 --Channel 3
}

local function loadSettings()
	local file = io.open( filePath, "r" )

  local save

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		save = json.decode( contents )
	end

	if ( save == nil ) then
		save = settingsTemplate
	end

  return save
end



local function saveSettings(jsonVar)

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( jsonVar ) )
		io.close( file )
	end
end

local function updateVolume()
    local save = loadSettings()
    audio.setVolume( save['master'] )--Master
    audio.setVolume( save['sfx'], {channel=2} )--Sfx
    audio.setVolume( save['announcer'], {channel=3} )--Announcer
    audio.setVolume( save['music'], {channel=4}  )--Music
end



package["loadSettings"] = (loadSettings)
package["saveSettings"] = (saveSettings)
package["updateVolume"] = (updateVolume)

return package
