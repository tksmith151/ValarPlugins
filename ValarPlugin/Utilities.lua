Utilities = {}

Utilities.AddCallback = function (object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

Utilities.CanUseSkill = function (SkillName)
    if LocalPlayer.Skills[SkillName] then
        local SkillInstance = LocalPlayer.Skills[SkillName].Instance
        if SkillInstance:IsUsable() == true and SkillInstance:GetResetTime() <= -1 then
            return true
        end
    end
    return false
end

Utilities.GetLeastRecentlyUsedSkill = function(SkillNames)
    local EarliestSkillName = nil
    local EarliestTime = Turbine.Engine.GetGameTime();
    for Index, SkillName in pairs(SkillNames) do
        if LocalPlayer.Skills[SkillName] then
            local LastTime = LocalPlayer.Skills[SkillName].LastUsed
            if LastTime < EarliestTime and Utilities.CanUseSkill(SkillName) then
                EarliestSkillName = SkillName
                EarliestTime = LastTime
            end
        end
    end
    return EarliestSkillName
end

Utilities.GetPrioritySkill = function(SkillNames)
    for Index, SkillName in pairs(SkillNames) do
        if Utilities.CanUseSkill(SkillName) then
            return SkillName;
        end
    end
    return nil;
end

Utilities.PlayerHasEffect = function (EffectName)
    if LocalPlayer.Effects[EffectName] then
        return true
    end
    return false
end

Utilities.PlayerMissingEffect = function (EffectName)
    if LocalPlayer.Effects[EffectName] then
        return false
    end
    return true
end

Utilities.RemoveCallback = function (object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end

Utilities.TablePrint = function (tt, indent, done)
    done = done or {}
    indent = indent or 0
    if type(tt) == "table" then
        local sb = {}
        for key, value in pairs(tt) do
        table.insert(sb, string.rep(" ", indent)) -- indent it
        if type (value) == "table" and not done [value] then
            done [value] = true
            table.insert(sb, key .. " = {\n");
            table.insert(sb, Utilities.TablePrint(value, indent + 2, done))
            table.insert(sb, string.rep(" ", indent)) -- indent it
            table.insert(sb, "}\n");
        elseif "number" == type(key) then
            table.insert(sb, string.format("\"%s\"\n", tostring(value)))
        else
            table.insert(sb, string.format(
                "%s = \"%s\"\n", tostring(key), tostring(value)))
            end
        end
        return table.concat(sb)
    else
        return tt .. "\n"
    end
end
    
Utilities.ToString = function ( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return Utilities.TablePrint(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end

-- Code based on Combat Analysis Plugin, Thanks Gerard Cerchio, argonui, hdflux, Ravdor, Dromo and James Bebbington
Utilities.Parse = function(line)
    local Output = {}
    Output.EventType = "Unknown"
	-- 1) Damage line ---	
	local InitiatorName,AvoidAndCrit,SkillName,TargetNameAmountAndType = string.match(line,"^(.*) scored a (.*)hit(.*) on (.*)%.$");
	if (InitiatorName ~= nil) then	
        Output.EventType = "Damage Dealt"	
		Output.InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
		Output.SkillName = string.match(SkillName,"^ with (.*)$") or "Direct Damage";
		return Output;
	end
	
	-- 2) Heal line --
	local InitiatorName,Crit,SkillNameTargetNameAmountAndType = string.match(line,"^(.*) applied a (.-)heal (.*)%.$");
	if (InitiatorName ~= nil) then
		InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");		
		local SkillNameTargetNameAndAmount,Ending = string.match(SkillNameTargetNameAmountAndType,"^(.*)to (.*)$");
		local TargetName,SkillName,Amount;
		moralePower = (Ending == "Morale" and 1 or (Ending == "Power" and 2 or 3));
		-- heal was absorbed (unfortunately it appears this actually shows as a "hit" instead, so we never get into the first conditional)
		if (moralePower == 3) then
			TargetName = string.gsub(Ending,"^[Tt]he ","");
			Amount = 0;
			-- skill name will equal nil if this was a self heal
			SkillName = string.match(SkillNameTargetNameAndAmount,"^with (.*) $");
		-- heal applied
		else
			SkillName,TargetName,Amount = string.match(SkillNameTargetNameAndAmount,"^(.*)to (.*) restoring ([%d,]*) points? $");
			TargetName = string.gsub(TargetName,"^[Tt]he ","");
			Amount = string.gsub(Amount,",","")+0;
			-- skill name will equal nil if this was a self heal
			SkillName = string.match(SkillName,"^with (.*) $");
		end
		-- rearrange if this was a self heal
		if (SkillName == nil) then
			SkillName = InitiatorName;
			InitiatorName = TargetName;
		end
        Output.EventType = "Heal"
        Output.InitiatorName = InitiatorName
        Output.SkillName = SkillName
		return Output;
	end
	
	-- 3) Buff line --	
	local InitiatorName,SkillName,TargetName = string.match(line,"^(.*) applied a benefit with (.*) on (.*)%.$");
	if (InitiatorName ~= nil) then
        Output.EventType = "Buff"
		Output.InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
        Output.SkillName = SkillName
		--Output.TargetName = string.gsub(TargetName,"^[Tt]he ","");
		return Output;
	end
	
	-- 4) Avoid line --
	local InitiatorNameMiss,SkillName,TargetNameAvoidType = string.match(line,"^(.*) to use (.*) on (.*)%.$");
	if (InitiatorNameMiss ~= nil) then
		InitiatorName = string.match(InitiatorNameMiss,"^(.*) tried$");
		local TargetName, AvoidType;
		-- standard avoid
		if (InitiatorName ~= nil) then
			InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
			TargetName,AvoidType = string.match(TargetNameAvoidType,"^(.*) but (.*) the attempt$");
			TargetName = string.gsub(TargetName,"^[Tt]he ","");
			AvoidType = 
				string.match(AvoidType," blocked$") and 5 or
				string.match(AvoidType," parried$") and 6 or
				string.match(AvoidType," evaded$") and 7 or
				string.match(AvoidType," resisted$") and 4 or
				string.match(AvoidType," was immune to$") and 3 or 1;	
		-- miss or deflect
		else
			InitiatorName = string.match(InitiatorNameMiss,"^(.*) missed trying$");
            if (InitiatorName == nil) then
                InitiatorName = string.match(InitiatorNameMiss,"^(.*) was deflected trying$");
                AvoidType = 11;
            else
                AvoidType = 2;
            end      
			InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
			TargetName = string.gsub(TargetNameAvoidType,"^[Tt]he ","");
		end		
		-- Sanity check: must have avoided in some manner
		if (AvoidType == 1) then return nil end		
		-- Update
        Output.EventType = "Avoid"
        Output.InitiatorName = InitiatorName
        Output.SkillName = SkillName
		return Output;
	end
	
	-- 5) Reflect line --
    --[[	
	local InitiatorName,Amount,dmgType,targetName = string.match(line,"^(.*) reflected ([%d,]*) (.*) to the Morale of (.*)%.$");
	if (InitiatorName ~= nil) then
		local SkillName = "Reflect";
		InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
		targetName = string.gsub(targetName,"^[Tt]he ","");
		Amount = string.gsub(Amount,",","")+0;
		local dmgType = string.match(dmgType,"^(.*)damage$");
		-- a damage reflect
		if (dmgType ~= nil) then
			dmgType = 
				dmgType == "Common " and 1 or
				dmgType == "Fire " and 2 or
				dmgType == "Lightning " and 3 or
				dmgType == "Frost " and 4 or
				dmgType == "Acid " and 5 or
				dmgType == "Shadow " and 6 or
				dmgType == "Light " and 7 or
				dmgType == "Beleriand " and 8 or
				dmgType == "Westernesse " and 9 or
				dmgType == "Ancient Dwarf-make " and 10 or
				dmgType == "Orc-craft " and 11 or
				dmgType == "Fell-wrought " and 12 or 13;
						
			-- Update
			return event_type.DMG_DEALT,InitiatorName,targetName,SkillName,Amount,1,1,dmgType;
		-- a heal reflect
		else
			-- Update
			return event_type.HEAL,InitiatorName,targetName,SkillName,Amount,1;
		end
	end]]
	
	-- 6) Temporary Morale bubble line (as of 4.1.0)
    --[[
    local Amount = string.match(line,"^You have lost ([%d,]*) points of temporary Morale!$");
	if (Amount ~= nil) then
		Amount = string.gsub(Amount,",","")+0;
		
		-- the only information we can extract directly is the target and amount
		return event_type.TEMP_MORALE_LOST,nil,player.name,nil,Amount;
	end]]
	
	-- 7) Combat State Break notice (as of 4.1.0)	
	-- 7a) Root broken
    --[[
	local targetName = string.match(line,"^.* ha[sv]e? released (.*) from being immobilized!$");
	if (targetName ~= nil) then
		targetName = string.gsub(targetName,"^[Tt]he ","");
		
		-- the only information we can extract directly is the target name
		return event_type.CC_BROKEN,nil,targetName,nil;
	end]]
	
	-- 7b) Daze broken
    --[[
	local targetName = string.match(line,"^.* ha[sv]e? freed (.*) from a daze!$");
	if (targetName ~= nil) then
		targetName = string.gsub(targetName,"^[Tt]he ","");
		-- the only information we can extract directly is the target name
		return event_type.CC_BROKEN,nil,targetName,nil;
	end]]
	
	-- 7c) Fear broken (TODO: Check)
    --[[
	local targetName = string.match(line,"^.* ha[sv]e? freed (.*) from a fear!$");
	if (targetName ~= nil) then
		targetName = string.gsub(targetName,"^[Tt]he ","");
		
		-- the only information we can extract directly is the target name
		return event_type.CC_BROKEN,nil,targetName,nil;
	end]]
	
	-- 8) Interrupt line --	
	local TargetName, InitiatorName = string.match(line,"^(.*) was interrupted by (.*)!$");
	if (TargetName ~= nil) then
        Output.EventType = "Interupt"
        Output.InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
        Output.TargetName = string.gsub(TargetName,"^[Tt]he ","");
		return Output;
	end
	
	-- 9) Dispell line (corruption removal) --
    --[[
	local corruption, targetName = string.match(line,"You have dispelled (.*) from (.*)%.$");
	if (corruption ~= nil) then
		InitiatorName = player.name;
		targetName = string.gsub(targetName,"^[Tt]he ","");
		-- NB: Currently ignore corruption name
		-- Update
		return event_type.CORRUPTION,InitiatorName,targetName;
	end]]
	
	-- 10) Defeat lines ---
    --[[
	-- 10a) Defeat line 1 (mob or played was killed)
	local InitiatorName = string.match(line,"^.* defeated (.*)%.$");
	
	if (InitiatorName ~= nil) then
		InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
		
		-- Update
		return event_type.DEATH,InitiatorName;
	end
	
	-- 10b) Defeat line 2 (mob died)
	local InitiatorName = string.match(line,"^(.*) died%.$");

	if (InitiatorName ~= nil) then
		InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
		
		-- Update
		return event_type.DEATH,InitiatorName;
	end
	
	-- 10c) Defeat line 3 (a player was killed or died)
	local InitiatorName = string.match(line,"^(.*) has been defeated%.$");

	if (InitiatorName ~= nil) then
		InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
		
		-- Update
		return event_type.DEATH,InitiatorName;
	end
	
	-- 10d) Defeat line 4 (you were killed)
	local match = string.match(line,"^.* incapacitated you%.$");

	if (match ~= nil) then
		InitiatorName = player.name;
		
		-- Update
		return event_type.DEATH,InitiatorName;
	end
	
	-- 10e) Defeat line 5 (you died)
	local match = string.match(line,"^You have been incapacitated by misadventure%.$");

	if (match ~= nil) then
		InitiatorName = player.name;
		
		-- Update
		return event_type.DEATH,InitiatorName;
	end
	
	-- 10f) Defeat line 6 (you killed a mob)
	local InitiatorName = string.match(line,"^Your mighty blow topples (.*)%.$");
	
	if (InitiatorName ~= nil) then
		InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
		
		-- Update
		return event_type.DEATH,InitiatorName;
	end]]
	
	-- 11) Revive lines --
    --[[
	-- 11a) Revive line 1 (player revived)
	local InitiatorName = string.match(line,"^(.*) has been revived%.$");
	if (InitiatorName ~= nil) then
	  InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
	  return event_type.REVIVE,InitiatorName;
	end
	
	-- 11b) Revive line 2 (player succumbed)
	local InitiatorName = string.match(line,"^(.*) has succumbed to .* wounds%.$");
	if (InitiatorName ~= nil) then
	  InitiatorName = string.gsub(InitiatorName,"^[Tt]he ","");
	  return event_type.REVIVE,InitiatorName;
	end
	
	-- 11c) Revive line 3 (you were revived)
	local match = string.match(line,"^You have been revived%.$");
	if (match ~= nil) then
	  InitiatorName = player.name;
	  return event_type.REVIVE,InitiatorName;
	end
	
	-- 11d) Revive line 4 (you succumbed)
	local match = string.match(line,"^You succumb to your wounds%.$");
	if (match ~= nil) then
	  InitiatorName = player.name;
	  return event_type.REVIVE,InitiatorName;
	end]]
	
	return Output
end
