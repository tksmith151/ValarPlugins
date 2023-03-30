-----------------
-- Begin Model --
-----------------

Model = {}

----------------
-- Begin Load --
----------------

Model.Load = {}

Model.Load.State = function ()
    State = {}
    Model.Load.Player()
    Model.Load.PlayerClass()
end

-- Player --

Model.Load.Player = function ()
    State.Player = {}
    -- Instance --
    State.Player.Instance = Turbine.Gameplay.LocalPlayer:GetInstance();
    -- Name --
    State.Player.Name = State.Player.Instance:GetName();
    -- Combat --
    State.Player.IsInCombat = State.Player.Instance:IsInCombat();
    -- Morale --
    State.Player.Morale = {}
    State.Player.Morale.Current = State.Player.Instance:GetMorale()
    State.Player.Morale.Max = State.Player.Instance:GetMaxMorale()
    State.Player.Morale.Percentage = State.Player.Morale.Current / State.Player.Morale.Max
    -- Class --
    State.Player.Class = {}
    State.Player.Class.Type = State.Player.Instance:GetClass();
    State.Player.Class.Attributes = {};
    State.Player.Class.Attributes.Instance = State.Player.Instance:GetClassAttributes();
    -- Effects --
    State.Player.Effects = {}
    State.Player.Effects.Instance = State.Player.Instance:GetEffects();
    State.Player.Effects.Count = State.Player.Effects.Instance:GetCount();
    State.Player.Effects.Curable = 0
    State.Player.Effects.HasCurable = false
    State.Player.Effects.Table = {} -- Populated by Model.Update.Player.Effects
    -- Skills --
    State.Player.Skills = {};
    State.Player.Skills.Instance = State.Player.Instance:GetTrainedSkills();
    State.Player.Skills.Table = {}; -- Populated by Model.Update.Player.TrainedSkills
    State.Player.Skills.Log = {Next = 0, Last = 1};
    -- Target --
    State.Player.Target = {};
    State.Player.TargetEffects = {};
end

-- PlayerClass --

Model.Load.PlayerClass = function ()
    if  State.Player.Class.Type == Turbine.Gameplay.Class.Beorning    then  PlayerClasses.Beorning.Load()    end
    if  State.Player.Class.Type == Turbine.Gameplay.Class.Burglar     then  PlayerClasses.Burglar.Load()     end
    if  State.Player.Class.Type == Turbine.Gameplay.Class.Captain     then  PlayerClasses.Captain.Load()     end
    if  State.Player.Class.Type == Turbine.Gameplay.Class.Champion    then  PlayerClasses.Champion.Load()    end
    if  State.Player.Class.Type == Turbine.Gameplay.Class.Guardian    then  PlayerClasses.Guardian.Load()    end
    if  State.Player.Class.Type == Turbine.Gameplay.Class.Hunter      then  PlayerClasses.Hunter.Load()      end
    if  State.Player.Class.Type == Turbine.Gameplay.Class.LoreMaster  then  PlayerClasses.LoreMaster.Load()  end
    if  State.Player.Class.Type == Turbine.Gameplay.Class.Minstrel    then  PlayerClasses.Minstrel.Load()    end
    if  State.Player.Class.Type == Turbine.Gameplay.Class.RuneKeeper  then  PlayerClasses.RuneKeeper.Load()  end
    if  State.Player.Class.Type == Turbine.Gameplay.Class.Warden      then  PlayerClasses.Warden.Load()      end
end

--------------
-- End Load --
--------------

------------------
-- Begin Update --
------------------

Model.Update = {}

Model.Update.Fast = function ()
    Model.Update.Player.Fast()
    Model.Update.PlayerClass.Fast()
end

Model.Update.Timed = function ()
    Model.Update.Player.Timed();
    Model.Update.PlayerClass.Fast();
end

-- Player --

Model.Update.Player = {}

Model.Update.Player.Fast = function ()
    Model.Update.Player.Effects()
    Model.Update.Player.IsInCombat()
    Model.Update.Player.Morale()
    Model.Update.Player.UsedSkills()
end

Model.Update.Player.Timed = function ()
    Model.Update.Player.TrainedSkills();
end

Model.Update.Player.Effects = function ()
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

Model.Update.Player.IsInCombat = function ()
    State.Player.IsInCombat = State.Player.Instance:IsInCombat();
end

Model.Update.Player.Morale = function ()
    State.Player.Morale.Current = State.Player.Instance:GetMorale()
    State.Player.Morale.Max = State.Player.Instance:GetMaxMorale()
    State.Player.Morale.Percentage = State.Player.Morale.Current / State.Player.Morale.Max
end

Model.Update.Player.TrainedSkills = function ()
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

Model.Update.Player.UsedSkills = function ()
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

-- PlayerClass --

Model.Update.PlayerClass = {}
Model.Update.PlayerClass.Fast = function () end -- This function is set by each PlayerClass Load() function
Model.Update.PlayerClass.Timed = function () end -- This function is set by each PlayerClass Load() function

----------------
-- End Update --
----------------

---------------
-- End Model --
---------------
