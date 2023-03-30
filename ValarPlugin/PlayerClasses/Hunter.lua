Hunter = {}

-----------------------
-- Primary Functions --
-----------------------
Hunter.FastUpdate = function ()
    -- Update Data
    -- Update UI
    Hunter.UpdateQuickslots();
end

Hunter.Load = function ()
    Model.Update.PlayerClass.Fast = Hunter.FastUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(1290,816,6);
end

Hunter.TimedUpdate = function ()
    
end


-------------------------
-- Component Functions --
-------------------------
Hunter.Shortcuts = {
    -- [""] = "",
};

Hunter.Quickslots = {
    ["Area"] = 2,
};

Hunter.UpdateQuickslots = function ()
    SessionUI.CombatQuickslotWindow:SetQuickslot(Hunter.Quickslots.Area, Hunter.GetAreaQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Hunter.Quickslots.Area, 0.5);
end

Hunter.GetAreaQuickslot = function ()
    return nil
end


----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.Hunter = Hunter;