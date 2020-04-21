local announcerPck = {}

local path = "Sound/Announcer/"

--
--  Load those beautiful annoucner voicelines
--

local youCrazySonABitch = audio.loadSound(path.."you-crazy-son-of-a-bitch.wav")
local ringaDingDingDong = audio.loadSound(path.."ringadingdingdong-motherfucker.wav")

local myMomWouldDoBetter = audio.loadSound(path.."myMom.wav")
local heyPrettyGoodLyd = audio.loadSound(path.."hey-thats-pretty-good.wav")
local maximumSpeedAnnouncer = audio.loadSound(path.."maximum-speed-2.wav")
local omgThatsEmbaressingLyd = audio.loadSound( path.."omg-thats-embaressing.wav" )
local ohYeahNowWereTalkin = audio.loadSound(path.."ah-yeah-now-were-talkin.wav")
local youSuckLyd = audio.loadSound( path.."you-suck.wav"  )
local iMeanItsOkIGuessLyd = audio.loadSound( path.."i-mean-its-ok-i-guess.wav"  )

local wow2Lyd = audio.loadSound(path.."wow-2.wav")
local nice1Lyd = audio.loadSound( path.."nice-1.wav")
local nice2Lyd = audio.loadSound( path.."nice-2.wav")

local ggLyd = audio.loadSound(path.."gg.wav")
local manYouCrazyLyd = audio.loadSound(path.."man-you-crazy.wav")


local letsGo1 = audio.loadSound(path.."lets-go.wav")
local letsGo2 = audio.loadSound(path.."lets-go-2.wav")
local letsGo3 = audio.loadSound(path.."lets-go-3.wav")

--
--  Functions
--

local function say(key)
  if(key == "youCrazySonABitch")then
      audio.play(youCrazySonABitch)
  elseif(key == 'ringaDingDingDong')then
      audio.play(ringaDingDingDong)

  else
    print("Could not find announcer-key '" .. key "'")
  end

end

local function react(points)
  if(points < 6) then
    local rng = math.random(1,3)
    if(rng == 1) then
      audio.play( omgThatsEmbaressingLyd )
    elseif(rng == 2)then
      audio.play(myMomWouldDoBetter)
    else
      audio.play( youSuckLyd )
    end
  elseif(points >= 5 and points < 8) then
    audio.play(iMeanItsOkIGuessLyd)
  elseif(points >= 8 and points < 12) then
    audio.play(ggLyd)
  elseif(points >= 12 and points < 15) then
    audio.play(ohYeahNowWereTalkin)
  elseif(points >= 15 and points < 18) then
    audio.play(heyPrettyGoodLyd)
  elseif(points >= 18 and points < 20) then
    audio.play(heyPrettyGoodLyd)
  end
end

local function streak(streak)
  if(streak%3 == 0 and streak > 0) then
    local rng = math.random(1,3)
    if(rng == 1)then
      audio.play(wow2Lyd)
    elseif(rng == 2)then
      audio.play(nice1Lyd)
    elseif(rng == 3)then
      audio.play(nice2Lyd)
    end
  end
end


local function letsGo()
  local rng = math.random(1,3)
  if(rng == 1)then
    audio.play(letsGo1)
  elseif(rng == 2)then
    audio.play(letsGo2)
  elseif(rng == 3)then
    audio.play(letsGo3)
  end
end



announcerPck['say'] = say
announcerPck['react'] = react
announcerPck['streak'] = streak
announcerPck['letsGo'] = letsGo

return announcerPck
