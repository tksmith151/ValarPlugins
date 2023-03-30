Warden = {}

-----------------------
-- Primary Functions --
-----------------------
Warden.FastUpdate = function ()
    Warden.UpdateStance();
    Warden.UpdateMarching();
    Warden.UpdateLastGambit();
    Warden.UpdateCurrentGambit();
    Warden.UpdateQuickslots();
end

Warden.Load = function ()
    LocalPlayer.TrainedGamibtsInstance = LocalPlayer.ClassAttributesInstance:GetTrainedGambits();
    LocalPlayer.Gambits = {}
    Model.Player.Class.Update.Fast = Warden.FastUpdate;
    Model.Player.Class.Update.Timed = Warden.TimedUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(909,794,6);
end

Warden.TimedUpdate = function ()
    Warden.UpdateTrainedGambits();
    Warden.UpdateTraitLine();
end

----------------
-- Class Data --
----------------
Warden.Gambits = {
    ["Adroit Manoeuvre"] = {1,3,2,1},
    ["Boar's Rush"] = {1,3,1,3},
    ["Brink of Victory"] = {3,2,3},
    ["Celebration of Skill"] = {2,1,2,1},
    ["Combination Strike"] = {1,3,1},
    ["Conviction"] = {2,3,2,3,2},
    ["Dance of War"] = {2,3,2,3},
    ["Defensive Strike"] = {2,2},
    ["Deft Strike"] = {1,1},
    ["Desolation"] = {3,2,3,2,3},
    ["Exultation of Battle"] = {3,1,2,3,2},
    ["Fierce Resolve"] = {3,1,2},
    ["Goad"] = {3,3},
    ["Impressive Flourish"] = {2,3},
    ["Javelin of Virtue"] = {3,1,3,1},
    ["Maddening Strike"] = {2,3,2},
    ["Mighty Blow"] = {1,2,3,1},
    ["Offensive Strike"] = {1,3},
    ["Onslaught"] = {1,2,1},
    ["Persevere"] = {2,1},
    ["Piercing Strike"] = {3,1,3},
    ["Piercing Toss"] = {3,1,3},
    ["Power Attack"] = {1,2,3},
    ["Precise Blow"] = {3,1},
    ["Precise Throw"] = {3,1},
    ["Ranged Adroit Manoeuvre"] = {1,3,2,1},
    ["Ranged Boar's Rush"] = {1,3,1,3},
    ["Ranged Boot"] = {1,2},
    ["Ranged Celebration of Skill"] = {2,1,2,1},
    ["Ranged Combination Strike"] = {1,3,1},
    ["Ranged Deft Strike"] = {1,1},
    ["Ranged Exultation of Battle"] = {3,1,2,3,2},
    ["Ranged Fierce Resolve"] = {3,1,2},
    ["Ranged Mighty Blow"] = {1,2,3,1},
    ["Ranged Offensive Strike"] = {1,3},
    ["Ranged Onslaught"] = {1,2,1},
    ["Ranged Persevere"] = {2,1},
    ["Ranged Power Attack"] = {1,2,3},
    ["Ranged Restoration"] = {2,1,2,1,2},
    ["Ranged Reversal"] = {1,3,2},
    ["Ranged Safeguard"] = {2,1,2},
    ["Ranged The Dark Before Dawn"] = {1,2,1,3,1},
    ["Ranged Unerring Strike"] = {1,2,3,1,2},
    ["Ranged Wall of Steel"] = {1,2,1,2},
    ["Ranged Warden's Triumph"] = {1,3,2,1,3},
    ["Resolution"] = {3,1,2,3},
    ["Resounding Challenge"] = {3,2,3,1},
    ["Restoration"] = {2,1,2,1,2},
    ["Reversal"] = {1,3,2},
    ["Safeguard"] = {2,1,2},
    ["Shield Mastery"] = {2,1,3,2},
    ["Shield Tactics"] = {2,3,1,2},
    ["Spear of Virtue"] = {3,1,3,1},
    ["Surety of Death"] = {3,2,3,2},
    ["The Boot"] = {1,2},
    ["The Dark Before Dawn"] = {1,2,1,3,1},
    ["Unerring Strike"] = {1,2,3,1,2},
    ["Wall of Steel"] = {1,2,1,2},
    ["War-cry"] = {3,2},
    ["Warden's Triumph"] = {1,3,2,1,3},
}

