/*G-Olf Player Inventory*/

local Inventory = vgui.Create( "DFrame" )
Inventory:SetSize( ScrW() / 3, ScrH() / 2.11 )
Inventory:Center()
Inventory:SetTitle( "Inventory" )
Inventory:SetVisible( false )
Inventory:ShowCloseButton( false )
Inventory:SetDraggable( false )
Inventory:MakePopup()

Inventory.PropertySheet = vgui.Create( "DPropertySheet", Inventory )
Inventory.PropertySheet:SetSize( Inventory:GetWide() - 2, Inventory:GetTall() - 27 )
Inventory.PropertySheet:SetPos( 1, 25 )

local Clubs = vgui.Create( "DPanel", Inventory.PropertySheet )
Clubs.Slots = {}

Clubs.Items = vgui.Create( "DScrollPanel", Clubs )
Clubs.Items:Dock( FILL )
local VBar = Clubs.Items:GetVBar()
function Clubs.Items:OnScrollbarAppear()
	VBar:SetSize( 0, 0 )
end
Clubs.Items.Selected = nil

Clubs.Items.DIconLayout = vgui.Create( "DIconLayout", Clubs.Items )
Clubs.Items.DIconLayout:SetSize( Inventory.PropertySheet:GetWide() / 2 - 1, Inventory.PropertySheet:GetTall() - 2 )
Clubs.Items.DIconLayout:SetPos( 1, 1 )
Clubs.Items.DIconLayout:SetSpaceX( 2 )
Clubs.Items.DIconLayout:SetSpaceY( 2 )

local Categories = {
	"Wood",
	"Iron",
	"Wedge",
	"Putter",
	"Utilities"
}

for i = 1, 5 do
	Clubs.Slots[i] = vgui.Create( "DPanel", Clubs )
	Clubs.Slots[i]:SetSize( Inventory.PropertySheet:GetWide() / 10.2, 62 )
	Clubs.Slots[i]:SetPos( Clubs.Slots[i]:GetWide() * ( i - 1 ) + ( i + i ) - 1, Inventory.PropertySheet:GetTall() - Clubs.Slots[i]:GetTall() * 1.59 )
	Clubs.Slots[i]:SetBackgroundColor( Color( 200, 200, 200 ) )
end

/*for i = 1, 17 do
	local Item = Clubs.Items.DIconLayout:Add( vgui.Create( "DPanel" ) )
	Item:SetSize( 62, 62 )
	Item:SetBackgroundColor( Color( 200, 255, 200 ) )
	Item.Selected = function( self )
		Item:SetBackgroundColor( Color( 255, 255, 180 ) )
				
		Clubs.ModelPanel:SetModel( Item.ModelPanel:GetModel() )
		
		Clubs.Stats.Name:SetText( "Name: " .. Item.ModelPanel:GetModel() )
		Clubs.Stats.Type:SetText( "Type: " .. Item.ModelPanel:GetModel() )
	end
	
	Item.ModelPanel = vgui.Create( "DModelPanel", Item )
	Item.ModelPanel:SetSize( Item:GetWide() - 2, Item:GetTall() - 2 )
	Item.ModelPanel:SetPos( 1, 1 )
	Item.ModelPanel:SetModel( "models/clubs/glf_putter/glf_putter.mdl" )
	Item.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
	Item.ModelPanel:SetCamPos( Item.ModelPanel.Entity:GetPos() - Vector( 15, 1, 0 ) )
	function Item.ModelPanel:LayoutEntity( Entity )
		Item.ModelPanel.Entity:SetAngles( Angle( 0, 90, 0 ) )
		return 
	end
	
	function Item.ModelPanel:OnMousePressed( code )
		if ( code == MOUSE_LEFT ) then
			Item.WasPressed = true
		end
	end
	function Item.ModelPanel:OnMouseReleased( code )
		if ( code == MOUSE_LEFT && Item.WasPressed ) then // Checking if this item was pressed first before the mouse was released over it
			Item.WasPressed = false
			
			if ( Clubs.Items.Selected == nil ) then // If there is no currently selected item
				Clubs.Items.Selected = Item // New selected item
				
				Item.Selected()
			elseif ( Clubs.Items.Selected ~= nil && Clubs.Items.Selected ~= Item ) then // If there is a currently selected item and it isn't this item
				Clubs.Items.Selected:SetBackgroundColor( Color( 200, 255, 200 ) ) // Previous selected item
				Clubs.Items.Selected = Item // New selected item
				
				Item.Selected()
			end
		end
	end
	function Item.ModelPanel:OnCursorExited()
		if ( Item.WasPressed ) then
			Item.WasPressed = false
		end
	end
end*/

