local sfxPck = {}


local byggLyd = audio.loadSound("Sound/build.wav")
local maxSpeedLyd = audio.loadSound( "Sound/maxSpeed.wav")
local proceedLyd = audio.loadSound("Sound/proceed.wav")
local failLyd = audio.loadSound("Sound/fail.wav")
local bigFailLyd = audio.loadSound("Sound/big_fail.wav")
local deadLyd = audio.loadSound("Sound/dead_2.wav")
local crowd2Lyd =  audio.loadSound("Sound/Crowd_2.mp3")
local party_horn =  audio.loadSound("Sound/party_horn.mp3")
local deleteSave = audio.loadSound("Sound/deleteSave.wav")
local disabled = audio.loadSound("Sound/disabled.wav")


local normalMode = audio.loadSound("Sound/normalMode.wav")
local hardMode = audio.loadSound("Sound/expertMode.wav")

local macClick = audio.loadSound("Sound/macKlikk.wav")


local function play(key)
  if key == 'dead' then
    audio.play(deadLyd)
  elseif key == 'bigFail' then
    audio.play(bigFailLyd)
  elseif key == 'fail' then
    audio.play(failLyd)
  elseif key == 'build' then
    audio.play(byggLyd)
  elseif key == 'maxSpeed' then
    audio.play(maxSpeedLyd)
  elseif key == 'proceed' then
    audio.play(proceedLyd)
  elseif key=='normalMode' then
    audio.play(normalMode)
  elseif key=='hardMode' then
    audio.play(hardMode)
  elseif key=='deleteSave'then
    audio.play(deleteSave)
  elseif key=='disabled' then
    audio.play(disabled)
  end
end

local function click()
  audio.play(macClick)
end


local function winning(mode)
  audio.play(crowd2Lyd)
  audio.play(party_horn)
end



sfxPck['play'] = play
sfxPck['winning'] = winning
sfxPck['click'] = click
return sfxPck
