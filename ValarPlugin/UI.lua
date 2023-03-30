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

UI.DumpWindow = class(Turbine.UI.Lotro.Window);
function UI.DumpWindow:Constructor()
    Turbine.UI.Window.Constructor(self);
    self:SetVisible(true);
    self:SetSize(450,100);
    self:SetPosition(((Turbine.UI.Display.GetWidth()/2)-(self:GetWidth()/2)),((Turbine.UI.Display.GetHeight()/3)-(self:GetHeight()/2)));
    self:SetVisible(true);
    self:SetText("Lotro API Table Dump");

    self.TextEnter = Turbine.UI.TextBox();
    self.TextEnter:SetParent(self);
    self.TextEnter:SetSize(350,20);
    self.TextEnter:SetPosition(20,50);
    self.TextEnter:SetMultiline(false);
    self.TextEnter:SetSelectable(true);
    self.TextEnter:SetVisible(true);
    self.TextEnter:SetBackColor(Turbine.UI.Color(1,1,1));
    self.TextEnter:SetForeColor(Turbine.UI.Color(0,0,0));
    self.TextEnter:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);

    self.DumpButton = Turbine.UI.Lotro.Button();
    self.DumpButton:SetParent(self);
    self.DumpButton:SetSize(50,20);
    self.DumpButton:SetPosition(380,50);
    self.DumpButton:SetVisible(true);
    self.DumpButton:SetText("Dump");
    self.DumpButton.MouseClick = function (sender, args)
        local dumpString = self.TextEnter:GetText();
        Turbine.Shell.WriteLine("\n" .. dumpString);
        Turbine.Shell.WriteLine(Dump(FindKey(dumpString),0));
        Turbine.PluginData.Save(Turbine.DataScope.Server,"tabledump",Dump(FindKey(dumpString),0),nil)
    end
end

function FindKey(key)
	local dotCount = 0;
	local stringLen = string.len(key);
	for i=1, stringLen, 1 do
		local curChar = string.sub(key, i, i)
		if curChar == "." then dotCount = dotCount+1 end;
	end
	local numKeys = dotCount + 1;
	local keySegs = {};
	local newDotLocation = 0;
	local oldDotLocation = 0;
	for i=1, numKeys, 1 do
		if numKeys > 1 then
			newDotLocation = string.find(key, "%.", oldDotLocation+1);
			if newDotLocation == nil then
				keySegs[i] = string.sub(key, oldDotLocation+1, stringLen);
			else
				keySegs[i] = string.sub(key, oldDotLocation+1, newDotLocation-1);
			end
			oldDotLocation = newDotLocation;
		else
			keySegs[1] = key;
		end
	end
	local t = {};
	t = Turbine;
	if numKeys > 1 then
		for i=2, numKeys, 1 do
			for k,v in pairs(t) do
				if k == keySegs[i] then
					t = v;
				end;
			end
		end
	end
	return t;
end


function Dump(object, depth)
    newline = "\n" .. string.rep("    ", depth+1)
    -- whitespace = ""
    if type(object) == 'table' then
        local outputString = '{'
        for key,value in pairs(object) do
                if type(key) ~= 'number' then key = '"'..key..'"' end
                outputString = outputString .. newline .. '['..key..'] = ' .. Dump(value, depth+1) ..','
        end
        return outputString .. newline .. '}'
    else
        return '"'..tostring(object)..'"'
    end
end