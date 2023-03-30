Model = {}

----------------
-- Initialize --
----------------

-- Initialize Root

LoadState = function ()
    State = {}
    DataMain.Initialize.Player()
end

-- Initialize Components

DataMain.Initialize.Player = function ()
    State.Player = {}
    --
    State.Player.Instance = Turbine.Gameplay.LocalPlayer:GetInstance();
    --
    State.Player.Name = State.Player.Instance:GetName();
    State.Player.IsInCombat = State.Player.Instance:IsInCombat();
    State.Player.MoralePercentage = 100.0
    --
    State.Player.Class = {}
    State.Player.Class.Type = State.Player.Instance:GetClass();
    State.Player.Class.Attributes = {};
    State.Player.Class.Attributes.Instance = State.Player.Instance:GetClassAttributes();
    --
    State.Player.Effects = {}
    State.Player.Effects.Instance = State.Player.Instance:GetEffects();
    State.Player.Effects.Count = State.Player.EffectsInstance:GetCount();
    State.Player.Effects.Curable = 0
    State.Player.Effects.Table = {}
    --
    State.Player.Skills = {};
    State.Player.Skills.Instance = State.Player.Instance:GetTrainedSkills();
    State.Player.Skills.Table = {};
    State.Player.Skills.Log = {Next = 0, Last = 1};
    --
    State.Player.Target = {};
    State.Player.TargetEffects = {};
end

------------
-- Update --
------------

DataMain.Update = {}

-- Update Roots

DataMain.Update.Fast = function ()
    DataMain.Update.Player.Data()
end

DataMain.Update.Timed = function ()
    DataMain.Update.Player.TrainedSkills();
end

-- Update Components

DataMain.Update.Player = {}

DataMain.Update.Player.Data = function ()
    DataMain.Update.Player.Effects()
    DataMain.Update.Player.IsInCombat()
    DataMain.Update.Player.MoralePercentage()
    DataMain.Update.Player.UsedSkills()
end

DataMain.Update.Player.Effects = function ()
    State.Player.Effects.Count = State.Player.Effects.Instance:GetCount();
    State.Player.Effects.Table = {}
    local curable_effects = 0
    for Index = 1, State.Player.Effects.Count, 1 do
        local EffectInstance = State.Player.Effects.Instance:Get(Index);
        local EffectName = EffectInstance:GetName();
        State.Player.Effects.Table[EffectName] = EffectInstance;
        if EffectInstance:IsCurable() and EffectInstance:IsDebuff() then
            curable_effects = curable_effects + 1
        end
    end
    State.Player.Effects.Curable = curable_effects
end

DataMain.Update.Player.IsInCombat = function ()
    State.Player.IsInCombat = State.Player.Instance:IsInCombat();
end

DataMain.Update.Player.MoralePercentage = function ()
    State.Player.MoralePercentage = State.Player.Instance:GetMorale() / State.Player.Instance:GetMaxMorale()
end

--[[
DataMain.UpdateTarget = function ()
    Data.Player.Target = Data.Player.Instance:GetTarget();
    --Turbine.Shell.WriteLine(Utilities.ToString(Data.Player.Target));
end

DataMain.UpdateTargetEffects = function ()
    if Data.Player.Target ~= nil then
        if Data.Player.Target.GetEffects ~= nil then
            local TargetEffectsInstance = Data.Player.Target:GetEffects();
            local TargetEffectsCount = TargetEffectsInstance:GetCount();
            Turbine.Shell.WriteLine(Utilities.ToString(TargetEffectsCount));
            local TargetEffects = {};
            for Index = 1, TargetEffectsCount, 1 do
                local EffectInstance = TargetEffectsInstance:Get(Index);
                local EffectName = EffectInstance:GetName();
                TargetEffects.Effects[EffectName] = EffectInstance;
                Turbine.Shell.WriteLine(Utilities.ToString(EffectName));
            end
            Data.Player.TargetEffects = TargetEffects;
            return
        end
    end
    Data.Player.TargetEffects = {};
end
]]