Warden.Shortcuts = {
    -- [""] = "",
    ["Ambush"] = "0x7000EEC4",
    ["Assailment - Stance"] = "0x7003639C",
    ["Battle Preparation"] = "0x7002BEEC",
    ["Careful Step"] = "0x70014860",
    ["Critical Strike"] = "0x700101D8",
    ["Diminished Target"] = "0x70036551",
    ["First Aid"] = "0x7003A654",
    ["Fist"] = "0x7000EECF",
    ["Fist and Fist"] = "0x7002850C",
    ["Fist and Shield"] = "0x7001509C",
    ["Fist and Spear"] = "0x7001509A",
    ["Forced March"] = "0x700105CC",
    ["Gambit Default"] = "0x70015F56",
    ["Hampering Javelin"] = "0x70014833",
    ["Improved Hampering Javelin"] = "0x70014833",
    ["In The Fray - Stance"] = "0x7003639B",
    ["Marked Target"] = "0x70036550",
    ["Quick Recovery"] = "0x70016A09",
    ["Recovery"] = "0x70016A0A",
    ["Shield"] = "0x7000ED0E",
    ["Shield-slam"] = "0x7004E1FF",
    ["Shield and Fist"] = "0x7001509B",
    ["Shield and Shield"] = "0x7002850B",
    ["Shield and Spear"] = "0x7001509D",
    ["Shield Piercer"] = "0x70014784",
    ["Spear"] = "0x7000E867",
    ["Spear and Fist"] = "0x70015098",
    ["Spear and Shield"] = "0x70015099",
    ["Spear and Spear"] = "0x7002850A",
};

Warden.Quickslots = {
    ["Area"] = 3,
    ["Buff"] = 4,
    ["Corruption"] = 1,
    ["Deed"] = 5,
    ["Interupt"] = 2,
    ["Range"] = 6,
};

-------------------------
-- Component Functions --
-------------------------
Warden.UpdateCurrentGambit = function ()
    LocalPlayer.CurrentGambitCount = LocalPlayer.ClassAttributesInstance:GetGambitCount();
    LocalPlayer.CurrentGambit = {}
    for Index = 1, LocalPlayer.CurrentGambitCount, 1 do
        local Value = LocalPlayer.ClassAttributesInstance:GetGambit(Index);
        if Value == 4 then
            LocalPlayer.CurrentGambit[Index] = 1
        else
            LocalPlayer.CurrentGambit[Index] = Value
        end
    end
end

Warden.UpdateLastGambit = function ()
    if LocalPlayer.Skills["Gambit Default"].Instance:GetResetTime() > -1 then
        if LocalPlayer.LastGambitStored ~= true then
            -- Set Last Used Time For a Gambit
            local GambitName = LocalPlayer.Gambits[Warden.GambitToSequence(LocalPlayer.CurrentGambit)];
            if GambitName~=nil then
                LocalPlayer.Gambits[GambitName].LastUsed = Turbine.Engine.GetGameTime();
            end
        end
        LocalPlayer.LastGambitStored = true
    else
        LocalPlayer.LastGambitStored = false
    end
end

Warden.UpdateMarching = function ()
    if LocalPlayer.Skills["Forced March"] and LocalPlayer.Skills["Forced March"].InUse then
        LocalPlayer.Marching = true;
        return
    end
    LocalPlayer.Marching = false;
end

Warden.UpdateStance = function ()
    LocalPlayer.Stance = LocalPlayer.ClassAttributesInstance:GetStance();
