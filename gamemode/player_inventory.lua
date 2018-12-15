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
	Item.DrawSelection = false
	Item.ID = 0
	function Item:PaintOver( w, h )
		if ( Item.DrawSelection ) then
			surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
	end
	
	function Item:DragMouseRelease( mouseCode ) // manual work-around for item selection
		if ( self:IsDragging() ) then
			dragndrop.Drop()
		else
			dragndrop.StopDragging()
			
			if ( Clubs.Items.Selected == nil ) then
				self.DrawSelection = true
				
				Clubs.Items.Selected = self
			elseif ( Clubs.Items.Selected ~= nil && Clubs.Items.Selected ~= self ) then
				Clubs.Items.Selected.DrawSelection = false
				
				self.DrawSelection = true
				
				Clubs.Items.Selected = self
			end
		end
	end
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
			
			local pnl = v
			
			local Slot = v.ID == "Material" && Balls.Material_Slot or Balls.Trail_Slot
			if ( self == Balls.Material_Slot or self == Balls.Trail_Slot ) then
				if ( Slot ~= self ) then return end
				
				if ( self.Current_Item == nil ) then
					local Item = self:Add( pnl )
					Item:SetPos( 0, 0 )
					
					self.Current_Item = Item
				else
					Balls.Items.DIconLayout:Add( self.Current_Item ) // Add the slots old item back to the list
					
					local Item = self:Add( pnl )
					Item:SetPos( 0, 0 )
					
					self.Current_Item = Item
				end
			else
				Slot.Current_Item = nil
				
				self:Add( pnl )
				
				/*for k, v in pairs( self:GetChildren() ) do
					if ( !IsValid( v ) ) then continue end
					
					local item_x, item_y = v:GetPos()
					
					if ( x < item_x + 64 && y < item_y + 64 ) then
						local Item = self:Add( pnl )
						Item:SetPos( v:GetPos() )
						break
					elseif ( k == #self:GetChildren() ) then
						if ( x > item_x + 64 && y < item_y + 64 ) then
							local Item = self:Add( pnl )
							break
						end
					end
				end*/
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
Balls.ModelPanel:SetColor( string.ToColor( GetConVar( "cl_golfballcolour" ):GetString() .. " 255" ) )

Balls.StatsOutline = vgui.Create( "DPanel", Balls )
Balls.StatsOutline:SetSize( Inventory.PropertySheet:GetWide() / 2 - 18, Inventory.PropertySheet:GetTall() / 2 - 38 )
Balls.StatsOutline:SetPos( Inventory.PropertySheet:GetWide() / 2 + 1, Inventory.PropertySheet:GetTall() / 2 + 1 )
Balls.StatsOutline:SetBackgroundColor( Color( 20, 20, 20 ) )

Balls.Stats = vgui.Create( "DPanel", Balls.StatsOutline )
Balls.Stats:SetSize( Balls.StatsOutline:GetWide() - 2, Balls.StatsOutline:GetTall() - 2 )
Balls.Stats:SetPos( 1, 1 )

Balls.Stats.ColourMixer = vgui.Create( "DColorMixer", Balls.Stats )
Balls.Stats.ColourMixer:Dock( FILL )
Balls.Stats.ColourMixer:SetPalette( false )
Balls.Stats.ColourMixer:SetAlphaBar( false )
Balls.Stats.ColourMixer:SetWangs( true )
Balls.Stats.ColourMixer:SetColor( string.ToColor( GetConVar( "cl_golfballcolour" ):GetString() .. " 255" ) )
function Balls.Stats.ColourMixer:ValueChanged( col )
	local new_colour = col.r .. " " .. col.g .. " " .. col.b
	
	Balls.ModelPanel:SetColor( string.ToColor( new_colour .. " 255" ) )
	LocalPlayer():ConCommand( "cl_golfballcolour " .. new_colour )
end

Inventory.PropertySheet:AddSheet( "Balls", Balls, "icon16/ball.png" )

local Carts = vgui.Create( "DPanel", Inventory.PropertySheet )

local function CartDrop( self, panels, bDoDrop, Command, x, y )
	if ( bDoDrop ) then
		for k, v in pairs( panels ) do
			if ( !IsValid( v ) ) then continue end
			
			local pnl = v
			
			if ( self == Carts.Slot ) then
				if ( self.Current_Item == nil ) then
					local Item = self:Add( pnl )
					Item:SetPos( 0, 0 )
					
					self.Current_Item = Item
				else
					Carts.Items.DIconLayout:Add( self.Current_Item )
					
					local Item = self:Add( pnl )
					Item:SetPos( 0, 0 )
					
					self.Current_Item = Item
				end
			else
				Carts.Slot.Current_Item = nil
				
				self:Add( pnl )
			end
		end
	end
