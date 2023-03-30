Beorning = {}

-----------------------
-- Primary Functions --
-----------------------
Beorning.FastUpdate = function ()
    -- Update Data
    Beorning.UpdateWrath();
    Beorning.UpdateMarkOfBeornApplied();
    -- Update UI
    Beorning.UpdateQuickslots();
end

Beorning.Load = function ()
    Model.Player.Class.Update.Fast = Beorning.FastUpdate;
    Model.Player.Class.Update.Timed = Beorning.TimedUpdate;
    SessionUI.CombatQuickslotWindow = UI.QuickslotWindow(1290,816,6);
    Beorning.Wrath = 0
    Beorning.MarkOfBeornApplied = false
    Beorning.TargetAquired = 0

    Utilities.AddCallback(LocalPlayer.Instance, "TargetChanged", Beorning.OnTargetChange)
end

Beorning.TimedUpdate = function ()
    Beorning.UpdateTraitLine();
end


-------------------------
-- Component Functions --
-------------------------
Beorning.Skills = {
    ["0x70041255"] = { icon = 0x4115B22D, en = "Bash", de = "Heftiger Schlag", fr = "Coup violent" },
    ["0x70042DB4"] = { icon = 0x4115E07B, en = "Bear Up", de = "Bear Up", fr = "Bear Up" },
    ["0x700403BB"] = { icon = 0x4115B220, en = "Bee Swarm", de = "Bienenschwarm", fr = "Essaim d'abeilles" },
    ["0x70040390"] = { icon = 0x4115B224, en = "Biting Edge", de = "Bei\195\159ende Schneide", fr = "Lame mordante" },
    ["0x70041257"] = { icon = 0x4115B27C, en = "Call To Wild", de = "Ruf der Wildnis", fr = "Appel sauvage" },
    ["0x70041289"] = { icon = 0x4115B226, en = "Claw Swipe", de = "Klauenstreich", fr = "Griffure" },
    ["0x7004039E"] = { icon = 0x4115B227, en = "Cleanse", de = "S\195\164ubern", fr = "Purification" },
    ["0x7004128C"] = { icon = 0x4115B229, en = "Counter", de = "Konter", fr = "Contre" },
    ["0x7004128A"] = { icon = 0x4115C255, en = "Counterattack", de = "Gegenangriff", fr = "Contre-attaque" },
    ["0x700412EE"] = { icon = 0x4115B228, en = "Encouraging Roar", de = "Ermutigendes Br\195\188llen", fr = "Rugissement d'encouragement" },
    ["0x70041256"] = { icon = 0x4115B238, en = "Execute", de = "Ausf\195\188hren", fr = "Ex\195\169cution" },
    ["0x70041258"] = { icon = 0x4115B225, en = "Expose", de = "Ungesch\195\188tzt", fr = "Exposition" },
    ["0x7004039C"] = { icon = 0x4115B236, en = "Ferocious Roar", de = "Grimmiges Gebr\195\188ll", fr = "Rugissement f\195\169roce" },
    ["0x700403B7"] = { icon = 0x4115B222, en = "Grisly Cry", de = "Grausiger Schrei", fr = "Cri atroce" },
    ["0x7004128E"] = { icon = 0x4115B22B, en = "Guarded Attack", de = "Besonnener Angriff", fr = "Attaque gard\195\169e" },
    ["0x7004039B"] = { icon = 0x4115B230, en = "Hearten", de = "Ermuntern", fr = "Encouragement" },
    ["0x700412EB"] = { icon = 0x4115B21E, en = "Mark of Beorn", de = "Zeichen von Beorn", fr = "Marque de Beorn" },
    ["0x700412EF"] = { icon = 0x4115B22A, en = "Mark of Grimbeorn", de = "Zeichen von Grimbeorn", fr = "Marque de Grimbeorn" },
    ["0x70041F1B"] = { icon = 0x4115B27A, en = "Nature's Bond", de = "Bund der Natur", fr = "Lien avec la Nature" },
    ["0x700412EA"] = { icon = 0x4115B239, en = "Nature's Mend", de = "Nat\195\188rliche Genesung", fr = "R\195\169paration naturelle" },
    ["0x7004039F"] = { icon = 0x4115B232, en = "Nature's Vengeance", de = "Die Rache der Natur", fr = "Revanche de la Nature" },
    ["0x70041253"] = { icon = 0x4115B22E, en = "Piercing Roar", de = "Durchdringendes Br\195\188llen", fr = "Rugissement per\195\167ant" },
    ["0x7004128D"] = { icon = 0x4115B22F, en = "Recuperate", de = "Erholen", fr = "R\195\169cup\195\169ration" },
    ["0x70041F62"] = { icon = 0x4115B27E, en = "Rejuvenating Bellow", de = "Erfrischendes Knurren", fr = "Hurlement du renouveau" },
    ["0x700403B9"] = { icon = 0x4115B22C, en = "Relentless Maul", de = "Unerbittliche Zerfleischung", fr = "Mutilation acharn\195\169e" },
    ["0x7004128B"] = { icon = 0x4115B21B, en = "Rending Blow", de = "Rei\195\159ender Hieb", fr = "Attaque d\195\169chirante" },
    ["0x7004039A"] = { icon = 0x4115B223, en = "Rush", de = "Vorschnellen", fr = "Ru\195\169e" },
    ["0x700403B8"] = { icon = 0x4115B231, en = "Sacrifice", de = "Aufopferung", fr = "Sacrifice" },
    ["0x7004039D"] = { icon = 0x4115B234, en = "Shake Free", de = "Absch\195\188tteln", fr = "Arrachement" },
    ["0x700422ED"] = { icon = 0x4115B21A, en = "Skin-change", de = "Pelzwechsel", fr = "Changement de peau" },
    ["0x70040391"] = { icon = 0x4115B235, en = "Slam", de = "Bewusstlos schlagen", fr = "Claquement brusque" },
    ["0x7004038F"] = { icon = 0x4115B221, en = "Slash", de = "Schneiden", fr = "Coup tranchant" },
    ["0x700412ED"] = { icon = 0x4115B21C, en = "Takedown", de = "Zu Fall gebracht", fr = "Tacle" },
    ["0x70041F1C"] = { icon = 0x4115B27B, en = "Thickened Hide", de = "Verdichteter Pelz", fr = "Cuir renforc\195\169" },
    ["0x70041E78"] = { icon = 0x4115B219, en = "Thrash - Tier 1", de = "Pr\195\188geln - Stufe 1", fr = "Passage \195\160 tabac - niveau\194\1601" },
    ["0x700403BA"] = { icon = 0x4115B237, en = "Vicious Claws", de = "Boshafte Krallen", fr = "Griffes sauvages" },
    ["0x700403B6"] = { icon = 0x4115B21F, en = "Vigilant Roar", de = "Aufmerksames Gebr\195\188ll", fr = "Rugissement vigilant" },

    -- Mounted
    ["0x7004165C"] = { icon = 0x4112A940, en = "Bee Swarm", de = "Bienenschwarm", fr = "Essaim d'abeilles" },
    ["0x70041B4B"] = { icon = 0x41135B81, en = "Biting Edge", de = "Bei\195\159ende Schneide", fr = "Lame mordante" },
    ["0x70041657"] = { icon = 0x4112B111, en = "Execute", de = "Ausf\195\188hren", fr = "Ex\195\169cution" },
    ["0x70041646"] = { icon = 0x4112A70F, en = "Discipline: Red Dawn", de = "Disziplin: Morgenr\195\182te", fr = "Discipline\194\160: Aube rouge" },
    ["0x70041647"] = { icon = 0x4112A713, en = "Discipline: Riddermark", de = "Disziplin: Riddermark", fr = "Discipline\194\160: Riddermark" },
    ["0x70041648"] = { icon = 0x4112A712, en = "Discipline: Rohirrim", de = "Disziplin: Rohirrim", fr = "Discipline\194\160: Rohirrim" },
    ["0x70041652"] = { icon = 0x41135B7A, en = "Ferocious Roar", de = "Grimmiges Gebr\195\188ll", fr = "Rugissement f\195\169roce" },
    ["0x70041658"] = { icon = 0x41135B79, en = "Recuperate", de = "Erholen", fr = "R\195\169cup\195\169ration" },
    ["0x7004164E"] = { icon = 0x4112AC0F, en = "Slash", de = "Schneiden", fr = "Coup tranchant" },
    ["0x70041974"] = { icon = 0x41135D2B, en = "Sixth Sense", de = "Sechster Sinn", fr = "Sixi\195\168me sens" },

    -- Light
    ["0x7004257E"] = { icon = 0x411294D5, en = "Bolstering Cry", de = "Ermutigender Schrei", fr = "Cri encourageant" },
    ["0x7004257D"] = { icon = 0x411294D8, en = "Feign Injury", de = "Verletzung vort\195\164uschen", fr = "Simulation de blessure" },	-- CHECK: Light/Red
    ["0x7004257C"] = { icon = 0x411294D6, en = "Invigorate", de = "Beleben", fr = "Stimulation" },

    -- Medium
    ["0x700425A9"] = { icon = 0x411294D7, en = "Dash", de = "Spurt", fr = "Course folle" },												-- CHECK: Medium/Yellow
    ["0x7004257F"] = { icon = 0x4112BD67, en = "Sacrifice", de = "Aufopferung", fr = "Sacrifice" },										-- CHECK: Medium/Blue

    -- Heavy
    ["0x700425AA"] = { icon = 0x411294D7, en = "Dash", de = "Spurt", fr = "Course folle" },
    ["0x70042577"] = { icon = 0x4112BD6D, en = "Instigate", de = "Aufhetzen", fr = "Incitation" },										-- CHECK: Heavy/Red
    ["0x70042578"] = { icon = 0x4112BD6F, en = "Positive Thinking", de = "Positiv denken", fr = "Pens\195\169es positives" },			-- CHECK: Heavy/Blue
    ["0x7004257A"] = { icon = 0x4112FA39, en = "Ride for Ruin", de = "H\195\182llenritt", fr = "Course vers la destruction" },			-- CHECK: Heavy/Red
    ["0x70042579"] = { icon = 0x4112BD6B, en = "Steel Skin", de = "Stahlhaut", fr = "Peau d'acier" },									-- CHECK: Heavy/Blue
    ["0x7004257B"] = { icon = 0x4112BD65, en = "Trample", de = "Niedertrampeln", fr = "Pi\195\169tinement" },							-- CHECK: Heavy/Red

    -- Race
    ["0x700419A8"] = { icon = 0x4115989F, en = "Bake a Honey-cake", de = "Backt einen Honigkuchen", fr = "Pr\195\169parer un g\195\162teau au miel" },
    ["0x70041A33"] = { icon = 0x411599B8, en = "Bracing Roar", de = "St\195\164rkendes Br\195\188llen", fr = "Rugissement fortifiant" },
    ["0x70041A2F"] = { icon = 0x411599B7, en = "Feral Presence", de = "Wilde Anziehungskraft", fr = "Pr\195\169sence sauvage" },
    ["0x70041A22"] = { icon = 0x4115999D, en = "Return Home", de = "Zum 1. Heim zur\195\188ckkehren", fr = "Retour \195\160 la maison" },
}

