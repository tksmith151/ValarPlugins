import "Turbine";
import "Turbine.UI.Lotro";

local PluginName = "ValarPlugin";
local PluginApartment = "ValarPluginApartment";

ManagerWindow = nil;

function LauchManagerWindow()
    if ManagerWindow == nil then
        ManagerWindow = Turbine.UI.Window();
        --ManagerWindow = Turbine.UI.LOTRO.Window();
        ManagerWindow:SetPosition(Turbine.UI.Display:GetWidth()-434,Turbine.UI.Display:GetHeight()-172);
        ManagerWindow:SetSize(200, 170);
        --ManagerWindow:SetText("Manager");
        ManagerWindow:SetVisible( true );

        --RefreshButton = Turbine.UI.Lotro.Button();
        --RefreshButton:SetParent(ManagerWindow);
        --RefreshButton:SetText("Refresh Plugins");
        --RefreshButton:SetPosition( 30, 40 );
        --RefreshButton:SetSize( 140, 20 );
        --RefreshButton.Click = function(sender, args)
        --    Turbine.PluginManager.RefreshAvailablePlugins();
        --    UpdateButtons();
        --end

        LoadButton = Turbine.UI.Lotro.Button();
        LoadButton:SetParent(ManagerWindow);
        LoadButton:SetText("Load Plugin");
        --LoadButton:SetPosition( 30, 70 );
        LoadButton:SetPosition( 30, 130 );
        LoadButton:SetSize( 140, 20 );
        LoadButton.Click = function(sender, args)
            Turbine.PluginManager.LoadPlugin(PluginName);
            UpdateButtons();
        end

        --ReloadButton = Turbine.UI.Lotro.Button();
        --ReloadButton:SetParent(ManagerWindow);
        --ReloadButton:SetText("Reload Plugin");
        --ReloadButton:SetPosition( 30, 100 );
        --ReloadButton:SetSize( 140, 20 );
        --ReloadButton.Click = function(sender, args)
        --    Turbine.PluginManager.UnloadScriptState(PluginApartment)
        --    Turbine.PluginManager.LoadPlugin(PluginName);
        --    UpdateButtons();
        --end

        UnloadButton = Turbine.UI.Lotro.Button();
        UnloadButton:SetParent(ManagerWindow);
        UnloadButton:SetText("Unload Plugin");
        UnloadButton:SetPosition( 30, 130 );
        UnloadButton:SetSize( 140, 20 );
        UnloadButton.Click = function(sender, args)
            Turbine.PluginManager.UnloadScriptState(PluginApartment)
            UpdateButtons();
        end
    end
end

function UpdateButtons()
    local AvailablePlugins = Turbine.PluginManager.GetAvailablePlugins();
    local LoadedPlugins = Turbine.PluginManager.GetLoadedPlugins();
    local PluginIsAvailable = false;
    local PluginIsLoaded = false;
    for _, Plugin in ipairs(AvailablePlugins) do
        if Plugin.Name == PluginName then
            PluginIsAvailable = true;
        end
    end
    for _, Plugin in ipairs(LoadedPlugins) do
        if Plugin.Name == PluginName then
            PluginIsLoaded = true;
        end
    end
    --RefreshButton:SetEnabled(false);
    LoadButton:SetVisible(false);
    --ReloadButton:SetEnabled(false);
    UnloadButton:SetVisible(false);
    if PluginIsLoaded then
        --ReloadButton:SetEnabled(true);
        UnloadButton:SetVisible(true);
    elseif PluginIsAvailable and not PluginIsLoaded then
        LoadButton:SetVisible(true);
    else
        --RefreshButton:SetEnabled(true);
    end
end

LauchManagerWindow();
UpdateButtons();

