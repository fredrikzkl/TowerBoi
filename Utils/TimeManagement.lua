local pck = {}
local floor = math.floor

local function toFormatedTime(totalTid)
  local ms = floor(totalTid % 1000)
  local hundredths = floor(ms / 10)
  local seconds = floor(totalTid / 1000)
  local minutes = floor(seconds / 60);   seconds = floor(seconds % 60)
  return string.format("%02d:%02d:%02d", minutes, seconds, hundredths)
end

pck['toFormatedTime'] = toFormatedTime

return pck
