local announcerPck = {}

local path = "Sound/Announcer/"

--
--  Load those beautiful annoucner voicelines
-- CHANNEL 3
--

local options =
{
    channel = 3
}

local youCrazySonABitch = audio.loadSound(path.."you-crazy-son-of-a-bitch.wav")
local ringaDingDingDong = audio.loadSound(path.."ringadingdingdong-motherfucker.wav")

local myMom = audio.loadSound(path.."myMom.wav")
local heyPrettyGoodLyd = audio.loadSound(path.."hey-thats-pretty-good.wav")
local maximumSpeedAnnouncer = audio.loadSound(path.."maximum-speed-2.wav")
local omgThatsEmbaressingLyd = audio.loadSound( path.."omg-thats-embaressing.wav" )
local ohYeahNowWereTalkin = audio.loadSound(path.."ah-yeah-now-were-talkin-2.wav")
local youSuckLyd = audio.loadSound( path.."you-suck.wav"  )
local iMeanItsOkIGuessLyd = audio.loadSound( path.."i-mean-its-ok-i-guess.wav"  )
local godDamnClose = audio.loadSound( path.."so-god-damn-close.wav"  )
local shitsNitzelgodDamnClose = audio.loadSound( path.."aah-shitsnitzel-so-god-damn-close.wav"  )
local doYouEvenTry = audio.loadSound( path.."do-you-even-try.wav"  )

--Streaks
local onFire = audio.loadSound(path.."on-fire.wav")
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
      audio.play(youCrazySonABitch, options)
  elseif(key == 'ringaDingDingDong')then
      audio.play(ringaDingDingDong, options)

  else
    print("Could not find announcer-key '" .. key "'")
  end

end

local function react(points)
  if(points < 8) then
    local rng = math.random(1,3)
    if(rng == 1) then
      audio.play( omgThatsEmbaressingLyd , options)
    elseif(rng == 2)then
      audio.play(myMom , options)
    else
      audio.play( youSuckLyd , options)
    end
  elseif(points == 8) then
    audio.play(doYouEvenTry, options)
  elseif(points >= 8 and points < 10) then
    audio.play(iMeanItsOkIGuessLyd, options)
  elseif(points >= 10 and points < 13) then
    audio.play(ggLyd, options)
  elseif(points >= 13 and points < 16) then
    audio.play(ohYeahNowWereTalkin, options)
  elseif(points >= 16 and points < 18) then
    audio.play(heyPrettyGoodLyd, options)
  elseif(points >= 18 and points <20)then
    audio.play(shitsNitzelgodDamnClose, options)
  end
end

local nice = 0
local function streak(streak)
  if streak < 3 then
    nice = 0
  end

  if(nice == 1 and streak > 3) then
    audio.play(nice2Lyd, options)
    nice = 0
    return
  end

  if(streak%4 == 0 and streak > 0) then
    local rng = math.random(1,3)
    if(rng == 1)then
      audio.play(wow2Lyd, options)
    elseif(rng == 2)then
      audio.play(nice1Lyd, options)
      nice = 1
    elseif(rng == 3)then
      audio.play(onFire, options)
    end
  end


end


local function letsGo()
  local rng = math.random(1,3)
  if(rng == 1)then
    audio.play(letsGo1, options)
  elseif(rng == 2)then
    audio.play(letsGo2,options)
  elseif(rng == 3)then
    audio.play(letsGo3,options)
  end
end




announcerPck['say'] = say
announcerPck['react'] = react
announcerPck['streak'] = streak
announcerPck['letsGo'] = letsGo

return announcerPck