Clubs.ModelPanelOutline = vgui.Create( "DPanel", Clubs )
Clubs.ModelPanelOutline:SetSize( Inventory.PropertySheet:GetWide() / 2 - 18, Inventory.PropertySheet:GetTall() / 2 + 1 )
Clubs.ModelPanelOutline:SetPos( Inventory.PropertySheet:GetWide() / 2 + 1, 1 )
Clubs.ModelPanelOutline:SetBackgroundColor( Color( 20, 20, 20 ) )

Clubs.ModelPanelFill = vgui.Create( "DPanel", Clubs.ModelPanelOutline )
Clubs.ModelPanelFill:SetSize( Clubs.ModelPanelOutline:GetWide() - 2, Clubs.ModelPanelOutline:GetTall() - 2 )
Clubs.ModelPanelFill:SetPos( 1, 1 )

Clubs.ModelPanel = vgui.Create( "DModelPanel", Clubs.ModelPanelFill )
Clubs.ModelPanel:SetSize( Clubs.ModelPanelFill:GetWide(), Clubs.ModelPanelFill:GetTall() )
Clubs.ModelPanel:SetPos( 0, 0 )
Clubs.ModelPanel:SetModel( "models/weapons/w_smg1.mdl" )
Clubs.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
Clubs.ModelPanel:SetCamPos( Clubs.ModelPanel.Entity:GetPos() - Vector( 17, 1, 0 ) )

Clubs.StatsOutline = vgui.Create( "DPanel", Clubs )
Clubs.StatsOutline:SetSize( Inventory.PropertySheet:GetWide() / 2 - 18, Inventory.PropertySheet:GetTall() / 2 - 38 )
Clubs.StatsOutline:SetPos( Inventory.PropertySheet:GetWide() / 2 + 1, Inventory.PropertySheet:GetTall() / 2 + 1 )
Clubs.StatsOutline:SetBackgroundColor( Color( 20, 20, 20 ) )

Clubs.Stats = vgui.Create( "DPanel", Clubs.StatsOutline )
Clubs.Stats:SetSize( Clubs.StatsOutline:GetWide() - 2, Clubs.StatsOutline:GetTall() - 2 )
Clubs.Stats:SetPos( 1, 1 )

Clubs.Stats.Header = vgui.Create( "DLabel", Clubs.Stats )
Clubs.Stats.Header:SetSize( Clubs.Stats:GetWide(), 20 )
Clubs.Stats.Header:SetPos( 1, 1 )
Clubs.Stats.Header:SetDark( true )
Clubs.Stats.Header:SetFont( "HudSelectionText" )
Clubs.Stats.Header:SetContentAlignment( 5 )
Clubs.Stats.Header:SetText( "Stats" )

Clubs.Stats.Name = vgui.Create( "DLabel", Clubs.Stats )
Clubs.Stats.Name:SetSize( Clubs.Stats:GetWide(), 20 )
Clubs.Stats.Name:SetPos( 1, 21 )
Clubs.Stats.Name:SetDark( true )
Clubs.Stats.Name:SetFont( "HudSelectionText" )
Clubs.Stats.Name:SetContentAlignment( 4 )
Clubs.Stats.Name:SetText( "Name: " )

Clubs.Stats.Type = vgui.Create( "DLabel", Clubs.Stats )
Clubs.Stats.Type:SetSize( Clubs.Stats:GetWide(), 20 )
Clubs.Stats.Type:SetPos( 1, 41 )
Clubs.Stats.Type:SetDark( true )
Clubs.Stats.Type:SetFont( "HudSelectionText" )
Clubs.Stats.Type:SetContentAlignment( 4 )
Clubs.Stats.Type:SetText( "Type: " )

Clubs.Stats.Loft_Angle = vgui.Create( "DLabel", Clubs.Stats )
Clubs.Stats.Loft_Angle:SetSize( Clubs.Stats:GetWide(), 20 )
Clubs.Stats.Loft_Angle:SetPos( 1, 61 )
Clubs.Stats.Loft_Angle:SetDark( true )
Clubs.Stats.Loft_Angle:SetFont( "HudSelectionText" )
Clubs.Stats.Loft_Angle:SetContentAlignment( 4 )
Clubs.Stats.Loft_Angle:SetText( "Loft Angle: " )

