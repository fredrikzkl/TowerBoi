buttonSheetMappper = {
  frames = {
    {--Classic Green
      x = 0,
      y = 0,
      width = 64,
      height = 32
    },
    {--Yellow
      x = 0,
      y = 32,
      width = 64,
      height = 32
    },
    {--Red
      x = 0,
      y = 32*2,
      width = 64,
      height = 32
    },
    {--Blue
      x = 0,
      y = 32*3,
      width = 64,
      height = 32
    },
  }
}

local buttonGraphics = graphics.newImageSheet( "Sprites/knapp.png", buttonSheetMappper )

return buttonGraphics
