Beorning = {}

-----------------------
-- Primary Functions --
-----------------------
Beorning.FastUpdate = function ()
    -- Update Data
    -- Update UI
    Beorning.UpdateQuickslots();
end

Beorning.Load = function ()
    PlayerClass.FastUpdate = Beorning.FastUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(1290,816,6);
end

Beorning.TimedUpdate = function ()
    
end


-------------------------
-- Component Functions --
-------------------------
Beorning.Shortcuts = {
    -- [""] = "",
    [""] = "",
};

Beorning.Quickslots = {
    ["Area"] = 2,
};

Beorning.UpdateQuickslots = function ()
    SessionUI.CombatQuickslotWindow:SetQuickslot(Beorning.Quickslots.Area, Beorning.GetAreaQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Beorning.Quickslots.Area, 0.5);
end

Beorning.GetAreaQuickslot = function ()
    return nil
end


----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.Beorning = Beorning;