Clubs.Stats.Range = vgui.Create( "DLabel", Clubs.Stats )
Clubs.Stats.Range:SetSize( Clubs.Stats:GetWide(), 20 )
Clubs.Stats.Range:SetPos( 1, 81 )
Clubs.Stats.Range:SetDark( true )
Clubs.Stats.Range:SetFont( "HudSelectionText" )
Clubs.Stats.Range:SetContentAlignment( 4 )
Clubs.Stats.Range:SetText( "Range: " )

Clubs.Stats.Description = vgui.Create( "DLabel", Clubs.Stats )
Clubs.Stats.Description:SetSize( Clubs.Stats:GetWide(), Clubs.Stats:GetTall() / 2 )
Clubs.Stats.Description:SetPos( 1, 101 )
Clubs.Stats.Description:SetDark( true )
Clubs.Stats.Description:SetFont( "HudSelectionText" )
Clubs.Stats.Description:SetContentAlignment( 7 )
Clubs.Stats.Description:SetWrap( true )
Clubs.Stats.Description:SetText( "Description: " )

Inventory.PropertySheet:AddSheet( "Clubs", Clubs, "icon16/club.png" )

--[[ 
	Balls
		- Materials
		- Trails
		- Stats
]]--
local Balls = vgui.Create( "DPanel", Inventory.PropertySheet )

Balls.Items = vgui.Create( "DScrollPanel", Balls )
Balls.Items:Dock( FILL )
local VBar = Balls.Items:GetVBar()
function Balls.Items:OnScrollbarAppear()
	VBar:SetSize( 0, 0 )
end
Balls.Items.Selected = nil

Balls.Items.DIconLayout = vgui.Create( "DIconLayout", Balls.Items )
Balls.Items.DIconLayout:SetSize( Inventory.PropertySheet:GetWide() / 2 - 1, Inventory.PropertySheet:GetTall() - 2 )
Balls.Items.DIconLayout:SetPos( 1, 1 )
Balls.Items.DIconLayout:SetSpaceX( 2 )
Balls.Items.DIconLayout:SetSpaceY( 2 )

for i = 1, 17 do
	local Item = Balls.Items.DIconLayout:Add( vgui.Create( "DPanel" ) )
	Item:SetSize( 62, 62 )
	Item:SetBackgroundColor( Color( 200, 255, 200 ) )
	Item.Selected = function( self )
		Item:SetBackgroundColor( Color( 255, 255, 180 ) )
				
		Balls.ModelPanel:SetModel( Item.ModelPanel:GetModel() )
		
		Balls.Stats.Name:SetText( "Name: " .. Item.ModelPanel:GetModel() )
		Balls.Stats.Type:SetText( "Type: " .. Item.ModelPanel:GetModel() )
	end
	
	Item.ModelPanel = vgui.Create( "DModelPanel", Item )
	Item.ModelPanel:SetSize( Item:GetWide() - 2, Item:GetTall() - 2 )
	Item.ModelPanel:SetPos( 1, 1 )
	Item.ModelPanel:SetModel( "models/golf_ball/golf_ball.mdl" )
	Item.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
	Item.ModelPanel:SetCamPos( Item.ModelPanel.Entity:GetPos() - Vector( 7, 0, -1.5 ) )
	function Item.ModelPanel:LayoutEntity( Entity )
		return 
	end
	
	function Item.ModelPanel:OnMousePressed( code )
		if ( code == MOUSE_LEFT ) then
			Item.WasPressed = true
		end
	end
	function Item.ModelPanel:OnMouseReleased( code )
		if ( code == MOUSE_LEFT && Item.WasPressed ) then // Checking if this item was pressed first before the mouse was released over it
			Item.WasPressed = false
			
			if ( Balls.Items.Selected == nil ) then // If there is no currently selected item
				Balls.Items.Selected = Item // New selected item
				
				Item.Selected()
			elseif ( Balls.Items.Selected ~= nil && Balls.Items.Selected ~= Item ) then // If there is a currently selected item and it isn't this item
				Balls.Items.Selected:SetBackgroundColor( Color( 200, 255, 200 ) ) // Previous selected item
				Balls.Items.Selected = Item // New selected item
				
				Item.Selected()
			end
		end
	end
	function Item.ModelPanel:OnCursorExited()
		if ( Item.WasPressed ) then
			Item.WasPressed = false
		end
	end
