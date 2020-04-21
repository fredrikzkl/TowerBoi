function rgb(val)
  return val/255
end


local colorPck = {
  boxGreen = {rgb(55),rgb(148),rgb(110)},
  green = {rgb(106),rgb(190),rgb(48)},
  mursteinsRod = {rgb(139),rgb(27),rgb(27)},


  skyGradient = {
	    type="gradient",
	    color1={rgb(20),rgb(71),rgb(153)}, color2={rgb(52),rgb(237),rgb(212)}, direction="down"
  },
  skyGradient2 = {
    type="gradient",
    color1={rgb(52),rgb(237),rgb(212)}, color2={rgb(247),rgb(124),rgb(245)}, direction="down"
  },
  hardSkyGradient = {
	    type="gradient",
	    color1={rgb(255),rgb(172),rgb(171)}, color2={rgb(255),rgb(253),rgb(177)}, direction="down"
  },
  hardSkyGradient2 = {
	    type="gradient",
	    color1={rgb(255),rgb(253),rgb(177)}, color2={rgb(247),rgb(124),rgb(245)}, direction="down"
  }
}


return colorPck