end

Carts.Items = vgui.Create( "DScrollPanel", Carts )
Carts.Items:SetSize( Inventory.PropertySheet:GetWide(), Inventory.PropertySheet:GetTall() - 64 )
local VBar = Carts.Items:GetVBar()
function Carts.Items:OnScrollbarAppear()
	VBar:SetSize( 0, 0 )
end
Carts.Items.Selected = nil

Carts.Items.DIconLayout = vgui.Create( "DIconLayout", Carts.Items )
Carts.Items.DIconLayout:SetSize( Inventory.PropertySheet:GetWide() / 2 - 1, Inventory.PropertySheet:GetTall() - 2 )
Carts.Items.DIconLayout:SetPos( 1, 1 )
Carts.Items.DIconLayout:Receiver( "Cart", CartDrop )
Carts.Items.DIconLayout:SetSpaceX( 2 )
Carts.Items.DIconLayout:SetSpaceY( 2 )

function Carts.Items.DIconLayout.NewItem( skin )
	local Item = Carts.Items.DIconLayout:Add( vgui.Create( "DImage" ) )
	Item:SetSize( 62, 62 )
	Item:SetKeepAspect( false )
	Item:SetImage( "inventory/balls/placeholder.png" )
	Item:Droppable( "Cart" )
	Item.DrawSelection = false
	Item.ID = 0
	function Item:PaintOver( w, h )
		if ( Item.DrawSelection ) then
			surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
	end
	
	function Item:DragMouseRelease( mouseCode ) // manual work-around for item selection
		if ( self:IsDragging() ) then
			dragndrop.Drop()
		else
			dragndrop.StopDragging()
			
			if ( Carts.Items.Selected == nil ) then
				self.DrawSelection = true
				
				Carts.Items.Selected = self
			elseif ( Carts.Items.Selected ~= nil && Carts.Items.Selected ~= self ) then
				Carts.Items.Selected.DrawSelection = false
				
				self.DrawSelection = true
				
				Carts.Items.Selected = self
			end
		end
	end
end

for i = 1, 10 do
	Carts.Items.DIconLayout.NewItem( "skree" )
end

Carts.ModelPanelOutline = vgui.Create( "DPanel", Carts )
Carts.ModelPanelOutline:SetSize( Inventory.PropertySheet:GetWide() / 2 - 18, Inventory.PropertySheet:GetTall() / 2 + 1 )
Carts.ModelPanelOutline:SetPos( Inventory.PropertySheet:GetWide() / 2 + 1, 1 )
Carts.ModelPanelOutline:SetBackgroundColor( Color( 20, 20, 20 ) )

Carts.ModelPanelFill = vgui.Create( "DPanel", Carts.ModelPanelOutline )
Carts.ModelPanelFill:SetSize( Carts.ModelPanelOutline:GetWide() - 2, Carts.ModelPanelOutline:GetTall() - 2 )
Carts.ModelPanelFill:SetPos( 1, 1 )

Carts.ModelPanel = vgui.Create( "DModelPanel", Carts.ModelPanelFill )
Carts.ModelPanel:SetSize( Carts.ModelPanelFill:GetWide(), Carts.ModelPanelFill:GetTall() )
Carts.ModelPanel:SetPos( 0, 0 )
Carts.ModelPanel:SetModel( "models/buggy.mdl" )
Carts.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
Carts.ModelPanel:SetCamPos( Carts.ModelPanel.Entity:GetPos() - Vector( 150, 1, -30 ) )

Carts.StatsOutline = vgui.Create( "DPanel", Carts )
Carts.StatsOutline:SetSize( Inventory.PropertySheet:GetWide() / 2 - 18, Inventory.PropertySheet:GetTall() / 2 - 38 )
Carts.StatsOutline:SetPos( Inventory.PropertySheet:GetWide() / 2 + 1, Inventory.PropertySheet:GetTall() / 2 + 1 )
Carts.StatsOutline:SetBackgroundColor( Color( 20, 20, 20 ) )

