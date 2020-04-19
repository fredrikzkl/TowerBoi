local sfxPck = {}


local byggLyd = audio.loadSound("Sound/build.wav")
local maxSpeedLyd = audio.loadSound( "Sound/maxSpeed.wav")
local proceedLyd = audio.loadSound("Sound/proceed.wav")
local failLyd = audio.loadSound("Sound/fail.wav")
local bigFailLyd = audio.loadSound("Sound/big_fail.wav")
local deadLyd = audio.loadSound("Sound/dead_2.wav")
local crowd2Lyd =  audio.loadSound("Sound/Crowd_2.mp3")
local party_horn =  audio.loadSound("Sound/party_horn.mp3")


local function play(key)
  if key == 'dead' then
    audio.play(deadLyd)
  elseif key == 'bigFail' then
    audio.play(bigFailLyd)
  elseif key == 'fail' then
    audio.play(failLyd)
  elseif('build') then
    audio.play(byggLyd)
  elseif key == 'maxSpeed' then
    audio.play(maxSpeedLyd)
  elseif key == 'proceed' then
    audio.play(proceedLyd)
  end
end


local function winning(mode)
  audio.play(crowd2Lyd)
  audio.play(party_horn)
end



sfxPck['play'] = play
sfxPck['winning'] = winning
return sfxPck
