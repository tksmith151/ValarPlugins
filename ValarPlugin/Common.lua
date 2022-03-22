Common = {}

-----------------------
-- Primary Functions --
-----------------------
Common.FastUpdate = function ()
    Common.UpdateEffects()
    Common.UpdateIsInCombat()
    Common.UpdateMoralePercentage()
    Common.UpdateUsedSkills()
    --Common.UpdateTarget()
    --Common.UpdateTargetEffects()
end

Common.Load = function ()
    LocalPlayer.Instance = Turbine.Gameplay.LocalPlayer:GetInstance();
    LocalPlayer.Class = LocalPlayer.Instance:GetClass();
    LocalPlayer.ClassAttributesInstance = LocalPlayer.Instance:GetClassAttributes();
    LocalPlayer.EffectsInstance = LocalPlayer.Instance:GetEffects();
    LocalPlayer.Name = LocalPlayer.Instance:GetName();
    LocalPlayer.TrainedSkillsInstance = LocalPlayer.Instance:GetTrainedSkills();
    LocalPlayer.ClassAttributes = {};
    LocalPlayer.Skills = {};
    LocalPlayer.Target = {};
    LocalPlayer.TargetEffects = {};
    LocalPlayer.SkillLog = {Next = 0, Last = 1};

    SessionUI.DebugWindow = UI.DebugWindow();

    Utilities.AddCallback(Turbine.Chat, "Received", Common.WatchChat);
end

Common.TimedUpdate = function ()
    Common.UpdateTrainedSkills();
end


-------------------------
-- Component Functions --
-------------------------
Common.UpdateEffects = function ()
    LocalPlayer.EffectsCount = LocalPlayer.EffectsInstance:GetCount();
    LocalPlayer.Effects = {}
    local curable_debuff_found = false
    for Index = 1, LocalPlayer.EffectsCount, 1 do
        local EffectInstance = LocalPlayer.EffectsInstance:Get(Index);
        local EffectName = EffectInstance:GetName();
        LocalPlayer.Effects[EffectName] = EffectInstance;
        if EffectInstance:IsCurable() and EffectInstance:IsDebuff() then
            curable_debuff_found = true
        end
    end
    if curable_debuff_found then
        LocalPlayer.CanCure = true
    else
        LocalPlayer.CanCure = false
    end
    
end

Common.UpdateIsInCombat = function ()
    LocalPlayer.IsInCombat = LocalPlayer.Instance:IsInCombat();
end

Common.UpdateMoralePercentage = function ()
    LocalPlayer.MoralePercentage = LocalPlayer.Instance:GetMorale() / LocalPlayer.Instance:GetMaxMorale()
end

--[[
Common.UpdateTarget = function ()
    LocalPlayer.Target = LocalPlayer.Instance:GetTarget();
    --Turbine.Shell.WriteLine(Utilities.ToString(LocalPlayer.Target));
end

Common.UpdateTargetEffects = function ()
    if LocalPlayer.Target ~= nil then
        if LocalPlayer.Target.GetEffects ~= nil then
            local TargetEffectsInstance = LocalPlayer.Target:GetEffects();
            local TargetEffectsCount = TargetEffectsInstance:GetCount();
            Turbine.Shell.WriteLine(Utilities.ToString(TargetEffectsCount));
            local TargetEffects = {};
            for Index = 1, TargetEffectsCount, 1 do
                local EffectInstance = TargetEffectsInstance:Get(Index);
                local EffectName = EffectInstance:GetName();
                TargetEffects.Effects[EffectName] = EffectInstance;
                Turbine.Shell.WriteLine(Utilities.ToString(EffectName));
            end
            LocalPlayer.TargetEffects = TargetEffects;
            return
        end
    end
    LocalPlayer.TargetEffects = {};
end
]]

Common.UpdateTrainedSkills = function ()
    local TrainedSkillsCount = LocalPlayer.TrainedSkillsInstance:GetCount();
    -- TODO: Need to deactivate untrained skills
    for Index = 1, TrainedSkillsCount, 1 do
        local SkillInstance = LocalPlayer.TrainedSkillsInstance:GetItem(Index);
        local SkillInfoInstance = SkillInstance:GetSkillInfo();
        local SkillName = SkillInfoInstance:GetName();
        if LocalPlayer.Skills[SkillName]==nil then
            LocalPlayer.Skills[SkillName] = {}
            LocalPlayer.Skills[SkillName].Instance = SkillInstance
            LocalPlayer.Skills[SkillName].LastUsed = 0;
            LocalPlayer.Skills[SkillName].InUse = false;
            LocalPlayer.Skills[SkillName].OnCooldown = false;
        end
    end
end

Common.UpdateUsedSkills = function ()
    for SkillName, Skill in pairs(LocalPlayer.Skills) do
        local SkillInstance = LocalPlayer.Skills[SkillName].Instance
        if not LocalPlayer.Skills[SkillName].OnCooldown then
            if SkillInstance:GetResetTime() > -1 then
                LocalPlayer.Skills[SkillName].OnCooldown = true;
                LocalPlayer.Skills[SkillName].InUse = false;
            end
        elseif SkillInstance:GetResetTime() <= -1 then
            LocalPlayer.Skills[SkillName].OnCooldown = false;
        end
    end
end

Common.AddSkillLog = function(SkillName)
    LocalPlayer.SkillLog.Next = LocalPlayer.SkillLog.Next + 1
    LocalPlayer.SkillLog[LocalPlayer.SkillLog.Next] = SkillName
    if ((LocalPlayer.SkillLog.Next - LocalPlayer.SkillLog.Last) >= 10) then
        LocalPlayer.SkillLog[LocalPlayer.SkillLog.Last] = nil 
        LocalPlayer.SkillLog.Last = LocalPlayer.SkillLog.Last + 1
    end
    --Turbine.Shell.WriteLine(Utilities.ToString(LocalPlayer.SkillLog));
end

Common.WatchChat = function (sender, args)
	if (args.ChatType ~= Turbine.ChatType.PlayerCombat) then
		return;
	end
	-- grab line from combat log, strip it of color, trim it, and parse it according to the localized parsing function
	local ChatInfo = Utilities.Parse(string.gsub(string.gsub(args.Message,"<rgb=#......>(.*)</rgb>","%1"),"^%s*(.-)%s*$", "%1"));
    -- Burglar Fix
    if ChatInfo.SkillName then
        ChatInfo.SkillName = string.gsub(ChatInfo.SkillName,"^Stealthed ","");
        if LocalPlayer.Name == ChatInfo.InitiatorName then
            if LocalPlayer.Skills[ChatInfo.SkillName] then
                if not LocalPlayer.Skills[ChatInfo.SkillName].InUse then
                    --Turbine.Shell.WriteLine(Utilities.ToString(ChatInfo.SkillName .. "yyy"));
                    LocalPlayer.Skills[ChatInfo.SkillName].LastUsed = Turbine.Engine.GetGameTime();
                    LocalPlayer.Skills[ChatInfo.SkillName].InUse = true
                    Common.AddSkillLog(ChatInfo.SkillName)
                end 
            end
        end
    end
end