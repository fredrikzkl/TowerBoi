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

local options =
{
    channel = 2
}


local function play(key)
  if key == 'dead' then
    audio.play(deadLyd, options)
  elseif key == 'bigFail' then
    audio.play(bigFailLyd, options)
  elseif key == 'fail' then
    audio.play(failLyd, options)
  elseif key == 'build' then
    audio.play(byggLyd, options)
  elseif key == 'maxSpeed' then
    audio.play(maxSpeedLyd, options)
  elseif key == 'proceed' then
    audio.play(proceedLyd, options)
  elseif key=='normalMode' then
    audio.play(normalMode, options)
  elseif key=='hardMode' then
    audio.play(hardMode, options)
  elseif key=='deleteSave'then
    audio.play(deleteSave, options)
  elseif key=='disabled' then
    audio.play(disabled, options)
  end
end

local function click()
  audio.play(macClick, options)
end


local function winning()
  audio.play(crowd2Lyd)
  audio.play(party_horn)
end



sfxPck['play'] = play
sfxPck['winning'] = winning
sfxPck['click'] = click
return sfxPck
