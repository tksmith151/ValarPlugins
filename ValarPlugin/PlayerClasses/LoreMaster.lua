LoreMaster = {}

-----------------------
-- Primary Functions --
-----------------------
LoreMaster.FastUpdate = function ()
    -- Update Data
    -- Update UI
    LoreMaster.UpdateQuickslots();
end

LoreMaster.Load = function ()
    Model.Player.Class.Update.Fast = LoreMaster.FastUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(1290,816,6);
end

LoreMaster.TimedUpdate = function ()
    
end


-------------------------
-- Component Functions --
-------------------------
LoreMaster.Shortcuts = {
    -- [""] = "",
};

LoreMaster.Quickslots = {
    ["Area"] = 2,
};

LoreMaster.UpdateQuickslots = function ()
    SessionUI.CombatQuickslotWindow:SetQuickslot(LoreMaster.Quickslots.Area, LoreMaster.GetAreaQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(LoreMaster.Quickslots.Area, 0.5);
end

LoreMaster.GetAreaQuickslot = function ()
    return nil
end


----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.LoreMaster = LoreMaster;