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

local function ClubDrop( self, panels, bDoDrop, Command, x, y )
	if ( bDoDrop ) then
		for k, v in pairs( panels ) do
			if ( !IsValid( v ) ) then continue end
			
			local old_panel = v.ID ~= nil && Clubs.Slots[v.ID] or Clubs.Items.DIconLayout
			
			if ( self.ID ~= nil ) then
				if ( self.Current_Item == nil ) then
					local Item = self:Add( v )
					Item:SetPos( 0, 0 )
					Item.ID = self.ID
					
					self.Current_Item = Item
					
					old_panel.Current_Item = nil
				else
					if ( v.ID ~= 0 ) then
						local Item = self:Add( v )
						Item:SetPos( 0, 0 )
						
						local Old_Item = old_panel:Add( self.Current_Item )
						old_panel.Current_Item = self.Current_Item
						Old_Item.ID = old_panel.ID
						
						Item.ID = self.ID
						self.Current_Item = Item
					end
				end
			else
				local Item = self:Add( v )
				Item.ID = 0
				
				old_panel.Current_Item = nil
			end
		end
	end
end

Clubs.Items = vgui.Create( "DScrollPanel", Clubs )
Clubs.Items:SetSize( Inventory.PropertySheet:GetWide(), Inventory.PropertySheet:GetTall() - 64 )
local VBar = Clubs.Items:GetVBar()
function Clubs.Items:OnScrollbarAppear()
	VBar:SetSize( 0, 0 )
end
Clubs.Items.Selected = nil

Clubs.Items.DIconLayout = vgui.Create( "DIconLayout", Clubs.Items )
Clubs.Items.DIconLayout:SetSize( Inventory.PropertySheet:GetWide() / 2 - 1, Inventory.PropertySheet:GetTall() - 2 )
Clubs.Items.DIconLayout:SetPos( 1, 1 )
Clubs.Items.DIconLayout:Receiver( "Club", ClubDrop )
Clubs.Items.DIconLayout:SetSpaceX( 2 )
Clubs.Items.DIconLayout:SetSpaceY( 2 )

local Categories = {
	"Wood",
	"Iron",
	"Wedge",
	"Putter",
	"Utilities"
}

function Clubs.Items.DIconLayout.NewItem( skin )
	local Item = Clubs.Items.DIconLayout:Add( vgui.Create( "DImage" ) )
	Item:SetSize( 62, 62 )
	Item:SetKeepAspect( false )
	Item:SetImage( "inventory/balls/placeholder.png" )
	Item:Droppable( "Club" )
	Item.ID = 0
end

for i = 1, 10 do
	Clubs.Items.DIconLayout.NewItem( "skree" )
end

for i = 1, 5 do
	Clubs.Slots[i] = vgui.Create( "DPanel", Clubs )
	Clubs.Slots[i]:SetSize( Inventory.PropertySheet:GetWide() / 10.2, 62 )
	Clubs.Slots[i]:SetPos( Clubs.Slots[i]:GetWide() * ( i - 1 ) + ( i + i ) - 1, Inventory.PropertySheet:GetTall() - Clubs.Slots[i]:GetTall() * 1.59 )
	Clubs.Slots[i]:Receiver( "Club", ClubDrop )
	Clubs.Slots[i]:SetBackgroundColor( Color( 200, 200, 200 ) )
	Clubs.Slots[i].Current_Item = nil
	Clubs.Slots[i].ID = i
end

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

local Balls = vgui.Create( "DPanel", Inventory.PropertySheet )

local function BallDrop( self, panels, bDoDrop, Command, x, y )
	if ( bDoDrop ) then
		for k, v in pairs( panels ) do
			if ( !IsValid( v ) ) then continue end
			
			local Slot = v.ID == "Material" && Balls.Material_Slot or Balls.Trail_Slot
			if ( self == Balls.Material_Slot or self == Balls.Trail_Slot ) then
				if ( Slot ~= self ) then return end
				
				if ( self.Current_Item == nil ) then
					local Item = self:Add( v )
					Item:SetPos( 0, 0 )
					
					self.Current_Item = Item
				else
					Balls.Items.DIconLayout:Add( self.Current_Item ) // Add the slots old item back to the list
					
					local Item = self:Add( v )
					Item:SetPos( 0, 0 )
					
					self.Current_Item = Item
				end
			else
				Slot.Current_Item = nil
				
				self:Add( v )
			end
		end
	end
end

Balls.Items = vgui.Create( "DScrollPanel", Balls )
Balls.Items:SetSize( Inventory.PropertySheet:GetWide(), Inventory.PropertySheet:GetTall() - 100 )
local VBar = Balls.Items:GetVBar()
function Balls.Items:OnScrollbarAppear()
	VBar:SetSize( 0, 0 )
end

