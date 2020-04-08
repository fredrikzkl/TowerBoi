

-- Set column and row
local column = i
local row = y * 20 - 20

-- Set text of label
local text = i
if i < 10 then
  text = '0' .. text
end


local options =
{
  text = text,
  x = getColumnPosition(column),
  y = row,
  width = getColumnWidth(column+1),
  fontSize = 14,
  align = "left"
}
local label1 = display.newText( options )
label1.anchorX = 0
label1.anchorY = 0
