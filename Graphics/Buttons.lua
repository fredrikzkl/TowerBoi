buttonSheetMappper = {
  frames = {
    {--Classic Green 1
      x = 0,
      y = 0,
      width = 64,
      height = 32
    },
    {--Yellow 2
      x = 0,
      y = 32,
      width = 64,
      height = 32
    },
    {--Red 3
      x = 0,
      y = 32*2,
      width = 64,
      height = 32
    },
    {--Blue 4
      x = 0,
      y = 32*3,
      width = 64,
      height = 32
    },
    {--Disabled 5
      x = 0,
      y = 32*4,
      width = 64,
      height = 32
    }
  }
}

local buttonGraphics = graphics.newImageSheet( "Sprites/knapp.png", buttonSheetMappper )

return buttonGraphics
