UI = {}

UI.QuickslotWindow = class(Turbine.UI.Window);
function UI.QuickslotWindow:Constructor(PositionX, PositionY, QuickslotsSize)
    Turbine.UI.Window.Constructor(self);
    self:SetVisible(true);
    self.QuickslotSize = QuickslotsSize
    self.QuickslotInfo = {}
    for Index=1,QuickslotsSize do
        self.QuickslotInfo[Index] = {};
        self.QuickslotInfo[Index].LastBlocked = Turbine.Engine.GetGameTime();
    end
    self.Blockslots = {}
    self.Quickslots = {}
    for Index, Value in ipairs(self.QuickslotInfo) do
        local Mark = Index - 2
        local QuickslotPositionX = (Mark % 2) * 36
        local QuickslotPositionY = ((Mark / 2) + ((Mark % 2) / 2)) * 36
        -- Blockslots
        self.Blockslots[Index] = Turbine.UI.Lotro.Quickslot();
        self.Blockslots[Index]:SetParent(self);
        self.Blockslots[Index]:SetSize(36,36);
        self.Blockslots[Index]:SetPosition(QuickslotPositionX,QuickslotPositionY);
        self.Blockslots[Index]:SetZOrder(1);
        self.Blockslots[Index]:SetShortcut(Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Undefined, "" ));
        self.Blockslots[Index].MouseClick = function(sender, args)
            if (args.Button == Turbine.UI.MouseButton.Right) then
                self.Quickslots[Index]:SetZOrder(2);
            end
        end
        self.Blockslots[Index].MouseLeave = function(sender, args)
            self.Quickslots[Index]:SetZOrder(2);
        end
        -- Quickslots
        self.Quickslots[Index] = Turbine.UI.Lotro.Quickslot();
        self.Quickslots[Index]:SetParent(self);
        self.Quickslots[Index]:SetSize(36,36);
        self.Quickslots[Index]:SetPosition(QuickslotPositionX,QuickslotPositionY);
        self.Quickslots[Index]:SetZOrder(2);
        self.Quickslots[Index]:SetShortcut(Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Undefined, "" ));
        self.Quickslots[Index].MouseClick = function(sender, args)
            self.QuickslotInfo[Index].LastBlocked = Turbine.Engine.GetGameTime();
            self.Quickslots[Index]:SetZOrder(0);
        end
        self.Quickslots[Index].ShortcutChanged = function(sender, args)
            self.Quickslots[Index]:SetZOrder(2);
        end
    end
    --[[ Debug
    self.DebugQuickslot = Turbine.UI.Lotro.Quickslot();
    self.DebugQuickslot:SetParent(self);
    self.DebugQuickslot:SetSize(36,36);
    self.DebugQuickslot:SetPosition(18,144);
    self.DebugQuickslot:SetVisible(true);
    self.DebugQuickslot:SetShortcut(Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Undefined, "" ));
    self.DebugButton = Turbine.UI.Lotro.Button();
    self.DebugButton:SetParent(self);
    self.DebugButton:SetText("Debug");
    self.DebugButton:SetPosition( 0, 184 );
    self.DebugButton:SetSize( 72, 20 );
    self.DebugButton:SetEnabled(true);
    self.DebugButton.Click = function(sender, args)
        debug();
    end]]
    self:SetHeight((#self.QuickslotInfo / 2) * 36)
    self:SetWidth(78)
    self:SetPosition(PositionX,PositionY);
    self:SetVisible(true);
    self:SetOpacity(1);
end

function UI.QuickslotWindow:SetQuickslot(Index, ShortcutData)
    if ShortcutData~=nil then
        self.Quickslots[Index]:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Skill, ShortcutData));
    else
        self.Quickslots[Index]:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Undefined, "" ));
    end
end

function UI.QuickslotWindow:UnblockQuickslot(Index, TimeDelay)
    if self.QuickslotInfo[Index].LastBlocked + TimeDelay < Turbine.Engine.GetGameTime() then
        self.Quickslots[Index]:SetZOrder(2);
    end
end

UI.DebugWindow = class(Turbine.UI.Window);
function UI.DebugWindow:Constructor()
    Turbine.UI.Window.Constructor(self);
    self:SetVisible(true);
    self.DebugQuickslot = Turbine.UI.Lotro.Quickslot();
    self.DebugQuickslot:SetParent(self);
    self.DebugQuickslot:SetSize(36,36);
    self.DebugQuickslot:SetPosition(18,0);
    self.DebugQuickslot:SetVisible(true);
    self.DebugQuickslot:SetShortcut(Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Undefined, "" ));
    self.DebugButton = Turbine.UI.Lotro.Button();
    self.DebugButton:SetParent(self);
    self.DebugButton:SetText("Debug");
    self.DebugButton:SetPosition( 0, 40 );
    self.DebugButton:SetSize( 72, 20 );
    self.DebugButton:SetEnabled(true);
    self.DebugButton.Click = function(sender, args)
        debug();
    end
    self:SetHeight(78)
    self:SetWidth(78)
    self:SetPosition(1276,956);
    self:SetVisible(true);
    self:SetOpacity(1);
end