local class = {}

local skyTable = {}

local sheetMapper = {
  frames =
  {
    {--Brun
      x = 0,
      y = 0,
      width = 64,
      height = 32
    }
  }
}

local skySheet = graphics.newImageSheet( "Sprites/skies.png", sheetMapper )


return skySheet