Balls.Items.DIconLayout = vgui.Create( "DIconLayout", Balls.Items )
Balls.Items.DIconLayout:SetSize( Inventory.PropertySheet:GetWide() / 2 - 1, Inventory.PropertySheet:GetTall() - 1 )
Balls.Items.DIconLayout:SetPos( 1, 1 )
Balls.Items.DIconLayout:Receiver( "Ball_Item", BallDrop )
Balls.Items.DIconLayout:SetPaintBackgroundEnabled( true )
Balls.Items.DIconLayout:SetBackgroundColor( Color( 0, 255, 255 ) )
Balls.Items.DIconLayout:SetSpaceX( 2 )
Balls.Items.DIconLayout:SetSpaceY( 2 )

function Balls.Items.DIconLayout.NewItem( mat, id )
	local Item = Balls.Items.DIconLayout:Add( vgui.Create( "DImage" ) )
	Item:SetSize( 62, 62 )
	Item:SetKeepAspect( false )
	Item:SetImage( mat )
	Item:Droppable( "Ball_Item" )
	Item.ID = id
end

for i = 1, 10 do
	local mat = !tobool( i % 2 ) && "inventory/balls/mat_g-olf.png" or "inventory/balls/trail_g-olf.png"
	local id = !tobool( i % 2 ) && "Material" or "Trail"
	
	Balls.Items.DIconLayout.NewItem( mat, id )
end

Balls.Material_Slot = vgui.Create( "DPanel", Balls )
Balls.Material_Slot:SetSize( Inventory.PropertySheet:GetWide() / 10.2, 62 )
Balls.Material_Slot:SetPos( Inventory.PropertySheet:GetWide() / 4 - Balls.Material_Slot:GetWide() - 1, Inventory.PropertySheet:GetTall() - Balls.Material_Slot:GetTall() * 1.59 )
Balls.Material_Slot:Receiver( "Ball_Item", BallDrop )
Balls.Material_Slot.Current_Item = nil
Balls.Material_Slot:SetBackgroundColor( Color( 200, 200, 200 ) )

Balls.Material_Slot.Label = vgui.Create( "DLabel", Balls )
Balls.Material_Slot.Label:SetSize( Inventory.PropertySheet:GetWide() / 4 - Balls.Material_Slot:GetWide() - 1, 62 )
Balls.Material_Slot.Label:SetPos( 0, Inventory.PropertySheet:GetTall() - Balls.Material_Slot:GetTall() * 1.59 )
Balls.Material_Slot.Label:SetDark( true )
Balls.Material_Slot.Label:SetFont( "HudSelectionText" )
Balls.Material_Slot.Label:SetContentAlignment( 5 )
Balls.Material_Slot.Label:SetText( "Material" )

Balls.Trail_Slot = vgui.Create( "DPanel", Balls )
Balls.Trail_Slot:SetSize( Inventory.PropertySheet:GetWide() / 10.2, 62 )
Balls.Trail_Slot:SetPos( Inventory.PropertySheet:GetWide() / 4 + 1, Inventory.PropertySheet:GetTall() - Balls.Trail_Slot:GetTall() * 1.59 )
Balls.Trail_Slot:Receiver( "Ball_Item", BallDrop )
Balls.Trail_Slot.Current_Item = nil
Balls.Trail_Slot:SetBackgroundColor( Color( 200, 200, 200 ) )

Balls.Trail_Slot.Label = vgui.Create( "DLabel", Balls )
Balls.Trail_Slot.Label:SetSize( Inventory.PropertySheet:GetWide() / 4 - Balls.Material_Slot:GetWide() - 1, 62 )
Balls.Trail_Slot.Label:SetPos( Inventory.PropertySheet:GetWide() / 4 + 63, Inventory.PropertySheet:GetTall() - Balls.Material_Slot:GetTall() * 1.59 )
Balls.Trail_Slot.Label:SetDark( true )
Balls.Trail_Slot.Label:SetFont( "HudSelectionText" )
Balls.Trail_Slot.Label:SetContentAlignment( 5 )
Balls.Trail_Slot.Label:SetText( "Trail" )

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

Inventory.PropertySheet:AddSheet( "Balls", Balls, "icon16/ball.png" )

local Carts = vgui.Create( "DPanel", Inventory.PropertySheet )

Carts.Slot = vgui.Create( "DPanel", Carts )
Carts.Slot:SetSize( Inventory.PropertySheet:GetWide() / 10.2, 62 )
Carts.Slot:SetPos( Carts.Slot:GetWide() * 2 + 5, Inventory.PropertySheet:GetTall() - Carts.Slot:GetTall() * 1.59 )
Carts.Slot:SetBackgroundColor( Color( 200, 200, 200 ) )

Inventory.PropertySheet:AddSheet( "Carts", Carts, "icon16/new_cart.png" )

local Outfit = vgui.Create( "DPanel", Inventory.PropertySheet )

Inventory.PropertySheet:AddSheet( "Outfit", Outfit, "icon16/shirt.png" )

--[[ 
	Settings
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