end

Warden.UpdateTrainedGambits = function ()
    local TrainedGambitsCount = LocalPlayer.TrainedGamibtsInstance:GetCount();
    -- TODO: Need to deactivate untrained gambits
    for Index = 1, TrainedGambitsCount, 1 do
        local GambitInstance = LocalPlayer.TrainedGamibtsInstance:GetItem(Index);
        local GambitInfoInstance = GambitInstance:GetSkillInfo();
        local GambitName = GambitInfoInstance:GetName();
        if LocalPlayer.Gambits[GambitName]==nil then
            LocalPlayer.Gambits[GambitName] = {}
            LocalPlayer.Gambits[GambitName].Instance = GambitInstance
            LocalPlayer.Gambits[GambitName].GambitSequence = Warden.Gambits[GambitName]
            LocalPlayer.Gambits[GambitName].LastUsed = 0;
            if LocalPlayer.Gambits[GambitName].GambitSequence then
                local GambitSequence = Warden.GambitToSequence(LocalPlayer.Gambits[GambitName].GambitSequence)
                LocalPlayer.Gambits[GambitSequence] = GambitName
            else
                Turbine.Shell.WriteLine("Missing Gambit Definitions");
                Turbine.Shell.WriteLine(GambitName);
            end
        end
    end
end

Warden.UpdateTraitLine = function ()
    TraitLine = "Yellow"
    if LocalPlayer.Skills["Warning Shot"] ~= nil then
        TraitLine = "Blue"
    elseif LocalPlayer.Skills["Shield Piercer"] ~= nil then
        TraitLine = "Red"
    end
    LocalPlayer.TraitLine = TraitLine
    Turbine.Shell.WriteLine(Utilities.ToString(LocalPlayer.TraitLine));
end

Warden.UpdateQuickslots = function ()
    SessionUI.CombatQuickslotWindow:SetQuickslot(Warden.Quickslots.Area, Warden.GetAreaQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Warden.Quickslots.Buff, Warden.GetBuffQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Warden.Quickslots.Deed, Warden.GetDeedQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Warden.Quickslots.Corruption, Warden.GetCorruptionQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Warden.Quickslots.Interupt, Warden.GetInteruptQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Warden.Quickslots.Range, Warden.GetRangeQuickslot());

    if LocalPlayer.IsInCombat == false then
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Area, 0.1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Buff, 0.1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Deed, 0.1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Corruption, 0.1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Interupt, 0.1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Range, 0.1);
    else
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Area, 1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Buff, 1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Deed, 1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Corruption, 1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Interupt, 1);
        SessionUI.CombatQuickslotWindow:UnblockQuickslot(Warden.Quickslots.Range, 0.1);
    end
end

Warden.GambitToSequence = function (Gambit)
    local Output = ""
    for Index, Value in ipairs(Gambit) do
        if Value == 4 then 
            Output = Output .. tostring("1")
            Turbine.Shell.WriteLine(Utilities.ToString(Output));
        else
            Output = Output .. tostring(Value)
        end
    end
    return Output
end