end

Balls.ModelPanelOutline = vgui.Create( "DPanel", Balls )
Balls.ModelPanelOutline:SetSize( Inventory.PropertySheet:GetWide() / 2 - 18, Inventory.PropertySheet:GetTall() / 2 + 1 )
Balls.ModelPanelOutline:SetPos( Inventory.PropertySheet:GetWide() / 2 + 1, 1 )
Balls.ModelPanelOutline:SetBackgroundColor( Color( 20, 20, 20 ) )

Balls.ModelPanelFill = vgui.Create( "DPanel", Balls.ModelPanelOutline )
Balls.ModelPanelFill:SetSize( Balls.ModelPanelOutline:GetWide() - 2, Balls.ModelPanelOutline:GetTall() - 2 )
Balls.ModelPanelFill:SetPos( 1, 1 )

Balls.ModelPanel = vgui.Create( "DModelPanel", Balls.ModelPanelFill )
Balls.ModelPanel:SetSize( Balls.ModelPanelFill:GetWide(), Balls.ModelPanelFill:GetTall() )
Balls.ModelPanel:SetPos( 0, 0 )
Balls.ModelPanel:SetModel( "models/golf_ball/golf_ball.mdl" )
Balls.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
Balls.ModelPanel:SetCamPos( Balls.ModelPanel.Entity:GetPos() - Vector( 8, 0, -1.5 ) )

Balls.StatsOutline = vgui.Create( "DPanel", Balls )
Balls.StatsOutline:SetSize( Inventory.PropertySheet:GetWide() / 2 - 18, Inventory.PropertySheet:GetTall() / 2 - 38 )
Balls.StatsOutline:SetPos( Inventory.PropertySheet:GetWide() / 2 + 1, Inventory.PropertySheet:GetTall() / 2 + 1 )
Balls.StatsOutline:SetBackgroundColor( Color( 20, 20, 20 ) )

Balls.Stats = vgui.Create( "DPanel", Balls.StatsOutline )
Balls.Stats:SetSize( Balls.StatsOutline:GetWide() - 2, Balls.StatsOutline:GetTall() - 2 )
Balls.Stats:SetPos( 1, 1 )

Balls.Stats.Header = vgui.Create( "DLabel", Balls.Stats )
Balls.Stats.Header:SetSize( Balls.Stats:GetWide(), 20 )
Balls.Stats.Header:SetPos( 1, 1 )
Balls.Stats.Header:SetDark( true )
Balls.Stats.Header:SetFont( "HudSelectionText" )
Balls.Stats.Header:SetContentAlignment( 5 )
Balls.Stats.Header:SetText( "Stats" )

Balls.Stats.Name = vgui.Create( "DLabel", Balls.Stats )
Balls.Stats.Name:SetSize( Balls.Stats:GetWide(), 20 )
Balls.Stats.Name:SetPos( 1, 21 )
Balls.Stats.Name:SetDark( true )
Balls.Stats.Name:SetFont( "HudSelectionText" )
Balls.Stats.Name:SetContentAlignment( 4 )
Balls.Stats.Name:SetText( "Name: " )

Balls.Stats.Type = vgui.Create( "DLabel", Balls.Stats )
Balls.Stats.Type:SetSize( Balls.Stats:GetWide(), 20 )
Balls.Stats.Type:SetPos( 1, 41 )
Balls.Stats.Type:SetDark( true )
Balls.Stats.Type:SetFont( "HudSelectionText" )
Balls.Stats.Type:SetContentAlignment( 4 )
Balls.Stats.Type:SetText( "Type: " )

Balls.Stats.Loft_Angle = vgui.Create( "DLabel", Balls.Stats )
Balls.Stats.Loft_Angle:SetSize( Balls.Stats:GetWide(), 20 )
Balls.Stats.Loft_Angle:SetPos( 1, 61 )
Balls.Stats.Loft_Angle:SetDark( true )
Balls.Stats.Loft_Angle:SetFont( "HudSelectionText" )
Balls.Stats.Loft_Angle:SetContentAlignment( 4 )
Balls.Stats.Loft_Angle:SetText( "Loft Angle: " )

