local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "KogMaw" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/KogMaw/master/KogMaw.lua', SCRIPT_PATH .. 'KogMaw.lua', function() PrintChat('<font color = "#00FFFF">KogMaw Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/KogMaw/master/KogMaw.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local KogMawMenu = Menu("KogMaw", "KogMaw")

KogMawMenu:SubMenu("Combo", "Combo")

KogMawMenu.Combo:Boolean("Q", "Use Q in combo", true)
KogMawMenu.Combo:Boolean("AA", "Use AA in combo", true)
KogMawMenu.Combo:Boolean("W", "Use W in combo", true)
KogMawMenu.Combo:Boolean("E", "Use E in combo", true)
KogMawMenu.Combo:Boolean("R", "Use R in combo", true)
KogMawMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
KogMawMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
KogMawMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
KogMawMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
KogMawMenu.Combo:Boolean("RHydra", "Use RHydra", true)
KogMawMenu.Combo:Boolean("THydra", "Use THydra", true)
KogMawMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
KogMawMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
KogMawMenu.Combo:Boolean("Randuins", "Use Randuins", true)


KogMawMenu:SubMenu("AutoMode", "AutoMode")
KogMawMenu.AutoMode:Boolean("Level", "Auto level spells", false)
KogMawMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
KogMawMenu.AutoMode:Boolean("Q", "Auto Q", false)
KogMawMenu.AutoMode:Boolean("W", "Auto W", false)
KogMawMenu.AutoMode:Boolean("E", "Auto E", false)
KogMawMenu.AutoMode:Boolean("R", "Auto R", false)


KogMawMenu:SubMenu("LaneClear", "LaneClear")
KogMawMenu.LaneClear:Boolean("Q", "Use Q", true)
KogMawMenu.LaneClear:Boolean("W", "Use W", true)
KogMawMenu.LaneClear:Boolean("E", "Use E", true)
KogMawMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
KogMawMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

KogMawMenu:SubMenu("Harass", "Harass")
KogMawMenu.Harass:Boolean("Q", "Use Q", true)
KogMawMenu.Harass:Boolean("W", "Use W", true)

KogMawMenu:SubMenu("KillSteal", "KillSteal")
KogMawMenu.KillSteal:Boolean("Q", "KS w Q", true)
KogMawMenu.KillSteal:Boolean("E", "KS w E", true)
KogMawMenu.KillSteal:Boolean("R", "KS w R", true)
KogMawMenu.KillSteal:Boolean("W", "KS w W", true)

KogMawMenu:SubMenu("AutoIgnite", "AutoIgnite")
KogMawMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

KogMawMenu:SubMenu("Drawings", "Drawings")
KogMawMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

KogMawMenu:SubMenu("SkinChanger", "SkinChanger")
KogMawMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
KogMawMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
        local THydra = GetItemSlot(myHero, 3748)
		
	--AUTO LEVEL UP
	if KogMawMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if KogMawMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 1175) then
				if target ~= nil then 
                                      CastSkillShot(_Q, enemy)
                                end
            end

            if KogMawMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 650) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
		
	    if KogMawMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 500) and (EnemiesAround(myHeroPos(), 500) >= KogMawMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end
			
            if KogMawMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if KogMawMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if KogMawMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if KogMawMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if KogMawMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1280) then
			 CastSkillShot(_E, enemy)
	    end

            if KogMawMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 650) then
			CastSpell(_W)
            end		
			   				    
            if KogMawMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end		
			
            if KogMawMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1175) then
		     if target ~= nil then 
                         CastSkillShot(_Q, target)
                     end
            end
				  
            if KogMawMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end

            
            if KogMawMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if KogMawMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end

            if KogMawMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if KogMawMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end
				
			
	    if KogMawMenu.Combo.THydra:Value() and THydra > 0 and Ready(THydra) and ValidTarget(target, 400) then
			CastSpell(THydra)
            end	

	    	                			
            if KogMawMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1200) and (EnemiesAround(myHeroPos(), 1200) >= KogMawMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 1175) and KogMawMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSkillShot(_Q, target)
		         end
                end 

                if IsReady(_R) and ValidTarget(enemy, 900) and KogMawMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                      CastSkillShot(_R, target)
  
                end
			
		if IsReady(_W) and ValidTarget(enemy, 650) and KogMawMenu.KillSteal.W:Value() and GetHP(enemy) < getdmg("W",enemy) then
		                      CastSpell(_W)  
                end	
			
			if IsReady(_E) and ValidTarget(enemy, 325) and KogMawMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                        CastSkillShot(_E, enemy)
                end
                               
                if IsReady(_R) and ValidTarget(enemy, 1200) and KogMawMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                        CastTargetSpell(target, _R)
                end

      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if KogMawMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 1175) then
	        	CastSkillShot(_Q, closeminion)
                end

                if KogMawMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 650) then
	        	CastSpell(_W)
	        end

                if KogMawMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 1280) then
	        	CastSkillShot(_E, closeminion)
	        end

                if KogMawMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if KogMawMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if KogMawMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 1175) then
		      CastSkillShot(_Q, target)
          end
        end 
        if KogMawMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 650) then
	  	      CastSpell(_W)
          end
        end
        if KogMawMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 1280) then
		      CastSkillShot(_E, enemy)
	  end
        end
        if KogMawMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 1200) then
		     CastTargetSpell(target, _R)
	  end
        end
		
			
	--AUTO GHOST
	if KogMawMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if KogMawMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 1175, 0, 200, GoS.Black)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
              

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end
		


end) 


local function SkinChanger()
	if KogMawMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>KogMaw</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