Beorning.Shortcuts = {
    -- [""] = "",
    ["Bash"] = "0x70041255",
    ["Bear-form"] = "0x700422ED",
    ["Bear Up"] = "0x70042DB4",
    ["Bee Swarm"] = "0x700403BB",
    ["Biting Edge"] = "0x70040390",
    ["Call To Wild"] = "0x70041257",
    ["Claw Swipe"] = "0x70041289",
    ["Cleanse"] = "0x7004039E",
    ["Counter"] = "0x7004128C",
    ["Counterattack"] = "0x7004128A",
    ["Encouraging Roar"] = "0x700412EE",
    ["Execute"] = "0x70041256",
    ["Expose"] = "0x70041258",
    ["Ferocious Roar"] = "0x7004039C",
    ["Grisly Cry"] = "0x700403B7",
    ["Guarded Attack (Dual)"] = "0x7004128E",
    ["Hearten"] = "0x7004039B",
    ["Man-form"] = "0x70052366",
    ["Mark of Beorn"] = "0x700412EB",
    ["Mark of Grimbeorn"] = "0x700412EF",
    ["Nature's Bond"] = "0x70041F1B",
    ["Nature's Mend"] = "0x700412EA",
    ["Nature's Vengeance"] = "0x7004039F",
    ["Piercing Roar"] = "0x70041253",
    ["Recuperate"] = "0x7004128D",
    ["Rejuvenating Bellow"] = "0x70041F62",
    ["Relentless Maul"] = "0x700403B9",
    ["Rending Blow"] = "0x7004128B",
    ["Rush"] = "0x7004039A",
    ["Sacrifice"] = "0x700403B8",
    ["Serrated Edge"] = "0x70040390",
    ["Shake Free"] = "0x7004039D",
    ["Slam"] = "0x70040391",
    ["Slash"] = "0x7004038F",
    ["Takedown"] = "0x700412ED",
    ["Thickened Hide"] = "0x70041F1C",
    ["Thrash - Tier 1"] = "0x70041E78",
    ["Vicious Claws"] = "0x700403BA",
    ["Vigilant Roar"] = "0x700403B6",
};

