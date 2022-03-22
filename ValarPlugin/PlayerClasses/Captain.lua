Captain = {}

-----------------------
-- Primary Functions --
-----------------------
Captain.FastUpdate = function ()
    -- Update Data
    -- Update UI
    Captain.UpdateQuickslots();
end

Captain.Load = function ()
    PlayerClass.FastUpdate = Captain.FastUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(1290,816,6);
end

Captain.TimedUpdate = function ()
    
end


-------------------------
-- Component Functions --
-------------------------
Captain.Shortcuts = {
    -- [""] = "",
};

Captain.Quickslots = {
    ["Area"] = 2,
};

Captain.UpdateQuickslots = function ()
    SessionUI.CombatQuickslotWindow:SetQuickslot(Captain.Quickslots.Area, Captain.GetAreaQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Captain.Quickslots.Area, 0.5);
end

Captain.GetAreaQuickslot = function ()
    return nil
end


----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.Captain = Captain;