Balls.Stats.Range = vgui.Create( "DLabel", Balls.Stats )
Balls.Stats.Range:SetSize( Balls.Stats:GetWide(), 20 )
Balls.Stats.Range:SetPos( 1, 81 )
Balls.Stats.Range:SetDark( true )
Balls.Stats.Range:SetFont( "HudSelectionText" )
Balls.Stats.Range:SetContentAlignment( 4 )
Balls.Stats.Range:SetText( "Range: " )

Balls.Stats.Description = vgui.Create( "DLabel", Balls.Stats )
Balls.Stats.Description:SetSize( Balls.Stats:GetWide(), Balls.Stats:GetTall() / 2 )
Balls.Stats.Description:SetPos( 1, 101 )
Balls.Stats.Description:SetDark( true )
Balls.Stats.Description:SetFont( "HudSelectionText" )
Balls.Stats.Description:SetContentAlignment( 7 )
Balls.Stats.Description:SetWrap( true )
Balls.Stats.Description:SetText( "Description: " )

Inventory.PropertySheet:AddSheet( "Balls", Balls, "icon16/ball.png" )

local Carts = vgui.Create( "DPanel", Inventory.PropertySheet )

Inventory.PropertySheet:AddSheet( "Carts", Carts, "icon16/new_cart.png" )

local Outfit = vgui.Create( "DPanel", Inventory.PropertySheet )

Inventory.PropertySheet:AddSheet( "Outfit", Outfit, "icon16/shirt.png" )

--[[ 
	Settings
		- Ball Colour
		- Cart Colour
		- Tee Colour
]]--
local Settings = vgui.Create( "DPanel", Inventory.PropertySheet )

Settings.PreferredHand = vgui.Create( "DLabel", Settings )
Settings.PreferredHand:SetSize( Inventory.PropertySheet:GetWide() / 5, 20 )
Settings.PreferredHand:SetPos( 1, 1 )
Settings.PreferredHand:SetDark( true )
Settings.PreferredHand:SetText( "Preferred Hand:" )

Settings.PreferredHandChoice = vgui.Create( "DComboBox", Settings )
Settings.PreferredHandChoice:SetSize( Inventory.PropertySheet:GetWide() / 8, 20 )
Settings.PreferredHandChoice:SetPos( Inventory.PropertySheet:GetWide() / 8, 1 )
Settings.PreferredHandChoice:SetText( "Right" )
Settings.PreferredHandChoice:AddChoice( "Left" )
Settings.PreferredHandChoice.OnSelect = function( panel, index, value )
	if ( value == "Left" ) then
		g_olf.Preferred_Hand = "Left"
		
		Settings.PreferredHandChoice:Clear()
		
		Settings.PreferredHandChoice:SetText( "Left" )
		Settings.PreferredHandChoice:AddChoice( "Right" )
	elseif ( value == "Right" ) then
		g_olf.Preferred_Hand = "Right"
		
		Settings.PreferredHandChoice:Clear()
		
		Settings.PreferredHandChoice:SetText( "Right" )
		Settings.PreferredHandChoice:AddChoice( "Left" )
	end
end

Settings.Aim_Line = vgui.Create( "DCheckBoxLabel", Settings )
Settings.Aim_Line:SetPos( 1, 22 )
Settings.Aim_Line:SetText( "Aim Line" )
Settings.Aim_Line.Label:SetDark( true )
Settings.Aim_Line:SetToolTip( "Displays a line to show where you are facing while taking a shot." )
Settings.Aim_Line:SetChecked( false )
function Settings.Aim_Line:OnChange( bVal )
	Settings.Aim_Line:SetChecked( bVal )
end

Settings.Player_Names = vgui.Create( "DCheckBoxLabel", Settings )
Settings.Player_Names:SetPos( 1, 39 )
Settings.Player_Names:SetText( "Player Names" )
Settings.Player_Names.Label:SetDark( true )
Settings.Player_Names:SetToolTip( "Shows player names." )
Settings.Player_Names:SetChecked( true )
function Settings.Player_Names:OnChange( bVal )
	g_olf.Show_Names = bVal
end

Inventory.PropertySheet:AddSheet( "Settings", Settings, "icon16/new_cog.png" )

function InventoryOpen()
	RestoreCursorPosition()
	Inventory:SetVisible( true )
end
concommand.Add( "+menu", InventoryOpen )

function InventoryClose()
	RememberCursorPosition()
	Inventory:SetVisible( false )
end
concommand.Add( "-menu", InventoryClose )