----------------
-- Quickslots --
----------------

Beorning.Quickslots = {
    ["Bear"] = 4,
    ["Damage"] = 1,
    ["Man"] = 6,
    ["Main"] = 2,
};

Beorning.UpdateQuickslots = function ()
    -- Update Quickslots
    SessionUI.CombatQuickslotWindow:SetQuickslot(Beorning.Quickslots.Damage, Beorning.GetDamageQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Beorning.Quickslots.Bear, Beorning.GetBearQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Beorning.Quickslots.Man, Beorning.GetManQuickslot());
    SessionUI.CombatQuickslotWindow:SetQuickslot(Beorning.Quickslots.Main, Beorning.GetMainQuickslot());

    -- Unblock Quickslots
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Beorning.Quickslots.Damage, 0.8);
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Beorning.Quickslots.Bear, 0.8);
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Beorning.Quickslots.Man, 0.8);
    SessionUI.CombatQuickslotWindow:UnblockQuickslot(Beorning.Quickslots.Main, 0.8);
end

Beorning.GetBearQuickslot = function ()
    local SkillName = nil
    local PrioritySkillSelectors = {}
    if LocalPlayer.TraitLine == "Blue" then
        PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.BearForm,
            Beorning.BlueBearDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        if SkillName then return Beorning.Shortcuts[SkillName] end
    end

    if LocalPlayer.TraitLine == "Red" then
        PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.BearForm,
            Beorning.RedBearDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        if SkillName then return Beorning.Shortcuts[SkillName] end
    end