DataMain.Update.Player.TrainedSkills = function ()
    local TrainedSkillsCount = State.Player.Skills.Instance:GetCount();
    SkillNames = {}
    -- Populate New Skills
    for Index = 1, TrainedSkillsCount, 1 do
        local SkillInstance = State.Player.Skills.Instance:GetItem(Index);
        local SkillInfoInstance = SkillInstance:GetSkillInfo();
        local SkillName = SkillInfoInstance:GetName();
        SkillNames[SkillName] = true
        if State.Player.Skills.Table[SkillName]==nil then
            State.Player.Skills.Table[SkillName] = {}
            State.Player.Skills.Table[SkillName].Instance = SkillInstance
            State.Player.Skills.Table[SkillName].LastUsed = 0;
            State.Player.Skills.Table[SkillName].InUse = false;
            State.Player.Skills.Table[SkillName].OnCooldown = false;
        end
    end
    -- Remove Unusable Skills
    for SkillName, Skill in pairs(State.Player.Skills) do
        if SkillNames[SkillName] == nil then
            State.Player.Skills[SkillName] = nil
        end
    end
end

DataMain.Update.Player.UsedSkills = function ()
    for SkillName, Skill in pairs(State.Player.Skills) do
        local SkillInstance = State.Player.Skills[SkillName].Instance
        if not State.Player.Skills[SkillName].OnCooldown then
            if SkillInstance:GetResetTime() > -1 then
                State.Player.Skills[SkillName].OnCooldown = true;
                State.Player.Skills[SkillName].InUse = false;
            end
        elseif SkillInstance:GetResetTime() <= -1 then
            State.Player.Skills[SkillName].OnCooldown = false;
        end
    end
end

-----------
-- Event --
-----------

DataMain.AddSkillLog = function(SkillName)
    local LogLength = 10
    -- Add skill to log
    State.Player.Skills.Log.Next = State.Player.Skills.Log.Next + 1
    State.Player.Skills.Log[State.Player.Skills.Log.Next] = SkillName

    -- Clean up old log entries
    if ((State.Player.Skills.Log.Next - State.Player.Skills.Log.Last) >= LogLength) then
        State.Player.Skills.Log[State.Player.Skills.Log.Last] = nil 
        State.Player.Skills.Log.Last = State.Player.Skills.Log.Last + 1
    end
end

DataMain.WatchChat = function (sender, args)
    -- filter for only combat logs
	if (args.ChatType ~= Turbine.ChatType.PlayerCombat) then
		return;
	end

	-- grab line from combat log, strip it of color, trim it, and parse it according to the localized parsing function
	local ChatInfo = Utilities.Parse(string.gsub(string.gsub(args.Message,"<rgb=#......>(.*)</rgb>","%1"),"^%s*(.-)%s*$", "%1"));

    -- update skill information based on logs
    if ChatInfo ~= nil and ChatInfo.SkillName then
        ChatInfo.SkillName = string.gsub(ChatInfo.SkillName,"^Stealthed ",""); -- Burglar Fix
        ChatInfo.SkillName = string.gsub(ChatInfo.SkillName,"Expose %(Bear%)","Expose %(Man%)"); -- Beorning FIx
        if State.Player.Name == ChatInfo.InitiatorName then
            if State.Player.Skills[ChatInfo.SkillName] then
                if not State.Player.Skills[ChatInfo.SkillName].InUse then
                    --Turbine.Shell.WriteLine(Utilities.ToString(ChatInfo.SkillName .. "yyy"));
                    State.Player.Skills[ChatInfo.SkillName].LastUsed = Turbine.Engine.GetGameTime();
                    State.Player.Skills[ChatInfo.SkillName].InUse = true
                    DataMain.AddSkillLog(ChatInfo.SkillName)
                end
            end
        end
    end
end