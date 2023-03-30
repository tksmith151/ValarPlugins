Champion = {}

-----------------------
-- Primary Functions --
-----------------------
Champion.FastUpdate = function ()
    -- Update Data
    LocalPlayer.ClassAttributes.Fervor = LocalPlayer.ClassAttributesInstance:GetFervor();
    -- Update UI
    Champion.UpdateQuickslots();
end

Champion.Load = function ()
    Model.Player.Class.Update.Fast = Champion.FastUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(1290,816,6);
end

Champion.TimedUpdate = function ()
    
end


-------------------------
-- Component Functions --
-------------------------
Champion.Shortcuts = {
    -- [""] = "",
    ["Battle Frenzy"] = "0x70003043",
    ["Blade Wall"] = "0x70003DFD",
    ["Blade Storm"] = "0x70003E03",
    ["Blood Rage"] = "0x7000F70E",
    ["Bracing Attack"] = "0x70003E04",
    ["Brtual Strikes"] = "0x70003E01",
    ["Champion's Challenge"] = "0x70003E08",
    ["Clobber"] = "0x70003E0C",
    ["Devastating Strike"] = "0x70036AA2",
    ["Feral Strikes"] = "0x7003B445",
    ["Let Fly"] = "0x70003E14",
    ["Raging Blade"] = "0x70002DA9",
    ["Remorseless Strike"] = "0x7001F4B3",
    ["Rend"] = "0x7000F660",
    ["Swift Strike"] = "0x7000300F",
    ["Wild Attack"] = "0x70003DFC",
};

Champion.Quickslots = {
    ["Area"] = 2,
    ["Focus"] = 4,
    ["Range"] = 1,
};

Champion.UpdateQuickslots = function ()
    SessionUI.CombatQuickslotWindow:SetQuickslot(Champion.Quickslots.Area, Champion.GetAreaQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Champion.Quickslots.Focus, Champion.GetFocusQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Champion.Quickslots.Range, Champion.GetRangeQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Champion.Quickslots.Area, 0.5);
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Champion.Quickslots.Focus, 0.5);
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Champion.Quickslots.Range, 0.5);
end

Champion.GetAreaQuickslot = function ()
    local NextSkill = nil;
    local PrioritySkills = {
        "Raging Blade",
        "Blade Storm",
        "Blade Wall",
        "Rend",
        "Swift Strike",
        "Wild Attack",
    }
    NextSkill = Utilities.GetPrioritySkill(PrioritySkills);
    if NextSkill then return Champion.Shortcuts[NextSkill] end
end

Champion.GetFocusQuickslot =  function ()
    local NextSkill = nil;
    local PrioritySkills = {
        "Remorseless Strike",
        "Brtual Strikes",
        "Devastating Strike",
        "Swift Strike",
        "Wild Attack",
    }
    NextSkill = Utilities.GetPrioritySkill(PrioritySkills);
    if NextSkill then return Champion.Shortcuts[NextSkill] end
end

Champion.GetRangeQuickslot =  function ()
    if Utilities.CanUseSkill("Let Fly") then return Champion.Shortcuts["Let Fly"] end
end

----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.Champion = Champion;