end

Beorning.GetManQuickslot = function ()
    local SkillName = nil
    local PrioritySkillSelectors = {}
    if LocalPlayer.TraitLine == "Blue" then
        PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.ManForm,
            Beorning.Hearten,
            Beorning.PreBuildWrath,
            Beorning.GuardedAttack,
            Beorning.BlueManDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        if SkillName then return Beorning.Shortcuts[SkillName] end
    end

    if LocalPlayer.TraitLine == "Red" then
        PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.ManForm,
            Beorning.Hearten,
            Beorning.RedManDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        if SkillName then return Beorning.Shortcuts[SkillName] end
    end

    if LocalPlayer.TraitLine == "Yellow" then
        PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.ManForm,
            Beorning.Hearten,
            Beorning.RedManDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        if SkillName then return Beorning.Shortcuts[SkillName] end
    end
end

Beorning.GetMainQuickslot = function ()
    local SkillName = nil
    local PrioritySkillSelectors = {}
    if LocalPlayer.TraitLine == "Blue" then
        PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.Hearten,
            Beorning.PreBuildWrath,
            Beorning.GuardedAttack,
            Beorning.BlueBearDPS,
            Beorning.BlueManDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        if SkillName then return Beorning.Shortcuts[SkillName] end
    end

    if LocalPlayer.TraitLine == "Red" then
        PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.Hearten,
            Beorning.RedBearDPS,
            Beorning.RedManDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        if SkillName then return Beorning.Shortcuts[SkillName] end
    end

    if LocalPlayer.TraitLine == "Yellow" then
        PrioritySkillSelectors = {
            Beorning.GribeornMark,
            Beorning.YellowSelfHeal,
            Beorning.Cleanse,
            Beorning.YellowMark,
            Beorning.YellowBearDPS,
            Beorning.YellowManDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        if SkillName then return Beorning.Shortcuts[SkillName] end
    end
end

---------------
-- Callbacks --
---------------
Beorning.OnTargetChange = function (sender, args)
    Beorning.TargetAquired = Turbine.Engine.GetGameTime();
end

Beorning.UpdateMarkOfBeornApplied = function ()
    if LocalPlayer.TraitLine == "Yellow" then
        if LocalPlayer.Skills["Mark of Beorn"] ~= nil then
            if LocalPlayer.Skills["Mark of Beorn"].InUse then
                if Beorning.TargetAquired < LocalPlayer.Skills["Mark of Beorn"].LastUsed then
                    Beorning.MarkOfBeornApplied = true;
                    return
                end
            end
        end
    end
    Beorning.MarkOfBeornApplied = false;
end

-----------------------------
-- Common Helper Functions --
-----------------------------

Beorning.Cleanse = function ()
    if LocalPlayer.CanCure and Utilities.CanUseSkill("Cleanse") then return "Cleanse" end
end

Beorning.Hearten = function ()
    if not (LocalPlayer.MoralePercentage < 0.6 or Beorning.Wrath < 50) then return end
    local FormSkill = Beorning.ManForm()
    if FormSkill then return FormSkill end
    if Utilities.CanUseSkill("Hearten") then
        return "Hearten"
    end
end

Beorning.EncouragingRoar = function ()
    if LocalPlayer.MoralePercentage < 0.7 then
        local FormSkill = Beorning.BearForm()
        if FormSkill then return FormSkill end
        if Utilities.CanUseSkill("Encouraging Roar") then
            return "Encouraging Roar"
        end
    end
end

Beorning.RejuvenatingBellow = function ()
    if LocalPlayer.MoralePercentage < 0.5 then
        local FormSkill = Beorning.BearForm()
        if FormSkill then return FormSkill end
        if Utilities.CanUseSkill("Rejuvenating Bellow") then
            return "Rejuvenating Bellow"
        end
    end
end


Beorning.PreBuildWrath = function ()
    if LocalPlayer.IsInCombat == false then
        if Beorning.Wrath < 70 then
            local SkillName = nil
            SkillName = Beorning.ManForm()
            if SkillName then return SkillName end
            local PrioritySkills = {
                "Biting Edge",
                "Hearten",
            }
            SkillName = Utilities.GetPrioritySkill(PrioritySkills)
            return SkillName
        end
    end
end

--------------------------
-- Form Skill Utilities --
--------------------------
Beorning.BearForm = function ()
    if not LocalPlayer.Effects["Bear-form"] and Utilities.CanUseSkill("Bear-form") then return "Bear-form" end
end

Beorning.BearFormSkill = function (SkillName)
    if Utilities.CanUseSkill(SkillName) then
        local FormSkill = Beorning.BearForm();
        if FormSkill then return FormSkill end
        return SkillName
    end
end

Beorning.ManForm = function ()
    if not LocalPlayer.Effects["Man-form"] and Utilities.CanUseSkill("Man-form") then return "Man-form" end
end

Beorning.ManFormSkill = function (SkillName)
    if Utilities.CanUseSkill(SkillName) then
        local FormSkill = Beorning.ManForm();
        if FormSkill then return FormSkill end
        return SkillName
    end
end

---------------------------
-- Blue Helper Functions --
---------------------------

Beorning.GuardedAttack = function ()
    -- TODO: implement logic to increase this buff
end

Beorning.BlueBearDPS = function ()
    if LocalPlayer.Effects["Bear-form"] then
        local PrioritySkills = {
            "Bee Swarm",
            "Vigilant Roar",
            "Rending Blow",
            "Claw Swipe",
            "Thrash - Tier 1",
        }
        local SkillName = Utilities.GetPrioritySkill(PrioritySkills)
        return SkillName
    end
end

Beorning.BlueManDPS = function ()
    local PrioritySkills = {
        "Guarded Attack (Dual)",
        "Biting Edge",
        "Slam",
        "Thrash - Tier 1",
    }
    local SkillName = Utilities.GetPrioritySkill(PrioritySkills)
    return SkillName
end

--------------------------
-- Red Helper Functions --
--------------------------

Beorning.RedBearDPS = function ()
    if LocalPlayer.Effects["Bear-form"] then
        local PrioritySkills = {
            "Expose",
            "Bash",
            "Bee Swarm",
            "Vigilant Roar",
            "Slash",
        }
        local SkillName = Utilities.GetPrioritySkill(PrioritySkills)
        return SkillName
    end
end

Beorning.RedManDPS = function ()
    local PrioritySkills = {
        "Slash",
        "Slam",
        "Serrated Edge",
        "Biting Edge",
        "Nature's Vengeance",
    }
    local SkillName = Utilities.GetPrioritySkill(PrioritySkills)
    return SkillName
end

-----------------------------
-- Yellow Helper Functions --
-----------------------------

Beorning.YellowMark = function ()
    if Utilities.CanUseSkill("Bee Swarm") then
        if not Beorning.MarkOfBeornApplied then 
            if Utilities.CanUseSkill("Mark of Beorn") then
                return "Mark of Beorn"
            end
            return
        end
        local PrioritySkills = {
            "Bee Swarm",
        }
        local SkillName = Utilities.GetPrioritySkill(PrioritySkills)
        return SkillName
    end
end

Beorning.YellowSelfHeal = function ()
    local SkillName = nil
    if LocalPlayer.MoralePercentage < 0.7 then
        if LocalPlayer.Effects["Bear-form"] then
            if Utilities.CanUseSkill("Encouraging Roar") then return "Encouraging Roar" end
        elseif LocalPlayer.Effects["Man-form"] then
            if Utilities.CanUseSkill("Hearten") then return "Hearten" end
        end
        PrioritySkillSelectors = {
            Beorning.EncouragingRoar,
            Beorning.Hearten,
            Beorning.RejuvenatingBellow,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        if SkillName then return Beorning.Shortcuts[SkillName] end
    end
end

Beorning.YellowBearDPS = function ()
    if LocalPlayer.Effects["Bear-form"] then
        local PrioritySkills = {
            "Bee Swarm",
            "Vigilant Roar",
            "Slash",
        }
        local SkillName = Utilities.GetPrioritySkill(PrioritySkills)
        return SkillName
    end
end

Beorning.YellowManDPS = function ()
    local PrioritySkills = {
        "Vicious Claws",
        "Slam",
        "Serrated Edge",
        "Biting Edge",
        "Slash",
        "Nature's Vengeance",
    }
    local SkillName = Utilities.GetPrioritySkill(PrioritySkills)
    return SkillName
end

Beorning.GetDamageQuickslot = function ()
    if LocalPlayer.TraitLine == "Blue" then
        local PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.Hearten,
            Beorning.InitialFerociousRoar,
            Beorning.BearBeeSwarm,
            Beorning.DefaultRedDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        return Beorning.Shortcuts[SkillName]
    end

    if LocalPlayer.TraitLine == "Red" then
        local PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.Hearten,
            Beorning.InitialFerociousRoar,
            Beorning.BearBeeSwarm,
            Beorning.Expose,
            Beorning.DefaultRedDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        return Beorning.Shortcuts[SkillName]
    end


    if LocalPlayer.TraitLine == "Yellow" then
        local PrioritySkillSelectors = {
            Beorning.Cleanse,
            Beorning.EncouragingRoar,
            Beorning.Hearten,
            Beorning.InitialFerociousRoar,
            Beorning.GribeornMark,
            Beorning.DefaultYellowDPS,
        }
        SkillName = Utilities.SelectPrioritySkill(PrioritySkillSelectors)
        return Beorning.Shortcuts[SkillName]
    end
end

Beorning.GribeornMark = function ()
    if not LocalPlayer.Effects["Mark of Grimbeorn"] and Utilities.CanUseSkill("Mark of Grimbeorn") then return "Mark of Grimbeorn" end
end

Beorning.BearBeeSwarm = function ()
    if Utilities.CanUseSkill("Bee Swarm") then
        NextSkillName = Beorning.BearForm();
        if NextSkillName then return NextSkillName end
        return "Bee Swarm";
    end
end

Beorning.InitialFerociousRoar = function ()
    if Beorning.Wrath == 0 and Utilities.CanUseSkill("Ferocious Roar") then return "Ferocious Roar" end
end

Beorning.Cleanse = function ()
    if LocalPlayer.CanCure and Utilities.CanUseSkill("Cleanse") then return "Cleanse" end
end

Beorning.Expose = function ()
    if (LocalPlayer.Skills["Expose (Man)"].LastUsed + 13 < Turbine.Engine.GetGameTime()) and Utilities.CanUseSkill("Expose (Man)") then
        NextSkillName = Beorning.BearForm()
        if NextSkillName then return NextSkillName end
        return "Expose"
    end
end

Beorning.DefaultRedDPS = function()
    local PrioritySkills = {
        "Bash",
        "Slash",
        "Slam",
        "Biting Edge",
    }
    return Utilities.GetPrioritySkill(PrioritySkills);
end

Beorning.ClawSwipe = function ()
    return Beorning.BearFormSkill("Claw Swipe")
end

Beorning.BitingEdge = function ()
    if Utilities.CanUseSkill("Biting Edge") then
        NextSkillName = Beorning.ManForm()
        if NextSkillName then return NextSkillName end
        return "Biting Edge"
    end 
end

Beorning.Slam = function ()
    if Utilities.CanUseSkill("Slam") then
        NextSkillName = Beorning.ManForm()
        if NextSkillName then return NextSkillName end
        return "Slam"
    end
    return Beorning.ManFormSkill("Slam")
end

Beorning.Thrash = function()
    return Beorning.BearFormSkill("Thrash - Tier 1")
end

Beorning.Hearten = function ()
    if not (LocalPlayer.MoralePercentage < 0.7 or Beorning.Wrath < 50) then return end
    local FormSkill = Beorning.ManForm()
    if FormSkill then return FormSkill end
    if Utilities.CanUseSkill("Hearten") then
        return "Hearten"
    end
end

Beorning.DefaultYellowDPS = function()
    local PrioritySkills = {
        "Bee Swarm",
        "Vicious Claws",
        "Biting Edge",
        "Slam",
        "Slash",
    }
    return Utilities.GetPrioritySkill(PrioritySkills);
end

Beorning.UpdateWrath = function()
    Beorning.Wrath = LocalPlayer.ClassAttributesInstance:GetWrath()
end

Beorning.UpdateTraitLine = function ()
    TraitLine = "Blue"
    if LocalPlayer.Skills["Bash"] ~= nil then
        TraitLine = "Red"
    elseif LocalPlayer.Skills["Mark of Grimbeorn"] ~= nil then
        TraitLine = "Yellow"
    end
    LocalPlayer.TraitLine = TraitLine
end

----------------------------------
-- PlayerClasses Initialization --
----------------------------------
PlayerClasses = PlayerClasses or {};
PlayerClasses.Beorning = Beorning;