Warden.GetNextSkill = function (DesiredGambit)
    -- Determines the next gambit builder
    -- based on the current gambit, the desired gambit, and cooldowns
    local CurrentGambit = LocalPlayer.CurrentGambit
    local NextSkillNumber = 0
    if #CurrentGambit == 0 then
        NextSkillNumber = DesiredGambit[1]
    end
    local First = 0;
    local Follow = {};
    local FollowIndex = 1;
    for Index = 1, 5, 1 do
        if CurrentGambit[Index] ~= DesiredGambit[Index] then
            if CurrentGambit[Index] ~= nil then
                First = First + 1
            elseif First == 0 then
                Follow[FollowIndex] = DesiredGambit[Index]
                FollowIndex = FollowIndex + 1
            end
        end
    end
    if First > 1 then
        -- Reset or Default
        if Warden.CanUseSkillNumber(5) then
            NextSkillNumber = 5
        end
    elseif First == 1 then
        -- QuickReset or Reset or Default
        if  Warden.CanUseSkillNumber(6) then
            NextSkillNumber = 6
        elseif Warden.CanUseSkillNumber(5) then
            NextSkillNumber = 5
        end
    else
        if #Follow > 1 then
            -- Fast Build or Regular
            if Warden.CanUseSkillNumber(Follow[1] * 10 + Follow[2]) then
                NextSkillNumber = Follow[1] * 10 + Follow[2]
            else
                NextSkillNumber = Follow[1]
            end
        elseif #Follow == 1 then
            -- Regular
            if LocalPlayer.IsInCombat == false then
                if Warden.CanUseSkillNumber(Follow[1] * 10 + Follow[1]) then
                    NextSkillNumber = Follow[1] * 10 + Follow[1]
                else
                    NextSkillNumber = Follow[1]
                end
            else
                NextSkillNumber = Follow[1]
            end
        end
    end
    return Warden.Shortcuts[Warden.SkillNumberToName(NextSkillNumber)];
end

Warden.SkillNumberToName = function (SkillNumber)
    local Skills = {
        [0] = "Gambit Default",
        [1] = "Spear",
        [2] = "Shield",
        [3] = "Fist",
        [4] = "Spear",
        [5] = "Recovery",
        [6] = "Quick Recovery",
        [11] = "Spear and Spear",
        [12] = "Spear and Shield",
        [13] = "Spear and Fist",
        [21] = "Shield and Spear",
        [22] = "Shield and Shield",
        [23] = "Shield and Fist",
        [24] = "Shield and Javelin",
        [31] = "Fist and Spear",
        [32] = "Fist and Shield",
        [33] = "Fist and Fist",
        [34] = "Fist and Javelin",
        [42] = "Javelin and Shield",
        [43] = "Javelin and Fist",
        [44] = "Javelin and Javelin",
    }
    return Skills[SkillNumber]
end

Warden.CanUseSkillNumber = function (SkillNumber)
    local SkillName = Warden.SkillNumberToName(SkillNumber)
    if LocalPlayer.IsInCombat == false and LocalPlayer.Skills[SkillName] then
        local SkillInstance = LocalPlayer.Skills[SkillName].Instance
        return (SkillInstance:GetResetTime() <= -1)
    end
    return Utilities.CanUseSkill(SkillName)
end

Warden.GetLeastRecentlyUsed = function (GambitNames)
    local CurrentSequence = Warden.GambitToSequence(LocalPlayer.CurrentGambit);
    local EarliestGambitName = GambitNames[1]
    local EarliestTime = LocalPlayer.Gambits[EarliestGambitName].LastUsed
    for Index, GambitName in pairs(GambitNames) do
        if LocalPlayer.Gambits[GambitName] then
            if CurrentSequence == Warden.GambitToSequence(Warden.Gambits[GambitName]) then
                return GambitName
            end
            local LastTime = LocalPlayer.Gambits[GambitName].LastUsed
            --Turbine.Shell.WriteLine(Utilities.ToString(LastTime));
            if LastTime < EarliestTime then
                EarliestGambitName = GambitName
            end
        end
    end
    return EarliestGambitName
end

Warden.GetRangeQuickslot = function ()
    if LocalPlayer.IsInCombat == false then
        if not LocalPlayer.Marching and Utilities.CanUseSkill("Forced March") then
            return Warden.Shortcuts["Forced March"]
        end
    end

    local RangedSkills = {"Improved Hampering Javeline","Hampering Javelin","Marked Target","Diminished Target","Shield Piercer"};
    local NextRangedSkill = Utilities.GetLeastRecentlyUsedSkill(RangedSkills);
    if NextRangedSkill then return Warden.Shortcuts[NextRangedSkill] end

    if LocalPlayer.IsInCombat == false then
        if Utilities.PlayerMissingEffect("Preparing for Battle") then
            return Warden.Shortcuts["Battle Preparation"]
        end
    end

    local DeedGambits = {"Precise Throw","Ranged Boot","Ranged Deft Strike","Ranged Perservere","Ranged Offensive Strike"}
    local NextGambit = Warden.GetLeastRecentlyUsed(DeedGambits)
    return Warden.GetNextSkill(Warden.Gambits[NextGambit])
