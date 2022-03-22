Burglar = {}

-----------------------
-- Primary Functions --
-----------------------
Burglar.FastUpdate = function ()
    Burglar.UpdateStealth()
    Burglar.UpdateQuickslots()
end

Burglar.Load = function ()
    PlayerClass.FastUpdate = Burglar.FastUpdate;
    PlayerClass.Shortcuts = Burglar.Shortcuts;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(945,829,4);

    LocalPlayer.InStealth = false;
end

Burglar.TimedUpdate = function ()
    Burglar.UpdateTraitLine()
end


-------------------------
-- Component Functions --
-------------------------
Burglar.Shortcuts = {
    -- [""] = "",
    ["Addle"] = "0x70003F0E",
    ["Blind Bet"] = "0x70032F7C",
    ["Burglar's Antidote"] = "0x7001F4A4",
    ["Burgle"] = "0x70003F16",
    ["Cunning Attack"] = "0x70003F09",
    ["Cure Poison"] = "0x70003F17",
    ["Diversion"] = "0x700031F5",
    ["Double-edged Strike"] = "0x70003F0C",
    ["Exploit Opening"] = "0x70003F0D",
    ["Feint Attack"] = "0x7000FB71",
    ["Find Footing"] = "0x70003F14",
    ["Gambler's Advantage"] = "0x70003F0B",
    ["Hedge Your Bet"] = "0x70032F7D",
    ["Knives Out"] = "0x7000D444",
    ["Lucky Strike"] = "0x7000FD86",
    ["Purge Corruption"] = "0x7003A68C",
    ["Reveal Weakness"] = "0x70003F11",
    ["Riddle"] = "0x700031D8",
    ["Safe Fall"] = "0x7002613D",
    ["Sneak"] = "0x70003212",
    ["Subtle Stab"] = "0x700031D3",
    ["Surprise Strike"] = "0x70003F08",
    ["Throw Knife"] = "0x70052177",
    ["Touch and Go"] = "0x70003F13",
    ["Track Treasure"] = "0x70003F15",
    -- Race Specific
    ["Upper-cut"] = "0x700062EC",
};

Burglar.Quickslots = {
    ["Corruption"] = 3,
    ["Focus"] = 4,
    ["Interupt"] = 1,
};

Burglar.UpdateTraitLine = function ()
    LocalPlayer.TraitLine = "Blue"
    LocalPlayer.TraitLine = "Red"
    LocalPlayer.TraitLine = "Yellow"
end

Burglar.UpdateStealth = function ()
    if LocalPlayer.Skills["Sneak"].InUse then
        LocalPlayer.InStealth = true;
        return
    end
    LocalPlayer.InStealth = false;
end

Burglar.UpdateQuickslots = function ()
    -- Corruption
    SessionUI.CombatQuickslotWindow:SetQuickslot(Burglar.Quickslots.Corruption, Burglar.GetCorruptionQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Burglar.Quickslots.Corruption, 0.2);
    -- Focus
    SessionUI.CombatQuickslotWindow:SetQuickslot(Burglar.Quickslots.Focus, Burglar.GetFocusQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Burglar.Quickslots.Focus, 0.2);
    -- Interupt
    SessionUI.CombatQuickslotWindow:SetQuickslot(Burglar.Quickslots.Interupt, Burglar.GetInteruptQuickslot());
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Burglar.Quickslots.Interupt, 0.2);
end
-- TODO: Crowd Controls
-- TODO: Heals

Burglar.GetSneak = function ()
    if not LocalPlayer.InStealth and Utilities.CanUseSkill("Sneak") then return "Sneak" end
end

Burglar.GetRevealWeakness = function ()
    if LocalPlayer.Skills["Reveal Weakness"] ~= nil then
        if not LocalPlayer.Skills["Reveal Weakness"].InUse and Utilities.CanUseSkill("Reveal Weakness") then return "Reveal Weakness" end
    end
end

Burglar.GetAntidote = function ()
    if LocalPlayer.CanCure and Utilities.CanUseSkill("Burglar's Antidote") then
        return "Burglar's Antidote";
    end
end

Burglar.GetHeal = function ()
    if LocalPlayer.MoralePercentage < 0.3 and Utilities.CanUseSkill("Touch and Go") then
        return "Touch and Go"
    end
end

Burglar.GetCorruptionQuickslot = function ()
    local NextSkill = nil;

    NextSkill = Burglar.GetAntidote()
    if NextSkill then return Burglar.Shortcuts[NextSkill] end

    local PrioritySkills = {
        "Find Footing",
        "Purge Corruption",
    }
    NextSkill = Utilities.GetPrioritySkill(PrioritySkills);
    if NextSkill then return Burglar.Shortcuts[NextSkill] end
end

Burglar.GetFocusQuickslot = function ()
    local NextSkill = nil;

    NextSkill = Burglar.GetAntidote()
    if NextSkill then return Burglar.Shortcuts[NextSkill] end

    NextSkill = Burglar.GetHeal()
    if NextSkill then return Burglar.Shortcuts[NextSkill] end
    --
    -- NextSkill = Burglar.GetSneak()
    -- if NextSkill then return Burglar.Shortcuts[NextSkill] end
    --
    -- NextSkill = Burglar.GetRevealWeakness()
    -- if NextSkill then return Burglar.Shortcuts[NextSkill] end
    --

    local PrioritySkills = {
        "Find Footing",
        "Lucky Strike",
        "Blind Bet",
        "Feint Attack",
        "Double-edged Strike",
        "Gambler's Advantage",
        "Cunning Attack",
        "Hedge Your Bet",
        "Surprise Strike",
        "Subtle Stab",
        "Throw Knife",
        "Upper-cut",
    }
    NextSkill = Utilities.GetPrioritySkill(PrioritySkills);
    if NextSkill then return Burglar.Shortcuts[NextSkill] end
end

Burglar.GetInteruptQuickslot = function ()
    local NextSkill = nil;

    NextSkill = Burglar.GetAntidote()
    if NextSkill then return Burglar.Shortcuts[NextSkill] end

    local PrioritySkills = {
        "Find Footing",
        "Addle",
        "Riddle",
        "Exploit Opening",
    }
    NextSkill = Utilities.GetPrioritySkill(PrioritySkills);
    if NextSkill then return Burglar.Shortcuts[NextSkill] end
end

----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.Burglar = Burglar;