RuneKeeper = {}

-----------------------
-- Primary Functions --
-----------------------
RuneKeeper.FastUpdate = function ()
    -- Update Data
    LocalPlayer.ClassAttributes.Attunement = LocalPlayer.ClassAttributesInstance:GetAttunement()
    -- Update UI
    RuneKeeper.UpdateQuickslots()
end

RuneKeeper.Load = function ()
    PlayerClass.FastUpdate = RuneKeeper.FastUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(945,829,4);
end

RuneKeeper.TimedUpdate = function ()
    
end


-------------------------
-- Component Functions --
-------------------------
RuneKeeper.Shortcuts = {
    -- [""] = "",
    ["Armour of the Elements"] = "0x7003006F",
    ["Break the Bounds"] = "0x7003CC4A",
    ["Ceaseless Argument"] = "0x7000EEAC",
    ["Chilling Rhetoric"] = "0x7000EE02",
    ["Distracting Flame"] = "0x700180F5",
    ["Epic Conclusion"] = "0x7000EEAF",
    ["Epic for the Ages"] = "0x7000EEA6",
    ["Essence of Flame"] = "0x7000EFEF",
    ["Essence of Winter"] = "0x7000EE01",
    ["Fiery Ridicule"] = "0x7000E96B",
    ["Final Word"] = "0x70017EEB",
    ["Flurry of Words"] = "0x7000EDFF",
    ["Fulgurite Rune-Stone"] = "0x70036B4D",
    ["Mending Verse"] = "0x7000EEA8",
    ["Nothing Truly Ends"] = "0x7000EDA1",
    ["Prelude to Hope"] = "0x7000EEAA",
    ["Rousing Words"] = "0x7000EEA4",
    ["Rune of Restoration"] = "0x7000EEA5",
    ["Rune-Sign of Winter"] = "0x70020DFB",
    ["Scribe a New Ending"] = "0x7002D0CD",
    ["Scribe's Spark"] = "0x7000EEAD",
    ["Shocking Touch"] = "0x7000F488",
    ["Shocking Words"] = "0x7000EEAE",
    ["Smouldering Wrath"] = "0x7000E96D",
    ["Speak No Evil"] = "0x70058359",
    ["Steady Hands"] = "0x700180F2",
    ["Sustaining Bolt"] = "0x70024D3A",
    ["Volcanic Rune-Stone"] = "0x700377AC",
    ["Word of Exaltation"] = "0x7000EEA7",
    ["Writ of Fire"] = "0x7000EFF0",
    ["Writ of Health"] = "0x7000EEA9",
    ["Writ of Lightning"] = "0x70037F68",
};

RuneKeeper.Quickslots = {
    ["Area"] = 3,
    ["Kite"] = 2,
    ["Siege"] = 1,
};

RuneKeeper.UpdateQuickslots = function ()
    SessionUI.CombatQuickslotWindow:SetQuickslot(RuneKeeper.Quickslots.Area, RuneKeeper.GetAreaQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(RuneKeeper.Quickslots.Kite, RuneKeeper.GetKiteQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(RuneKeeper.Quickslots.Siege, RuneKeeper.GetSiegeQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(RuneKeeper.Quickslots.Area, 0.1);
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(RuneKeeper.Quickslots.Kite, 0.1);
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(RuneKeeper.Quickslots.Siege, 0.1);
end

RuneKeeper.GetAreaQuickslot = function ()
    if Utilities.CanUseSkill("Flurry of Words") then
        return RuneKeeper.Shortcuts["Flurry of Words"]
    end
end

RuneKeeper.GetKiteQuickslot = function ()
    if Utilities.PlayerMissingEffect("Prelude to Hope") then
        if Utilities.CanUseSkill("Prelude to Hope") then
            return RuneKeeper.Shortcuts["Prelude to Hope"]
        end
    end

    if LocalPlayer.ClassAttributes.Attunement == 1 then
        if Utilities.PlayerHasEffect("Charged") then
            if Utilities.CanUseSkill("Sustaining Bolt") then
                return RuneKeeper.Shortcuts["Sustaining Bolt"]
            end
        end

        if Utilities.CanUseSkill("Shocking Words") then
            return RuneKeeper.Shortcuts["Shocking Words"]
        end

        if Utilities.CanUseSkill("Epic Conclusion") then
            return RuneKeeper.Shortcuts["Epic Conclusion"]
        end
    end

    local NextSkill = nil;
    local PrioritySkills = {
        "Writ of Lightning",
        "Ceaseless Argument",
        "Scribe's Spark",
    }
    NextSkill = Utilities.GetPrioritySkill(PrioritySkills);
    if NextSkill then return RuneKeeper.Shortcuts[NextSkill] end
end

RuneKeeper.GetSiegeQuickslot = function ()
    if LocalPlayer.ClassAttributes.Attunement == 1 then
        if Utilities.CanUseSkill("Smouldering Wrath") then
            return RuneKeeper.Shortcuts["Smouldering Wrath"]
        end
    end

    local NextSkill = nil;
    local PrioritySkills = {
        "Distracting Flame",
        "Writ of Fire",
        "Firey Ridicule",
    }
    NextSkill = Utilities.GetPrioritySkill(PrioritySkills);
    if NextSkill then return RuneKeeper.Shortcuts[NextSkill] end
end

----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.RuneKeeper = RuneKeeper;