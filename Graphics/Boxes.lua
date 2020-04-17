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
    },

  }
}


local boxSheet = graphics.newImageSheet( "Sprites/boxes.png", boxSheetMapper )

return boxSheet
