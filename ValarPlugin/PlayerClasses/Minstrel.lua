Minstrel = {}

-----------------------
-- Primary Functions --
-----------------------
Minstrel.FastUpdate = function ()
    -- Update Data
    -- Update UI
    Minstrel.UpdateQuickslots();
end

Minstrel.Load = function ()
    Model.Update.PlayerClass.Fast = Minstrel.FastUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(1290,816,6);
end

Minstrel.TimedUpdate = function ()
    
end

-------------------------
-- Component Functions --
-------------------------
Minstrel.Shortcuts = {
    -- [""] = "",
};

Minstrel.Quickslots = {
    ["Area"] = 2,
};

Minstrel.UpdateQuickslots = function ()
    SessionUI.CombatQuickslotWindow:SetQuickslot(Minstrel.Quickslots.Area, Minstrel.GetAreaQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Minstrel.Quickslots.Area, 0.5);
end

Minstrel.GetAreaQuickslot = function ()
    return nil
end


----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.Minstrel = Minstrel;