Guardian = {}

-----------------------
-- Primary Functions --
-----------------------
Guardian.FastUpdate = function ()
    -- Update Data
    -- Update UI
    Guardian.UpdateQuickslots();
end

Guardian.Load = function ()
    Model.Player.Class.Update.Fast = Guardian.FastUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(1290,816,6);
end

Guardian.TimedUpdate = function ()
    
end


-------------------------
-- Component Functions --
-------------------------
Guardian.Shortcuts = {
    -- [""] = "",
};

Guardian.Quickslots = {
    ["Area"] = 2,
};

Guardian.UpdateQuickslots = function ()
    SessionUI.CombatQuickslotWindow:SetQuickslot(Guardian.Quickslots.Area, Guardian.GetAreaQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Guardian.Quickslots.Area, 0.5);
end

Guardian.GetAreaQuickslot = function ()
    return nil
end


----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.Guardian = Guardian;