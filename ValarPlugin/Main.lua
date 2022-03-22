----------------------
-- Provided Imports --
----------------------
import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";

-----------------------
-- Developed Imports --
-----------------------
import "ValarPlugins.ValarPlugin";

-----------------
-- Root Tables --
-----------------
LocalPlayer = {};
SessionUI = {};

-----------
-- Debug --
-----------
debug = function ()
    Turbine.Shell.WriteLine("Valar Plugin Debug");
    --local key_list = {}
    --for k,v in pairs(LocalPlayer.Skills) do
    --    table.insert(key_list, k)
    --end
    --table.sort(key_list)
    --Turbine.Shell.WriteLine(Utilities.ToString(key_list));
    --Turbine.Shell.WriteLine(Utilities.ToString(LocalPlayer.Skills[1]:GetName()))
    --Turbine.Shell.WriteLine(Utilities.ToString(LocalPlayer.Stance));
    Turbine.Shell.WriteLine(Utilities.ToString(SessionUI.DebugWindow.DebugQuickslot:GetShortcut():GetData()));
    Turbine.Shell.WriteLine(Utilities.ToString(LocalPlayer.TargetEffects));
end


----------------------
-- Update Functions --
----------------------
TimedUpdate = function ()
    Common.TimedUpdate();
    PlayerClass.TimedUpdate();
end

FastUpdate = function ()
    Common.FastUpdate();
    PlayerClass.FastUpdate();
end


------------------------
-- Timed Updated Loop --
------------------------
TimedLoop = class( Turbine.UI.Control );
function TimedLoop:Constructor(UpdateFunction, Interval)
    Turbine.UI.Control.Constructor( self );
    self.Interval = Interval;

    self.Start = function ()
        self.NextTime = 0;
        self:SetWantsUpdates(true);
    end

    self.Stop = function()
        self:SetWantsUpdates(false);
    end

    self.Update=function()
        self.CurrentTime = Turbine.Engine.GetGameTime();
        if self.CurrentTime > self.NextTime then
            self.NextTime = Turbine.Engine.GetGameTime() + Interval;
            TimedUpdate();
        end
    end
end


----------------------
-- Fast Update Loop --
----------------------
FastLoop = class( Turbine.UI.Control );
function FastLoop:Constructor(UpdateFunction)
    Turbine.UI.Control.Constructor( self );

    self.Start = function ()
        self:SetWantsUpdates(true);
    end

    self.Stop = function()
        self:SetWantsUpdates(false);
    end

    self.Update=function()
        UpdateFunction();
    end
end


----------------------------------
-- Plugin Loading and Unloading --
----------------------------------
Load = function ()
    -- Load Session Data and Functions
    Common.Load();
    PlayerClass.Load();
    TimedUpdate();

    -- Setup Timed Loop
    MainTimedLoopInterval = 5; -- number of seconds
    MainTimedLoop = TimedLoop(TimedUpdate, MainTimedLoopInterval);
    MainTimedLoop.Start();

    -- Setup Fast Loop
    MainFastLoop = FastLoop(FastUpdate);
    MainFastLoop.Start();    
end

Unload = function ()
    -- Stop Timed Loop
    MainTimedLoop.Stop();
    MainFastLoop.Stop();
end


--------------------------------------------
-- Plugin Loading and Unloading Listeners --
--------------------------------------------
Turbine.Plugin.Load = function(self, sender, args)
    Turbine.Shell.WriteLine("-- ValarPlugin: Loading --");
    Load()
    Turbine.Shell.WriteLine("-- ValarPlugin: Loaded! --");
end

Turbine.Plugin.Unload = function(self, sender, args)
    Turbine.Shell.WriteLine("-- ValarPlugin: Unloading --");
    Unload()
    Turbine.Shell.WriteLine("-- ValarPlugin: Unloaded! --");
end

