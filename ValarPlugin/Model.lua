-----------
-- Model --
-----------

Model = {}

Model.Load =  function ()
    State = {}
    Model.Player.Load()
    Model.Chat.Load()
end

Model.Update = {}

Model.Update.Fast = function ()
    Model.Player.Update.Fast()
end

Model.Update.Timed = function ()
    Model.Player.Update.Timed();
end

----------
-- Chat --
----------

Model.Chat = {}

Model.Chat.Load = function ()
    Utilities.AddCallback(Turbine.Chat, "Received", Utilities.WatchChat);
end

------------
-- Player --
------------

Model.Player = {}

Model.Player.Load = function ()
    State.Player = {}
    State.Player.Instance = Turbine.Gameplay.LocalPlayer:GetInstance();
    State.Player.Name = State.Player.Instance:GetName();
    State.Player.IsInCombat = State.Player.Instance:IsInCombat();
    -- Target --
    -- State.Player.Target = {};
    -- State.Player.TargetEffects = {};
    -- Sub Tables --
    Model.Player.Class.Load()
    Model.Player.Effects.Load()
    Model.Player.Morale.Load()
    Model.Player.Skills.Load()
end

Model.Player.Update = {}

Model.Player.Update.Fast = function ()
    State.Player.IsInCombat = State.Player.Instance:IsInCombat();
    -- Sub Tables --
    Model.Player.Class.Update.Fast()
    Model.Player.Effects.Update.Fast()
    Model.Player.Morale.Update.Fast()
    Model.Player.Skills.Update.Fast()
end

Model.Player.Update.Timed = function ()
    Model.Player.Class.Update.Timed()
    Model.Player.Skills.Update.Timed();
end

------------------
-- Player Class --
------------------

Model.Player.Class = {}

Model.Player.Class.Load = function ()
    State.Player.Class = {}
    State.Player.Class.Type = State.Player.Instance:GetClass();
    State.Player.Class.Attributes = {};
    State.Player.Class.Attributes.Instance = State.Player.Instance:GetClassAttributes();
    if State.Player.Class.Type == Turbine.Gameplay.Class.Beorning   then PlayerClasses.Beorning.Load()   end
    if State.Player.Class.Type == Turbine.Gameplay.Class.Burglar    then PlayerClasses.Burglar.Load()    end
    if State.Player.Class.Type == Turbine.Gameplay.Class.Captain    then PlayerClasses.Captain.Load()    end
    if State.Player.Class.Type == Turbine.Gameplay.Class.Champion   then PlayerClasses.Champion.Load()   end
    if State.Player.Class.Type == Turbine.Gameplay.Class.Guardian   then PlayerClasses.Guardian.Load()   end
    if State.Player.Class.Type == Turbine.Gameplay.Class.Hunter     then PlayerClasses.Hunter.Load()     end
    if State.Player.Class.Type == Turbine.Gameplay.Class.LoreMaster then PlayerClasses.LoreMaster.Load() end
    if State.Player.Class.Type == Turbine.Gameplay.Class.Minstrel   then PlayerClasses.Minstrel.Load()   end
    if State.Player.Class.Type == Turbine.Gameplay.Class.RuneKeeper then PlayerClasses.RuneKeeper.Load() end
    if State.Player.Class.Type == Turbine.Gameplay.Class.Warden     then PlayerClasses.Warden.Load()     end
end

Model.Player.Class.Update = {}
Model.Player.Class.Update.Fast = function () end -- This function is overwritten by each PlayerClass Load() function
Model.Player.Class.Update.Timed = function () end -- This function is overwritten by each PlayerClass Load() function

--------------------
-- Player Effects --
--------------------

Model.Player.Effects = {}

Model.Player.Effects.Load = function ()
    State.Player.Effects = {}
    State.Player.Effects.Instance = State.Player.Instance:GetEffects();
    State.Player.Effects.Count = State.Player.Effects.Instance:GetCount();
    State.Player.Effects.Curable = 0
    State.Player.Effects.HasCurable = false
    State.Player.Effects.Table = {}
end

Model.Player.Effects.Update = {}

Model.Player.Effects.Update.Fast = function ()
    State.Player.Effects.Count = State.Player.Effects.Instance:GetCount();
    State.Player.Effects.Table = {}
    local curable_effects = 0
    for Index = 1, State.Player.Effects.Count, 1 do
        local EffectInstance = State.Player.Effects.Instance:Get(Index);
        local EffectName = EffectInstance:GetName();
        State.Player.Effects.Table[EffectName] = {}
        State.Player.Effects.Table[EffectName].Instance = EffectInstance;
        if EffectInstance:IsCurable() and EffectInstance:IsDebuff() then
            curable_effects = curable_effects + 1
        end
    end
    State.Player.Effects.Curable = curable_effects
    if State.Player.Effects.Curable > 0 then
        State.Player.Effects.HasCurable = true
    else
        State.Player.Effects.HasCurable = false
    end
end

-------------------
-- Player Morale --
-------------------

Model.Player.Morale = {}

Model.Player.Morale.Load = function ()
    State.Player.Morale = {}
    State.Player.Morale.Current = State.Player.Instance:GetMorale()
    State.Player.Morale.Max = State.Player.Instance:GetMaxMorale()
    State.Player.Morale.Percentage = 100.0
end

Model.Player.Morale.Update = {}

Model.Player.Morale.Update.Fast = function ()
    State.Player.Morale.Current = State.Player.Instance:GetMorale()
    State.Player.Morale.Max = State.Player.Instance:GetMaxMorale()
    State.Player.Morale.Percentage = State.Player.Morale.Current / State.Player.Morale.Max
end

-------------------
-- Player Skills --
-------------------

Model.Player.Skills = {}

Model.Player.Skills.Load = function ()
    State.Player.Skills = {};
    State.Player.Skills.Instance = State.Player.Instance:GetTrainedSkills();
    State.Player.Skills.Table = {}; -- Populated by Model.Player.Skills.Update
    State.Player.Skills.Log = {Next = 0, Last = 1};
end

Model.Player.Skills.Update = {}

Model.Player.Skills.Update.Fast = function ()
    for SkillName, Skill in pairs(State.Player.Skills.Table) do
        local SkillInstance = State.Player.Skills.Table[SkillName].Instance
        if not State.Player.Skills.Table[SkillName].OnCooldown then
            if SkillInstance:GetResetTime() > -1 then
                State.Player.Skills.Table[SkillName].OnCooldown = true;
                State.Player.Skills.Table[SkillName].InUse = false;
            end
        elseif SkillInstance:GetResetTime() <= -1 then
            State.Player.Skills.Table[SkillName].OnCooldown = false;
        end
    end
end

Model.Player.Skills.Update.Timed = function ()
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
    for SkillName, Skill in pairs(State.Player.Skills.Table) do
        if SkillNames[SkillName] == nil then
            State.Player.Skills.Table[SkillName] = nil
        end
    end
end