end

Warden.GetDeedQuickslot = function ()
    if LocalPlayer.IsInCombat == false then
        if not LocalPlayer.Marching and Utilities.CanUseSkill("Forced March") then
            return Warden.Shortcuts["Forced March"]
        end

        if Utilities.PlayerMissingEffect("Preparing for Battle") then
            return Warden.Shortcuts["Battle Preparation"]
        end
    end

    local DeedGambits = {"Deft Strike", "Defensive Strike", "Goad", "War-cry", "Precise Blow", "Safeguard"}
    local NextGambit = Warden.GetLeastRecentlyUsed(DeedGambits)
    return Warden.GetNextSkill(Warden.Gambits[NextGambit])
end

Warden.GetInteruptQuickslot = function ()
    -- TODO: Add Ranged Interupts
    local CurrentSequence = Warden.GambitToSequence(LocalPlayer.CurrentGambit);
    if LocalPlayer.Stance == Turbine.Gameplay.Attributes.WardenStance.Determination then
        if Utilities.CanUseSkill("Shield-slam") then
            return Warden.Shortcuts["Shield-slam"]
        end
        if CurrentSequence == "1" or CurrentSequence == "121" then
            return Warden.GetNextSkill(Warden.Gambits["Onslaught"])
        else
            return Warden.GetNextSkill(Warden.Gambits["The Boot"])
        end
    end
    if LocalPlayer.Stance == Turbine.Gameplay.Attributes.WardenStance.Assailment then
        if CurrentSequence == "4" or CurrentSequence == "424" then
            return Warden.GetNextSkill(Warden.Gambits["Ranged Onslaught"])
        else
            return Warden.GetNextSkill(Warden.Gambits["Ranged Boot"])
        end
    end
end

Warden.GetCorruptionQuickslot = function ()
    if LocalPlayer.Stance == Turbine.Gameplay.Attributes.WardenStance.Determination then
        if LocalPlayer.Gambits["Reversal"] ~= nil then
            return Warden.GetNextSkill(Warden.Gambits["Reversal"])
        end
    end
    if LocalPlayer.Stance == Turbine.Gameplay.Attributes.WardenStance.Assailment then
        if LocalPlayer.Gambits["Ranged Reversal"] ~= nil then
            return Warden.GetNextSkill(Warden.Gambits["Ranged Reversal"])
        end
    end
end

Warden.GetAreaQuickslot = function ()
    if LocalPlayer.IsInCombat == false then
        if Utilities.PlayerMissingEffect("Preparing for Battle") then
            return Warden.Shortcuts["Battle Preparation"]
        end
    end

    if LocalPlayer.Stance == Turbine.Gameplay.Attributes.WardenStance.Determination then
        if LocalPlayer.Gambits["Surety of Death"] ~= nil then
            return Warden.GetNextSkill(Warden.Gambits["Surety of Death"])
        end
    end
end

