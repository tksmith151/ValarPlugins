PlayerClass = {}

-----------------------
-- Primary Functions --
-----------------------
PlayerClass.Load = function ()
    if  LocalPlayer.Class == Turbine.Gameplay.Class.Beorning    then  PlayerClasses.Beorning.Load()    end
    if  LocalPlayer.Class == Turbine.Gameplay.Class.Burglar     then  PlayerClasses.Burglar.Load()     end
    if  LocalPlayer.Class == Turbine.Gameplay.Class.Captain     then  PlayerClasses.Captain.Load()     end
    if  LocalPlayer.Class == Turbine.Gameplay.Class.Champion    then  PlayerClasses.Champion.Load()    end
    if  LocalPlayer.Class == Turbine.Gameplay.Class.Guardian    then  PlayerClasses.Guardian.Load()    end
    if  LocalPlayer.Class == Turbine.Gameplay.Class.Hunter      then  PlayerClasses.Hunter.Load()      end
    if  LocalPlayer.Class == Turbine.Gameplay.Class.LoreMaster  then  PlayerClasses.LoreMaster.Load()  end
    if  LocalPlayer.Class == Turbine.Gameplay.Class.Minstrel    then  PlayerClasses.Minstrel.Load()    end
    if  LocalPlayer.Class == Turbine.Gameplay.Class.RuneKeeper  then  PlayerClasses.RuneKeeper.Load()  end
    if  LocalPlayer.Class == Turbine.Gameplay.Class.Warden      then  PlayerClasses.Warden.Load()      end
end

PlayerClass.FastUpdate = function () end -- This function is overwritten by each class Load() function
PlayerClass.TimedUpdate = function () end -- This function is overwritten by each class Load() function

