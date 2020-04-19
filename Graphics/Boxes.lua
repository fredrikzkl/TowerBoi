local boxSheetMapper = {
  frames =
  {
    {--Brun 1
      x = 0,
      y = 0,
      width = 32,
      height = 32
    },
    {--Blå 2
      x = 0,
      y = 32,
      width = 32,
      height = 32
    },
    {--Grønn 3
      x = 0,
      y = 32*2,
      width = 32,
      height = 32
    },
    {--Gul 4
      x = 0,
      y = 32*3,
      width = 32,
      height = 32
    },
    {--Rosa 5
      x = 0,
      y = 32*4,
      width = 32,
      height = 32
    },


    --HardMode Bokser


    {--Grå 6
      x = 32,
      y = 0,
      width = 32,
      height = 32
    },
    {-- 7
      x = 32,
      y = 32,
      width = 32,
      height = 32
    },
    {-- 8
      x = 32,
      y = 32*2,
      width = 32,
      height = 32
    },
    {-- 9
      x = 32,
      y = 32*3,
      width = 32,
      height = 32
    },
    {-- 10
      x = 32,
      y = 32*4,
      width = 32,
      height = 32
    },

  }
}


local boxSheet = graphics.newImageSheet( "Sprites/boxes.png", boxSheetMapper )

return boxSheet