Warden.GetBuffQuickslot = function ()
    if LocalPlayer.IsInCombat == false then
        if not LocalPlayer.Marching and Utilities.CanUseSkill("Forced March") then
            return Warden.Shortcuts["Forced March"]
        end

        if Utilities.PlayerMissingEffect("Preparing for Battle") then
            return Warden.Shortcuts["Battle Preparation"]
        end
        -- Out of Combat Buffs
        if Utilities.PlayerMissingEffect("Enduring Tactical Armour Use") then
            if LocalPlayer.Gambits["Conviction"] ~= nil then
                return Warden.GetNextSkill(Warden.Gambits["Conviction"])
            end
        end

        if Utilities.PlayerMissingEffect("Enduring Expert Evasion") then
            if LocalPlayer.Gambits["Surety of Death"] ~= nil then
                return Warden.GetNextSkill(Warden.Gambits["Surety of Death"])
            end
        end

        if Utilities.PlayerMissingEffect("Enduring Evasion") then
            if LocalPlayer.Gambits["War-cry"] ~= nil then
                return Warden.GetNextSkill(Warden.Gambits["War-cry"])
            end
        end
    else
        -- In Combat Buffs
        -- Get Non-Present Buffs Based on Priority
        if Utilities.PlayerMissingEffect("Enduring Expert Evasion") then
            if LocalPlayer.Gambits["Surety of Death"] ~= nil then
                return Warden.GetNextSkill(Warden.Gambits["Surety of Death"])
            end
        end

        if Utilities.PlayerMissingEffect("Enduring Advanced Armour Use") then
            if LocalPlayer.Gambits["Maddening Strike"] ~= nil then
                return Warden.GetNextSkill(Warden.Gambits["Maddening Strike"])
            end
        end

        if Utilities.PlayerMissingEffect("Enduring Evasion") then
            if LocalPlayer.Gambits["War-cry"] ~= nil then
                return Warden.GetNextSkill(Warden.Gambits["War-cry"])
            end
        end

        if Utilities.PlayerMissingEffect("Enduring Shieldwork") then
            if LocalPlayer.Gambits["Persevere"] ~= nil then
                return Warden.GetNextSkill(Warden.Gambits["Persevere"])
            end
        end

        if Utilities.PlayerMissingEffect("Enduring Armour Use") then
            if LocalPlayer.Gambits["Impressive Flourish"] ~= nil then
                return Warden.GetNextSkill(Warden.Gambits["Impressive Flourish"])
            end
        end

        if LocalPlayer.Stance == Turbine.Gameplay.Attributes.WardenStance.Determination then
            if LocalPlayer.Gambits["Surety of Death"] ~= nil then
                return Warden.GetNextSkill(Warden.Gambits["Surety of Death"])
            end
        end
        -- Wall of Steel
        -- Adroit Manoeuvre
        -- Warden's Triumph
        -- Safeguard
        -- Celebration of Skill
        -- Dance of War
        -- Conviction
        -- Shield Mastery
        -- Shield Tactics
        -- Brink of Victory

        -- Get Next Expiring Buff


        -- Get DPS
        return Warden.GetDPS()
    end
end

Warden.GetDPS = function ()
    local CurrentGameTime = Turbine.Engine.GetGameTime()
    if LocalPlayer.Gambits["Power Attack"] ~= nil then
        if LocalPlayer.Gambits["Power Attack"].LastUsed + 30 < CurrentGameTime then
            return Warden.GetNextSkill(Warden.Gambits["Power Attack"])
        end
    end
    if LocalPlayer.Gambits["Mighty Blow"] ~= nil then
        if LocalPlayer.Gambits["Mighty Blow"].LastUsed + 30 < CurrentGameTime then
            return Warden.GetNextSkill(Warden.Gambits["Mighty Blow"])
        end
    end
    if LocalPlayer.Gambits["Spear of Virtue"] ~= nil then
        if LocalPlayer.Gambits["Spear of Virtue"].LastUsed + 30 < CurrentGameTime then
            return Warden.GetNextSkill(Warden.Gambits["Spear of Virtue"])
        end
    end
    if LocalPlayer.Gambits["Unerring Strike"] ~= nil then
        if LocalPlayer.Gambits["Unerring Strike"].LastUsed + 30 < CurrentGameTime then
            return Warden.GetNextSkill(Warden.Gambits["Unerring Strike"])
        end
    end
end

----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.Warden = Warden;