Carts.Stats = vgui.Create( "DPanel", Carts.StatsOutline )
Carts.Stats:SetSize( Carts.StatsOutline:GetWide() - 2, Carts.StatsOutline:GetTall() - 2 )
Carts.Stats:SetPos( 1, 1 )

Carts.Stats.Header = vgui.Create( "DLabel", Carts.Stats )
Carts.Stats.Header:SetSize( Carts.Stats:GetWide(), 20 )
Carts.Stats.Header:SetPos( 1, 1 )
Carts.Stats.Header:SetDark( true )
Carts.Stats.Header:SetFont( "HudSelectionText" )
Carts.Stats.Header:SetContentAlignment( 5 )
Carts.Stats.Header:SetText( "Stats" )

Carts.Stats.Name = vgui.Create( "DLabel", Carts.Stats )
Carts.Stats.Name:SetSize( Carts.Stats:GetWide(), 20 )
Carts.Stats.Name:SetPos( 1, 21 )
Carts.Stats.Name:SetDark( true )
Carts.Stats.Name:SetFont( "HudSelectionText" )
Carts.Stats.Name:SetContentAlignment( 4 )
Carts.Stats.Name:SetText( "Name: " )

Carts.Stats.Description = vgui.Create( "DLabel", Carts.Stats )
Carts.Stats.Description:SetSize( Carts.Stats:GetWide(), Carts.Stats:GetTall() / 2 )
Carts.Stats.Description:SetPos( 1, 41 )
Carts.Stats.Description:SetDark( true )
Carts.Stats.Description:SetFont( "HudSelectionText" )
Carts.Stats.Description:SetContentAlignment( 7 )
Carts.Stats.Description:SetWrap( true )
Carts.Stats.Description:SetText( "Description: " )

Carts.Slot = vgui.Create( "DPanel", Carts )
Carts.Slot:SetSize( Inventory.PropertySheet:GetWide() / 10.2, 62 )
Carts.Slot:SetPos( Carts.Slot:GetWide() * 2 + 5, Inventory.PropertySheet:GetTall() - Carts.Slot:GetTall() * 1.59 )
Carts.Slot:SetBackgroundColor( Color( 200, 200, 200 ) )
Carts.Slot:Receiver( "Cart", CartDrop )
Carts.Slot.Current_Item = nil

Inventory.PropertySheet:AddSheet( "Carts", Carts, "icon16/new_cart.png" )

local Outfit = vgui.Create( "DPanel", Inventory.PropertySheet )

Outfit.ModelPanelOutline = vgui.Create( "DPanel", Outfit )
Outfit.ModelPanelOutline:SetSize( Inventory.PropertySheet:GetWide() / 2 - 18, Inventory.PropertySheet:GetTall() - 38 )
Outfit.ModelPanelOutline:SetPos( Inventory.PropertySheet:GetWide() / 2 + 1, 1 )
Outfit.ModelPanelOutline:SetBackgroundColor( Color( 20, 20, 20 ) )

Outfit.ModelPanelFill = vgui.Create( "DPanel", Outfit.ModelPanelOutline )
Outfit.ModelPanelFill:SetSize( Outfit.ModelPanelOutline:GetWide() - 2, Outfit.ModelPanelOutline:GetTall() - 2 )
Outfit.ModelPanelFill:SetPos( 1, 1 )

Outfit.ModelPanel = vgui.Create( "DModelPanel", Outfit.ModelPanelFill )
Outfit.ModelPanel:SetSize( Outfit.ModelPanelFill:GetWide(), Outfit.ModelPanelFill:GetTall() )
Outfit.ModelPanel:SetPos( 0, 0 )
function Outfit.ModelPanel:Think()
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	if ( Outfit.ModelPanel:GetModel() == nil or Outfit.ModelPanel:GetModel() ~= LocalPlayer():GetModel() ) then
		Outfit.ModelPanel:SetModel( LocalPlayer():GetModel() )
		Outfit.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
		Outfit.ModelPanel:SetCamPos( Outfit.ModelPanel.Entity:GetPos() - Vector( 45, 1, -30 ) )
	end
end

Outfit.Slot = vgui.Create( "DPanel", Outfit )
Outfit.Slot:SetSize( Inventory.PropertySheet:GetWide() / 10.2, 62 )
Outfit.Slot:SetPos( Outfit.Slot:GetWide() * 2 + 5, Inventory.PropertySheet:GetTall() - Outfit.Slot:GetTall() * 1.59 )
Outfit.Slot:SetBackgroundColor( Color( 200, 200, 200 ) )

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