/*G-Olf PlayerHUD*/

local CHud = {
	"CHudAmmo",
	"CHudBattery",
	//"CHudChat",
	"CHudHealth",
	"CHudSecondaryAmmo",
	//"CHudWeaponSelection"
}

function HideHUD( name )
	for k, v in pairs( CHud ) do
		if name == v then return false end
	end
end
hook.Add( "HUDShouldDraw", "HideHUD", HideHUD )

/*Client HUD*/

local GHUD = {
	Ball = {},
	Cart = {},
	Club = {},
	Mini_Map = {
		Ball = Material( "icon8/minimap_ball.png" ),
		Flag = Material( "icon16/minimap_flag.png" ),
		Pointer = Material( "icon32/minimap_pointer_arrow.png" )
	},
	Power_Meter = {
		Bar_BG = Material( "ghud/bar_bg.png" ),
		Bar_FG = Material( "ghud/bar_fg.png" )
	},
	Spin = {},
	Weapon_Selection = {},
	Wind = {}
}

GHUD.Club.Panel = vgui.Create( "DPanel" )
GHUD.Club.Panel:SetSize( ScrW() / 6, ScrH() / 4 )
GHUD.Club.Panel:SetPos( ScrW() - GHUD.Club.Panel:GetWide() - 20, ScrH() - GHUD.Club.Panel:GetTall() - 20 )

GHUD.Club.ModelOuter = vgui.Create( "DPanel", GHUD.Club.Panel )
GHUD.Club.ModelOuter:SetSize( GHUD.Club.Panel:GetWide() / 2, GHUD.Club.Panel:GetTall() )
GHUD.Club.ModelOuter:SetPos( GHUD.Club.Panel:GetWide() / 2, 0 )
GHUD.Club.ModelOuter:SetBackgroundColor( Color( 0, 0, 0 ) )

GHUD.Club.ModelInner = vgui.Create( "DPanel", GHUD.Club.ModelOuter )
GHUD.Club.ModelInner:SetSize( GHUD.Club.ModelOuter:GetWide() - 2, GHUD.Club.ModelOuter:GetTall() - 2 )
GHUD.Club.ModelInner:SetPos( 1, 1 )

GHUD.Club.ModelPanel = vgui.Create( "DModelPanel", GHUD.Club.ModelInner )
GHUD.Club.ModelPanel:SetSize( GHUD.Club.ModelInner:GetWide(), GHUD.Club.ModelInner:GetTall() )
GHUD.Club.ModelPanel:SetPos( 0, 0 )
GHUD.Club.ModelPanel:SetModel( "" )
GHUD.Club.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
function GHUD.Club.ModelPanel:Think()
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	if ( LocalPlayer():GetActiveWeapon() ~= NULL && GHUD.Club.ModelPanel:GetModel() ~= LocalPlayer():GetActiveWeapon():GetModel() ) then
		GHUD.Club.ModelPanel:SetModel( LocalPlayer():GetActiveWeapon():GetModel() )
	elseif ( LocalPlayer():GetActiveWeapon() == NULL && GHUD.Club.ModelPanel:GetEntity() ~= nil ) then
		GHUD.Club.ModelPanel:SetModel( "" )
	end
end
function GHUD.Club.ModelPanel:LayoutEntity( Entity )
	GHUD.Club.ModelPanel:SetCamPos( Entity:GetPos() - Vector( 20, 2, 0 ) )
	Entity:SetAngles( Angle( 0, 90, 0 ) )
	
	return 
end

GHUD.Club.InfoOuter = vgui.Create( "DPanel", GHUD.Club.Panel )
GHUD.Club.InfoOuter:SetSize( GHUD.Club.Panel:GetWide() / 2 + 1, GHUD.Club.Panel:GetTall() / 2 + 1 )
GHUD.Club.InfoOuter:SetPos( 0, GHUD.Club.Panel:GetTall() / 2 - 1 )
GHUD.Club.InfoOuter:SetBackgroundColor( Color( 0, 0, 0 ) )

GHUD.Club.Info = vgui.Create( "DPanel", GHUD.Club.InfoOuter )
GHUD.Club.Info:SetSize( GHUD.Club.InfoOuter:GetWide() - 2, GHUD.Club.InfoOuter:GetTall() - 2 )
GHUD.Club.Info:SetPos( 1, 1 )

GHUD.Club.Info.Name = vgui.Create( "DLabel", GHUD.Club.Info )
GHUD.Club.Info.Name:SetPos( 0, 0 )
GHUD.Club.Info.Name:SetSize( GHUD.Club.Info:GetWide(), 20 )
GHUD.Club.Info.Name:SetContentAlignment( 5 )
GHUD.Club.Info.Name:SetDark( true )
GHUD.Club.Info.Name:SetFont( "Trebuchet18" )
function GHUD.Club.Info.Name:Think()
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	local weapon = LocalPlayer():GetActiveWeapon() ~= NULL && LocalPlayer():GetActiveWeapon():GetPrintName() or "None"
	
	if ( GHUD.Club.Info.Name:GetText() ~= weapon ) then
		GHUD.Club.Info.Name:SetText( weapon )
	end
end

GHUD.Club.Info.FPS = vgui.Create( "DLabel", GHUD.Club.Info )
GHUD.Club.Info.FPS:SetPos( 0, GHUD.Club.Info:GetTall() - 44 )
GHUD.Club.Info.FPS:SetSize( GHUD.Club.Info:GetWide(), 45 )
GHUD.Club.Info.FPS:SetContentAlignment( 5 )
GHUD.Club.Info.FPS:SetDark( true )
GHUD.Club.Info.FPS:SetFont( "Trebuchet18" )
function GHUD.Club.Info.FPS:Think()
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	if ( GHUD.Club.Info.FPS:GetValue( 2 ) ~= math.Round( 1 / RealFrameTime() ) ) then
		GHUD.Club.Info.FPS:SetText( "FPS: " .. math.Round( 1 / RealFrameTime() ) )
	end
end

GHUD.Cart.Panel = vgui.Create( "DPanel", GHUD.Club.Panel )
GHUD.Cart.Panel:SetSize( GHUD.Club.Panel:GetWide() / 2, GHUD.Club.Panel:GetTall() / 2 )
GHUD.Cart.Panel:SetPos( 0, 0 )
GHUD.Cart.Panel:SetBackgroundColor( Color( 0, 0, 0 ) )

GHUD.Cart.ModelInner = vgui.Create( "DPanel", GHUD.Cart.Panel )
GHUD.Cart.ModelInner:SetSize( GHUD.Cart.Panel:GetWide() - 1, GHUD.Cart.Panel:GetTall() - 2 )
GHUD.Cart.ModelInner:SetPos( 1, 1 )

GHUD.Cart.ModelPanel = vgui.Create( "DModelPanel", GHUD.Cart.Panel )
GHUD.Cart.ModelPanel:SetSize( GHUD.Cart.Panel:GetWide(), GHUD.Cart.Panel:GetTall() )
GHUD.Cart.ModelPanel:Center()
GHUD.Cart.ModelPanel:SetModel( "models/buggy.mdl" )
function GHUD.Cart.ModelPanel:LayoutEntity( Entity )
	GHUD.Cart.ModelPanel:SetCamPos( Entity:GetPos() - Vector( 150, 0, -50 ) )
	
	return 
end

GHUD.Mini_Map.Panel = vgui.Create( "DPanel" )
GHUD.Mini_Map.Panel:SetSize( ScrW() / 7, ScrH() / 4 )
GHUD.Mini_Map.Panel:SetPos( ScrW() - GHUD.Mini_Map.Panel:GetWide() - 20, 20 )
function GHUD.Mini_Map.Panel:Paint( w, h )
	if !IsValid( LocalPlayer() ) then return end
	
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( 0, 0, w, h )
	
	for k, v in pairs( player.GetAll() ) do
		if ( !IsValid( v ) ) then continue end
		if ( v == LocalPlayer() ) then continue end
		
		surface.SetDrawColor( 255, 255, 255, 127.5 )
		surface.SetMaterial( GHUD.Mini_Map.Pointer )
		surface.DrawTexturedRectRotated( ( ( w / 2 ) - ( v:GetPos().y / w ) ), ( ( h / 2 ) - ( v:GetPos().x / h ) ), 32, 32, v:EyeAngles().y )
	end
	
	for k, v in pairs( ents.GetAll() ) do
		if ( !IsValid( v ) ) then continue end
		
		if ( v:GetClass() == "golf_ball" && v:GetOwner() == LocalPlayer() ) then
			local ball = v
			local pos = ball:GetPos()
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( GHUD.Mini_Map.Ball )
			surface.DrawTexturedRect( ( ( w / 2 ) - ( pos.y / w ) ) - 4, ( ( h / 2 ) - ( pos.x / h ) ) - 4, 8, 8 )
		end
	end
	
	surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( GHUD.Mini_Map.Pointer )
		surface.DrawTexturedRectRotated( ( ( w / 2 ) - ( LocalPlayer():GetPos().y / w ) ), ( ( h / 2 ) - ( LocalPlayer():GetPos().x / h ) ), 32, 32, LocalPlayer():EyeAngles().y )
end

/*GHUD.Mini_Map.Map = vgui.Create( "DImage", GHUD.Mini_Map.Panel )
GHUD.Mini_Map.Map:SetSize( GHUD.Mini_Map.Panel:GetWide(), GHUD.Mini_Map.Panel:GetTall() )
GHUD.Mini_Map.Map:SetPos( 0, 0 )
GHUD.Mini_Map.Map:SetKeepAspect( false )
GHUD.Mini_Map.Map:SetImage( "overviews/de_inferno" )*/

GHUD.Power_Meter.Background = vgui.Create( "DImage" )
GHUD.Power_Meter.Background:SetSize( ScrW() / 1.8, 64 )
GHUD.Power_Meter.Background:SetPos( ScrW() / 2 - GHUD.Power_Meter.Background:GetWide() / 2, ScrH() - GHUD.Power_Meter.Background:GetTall() - 20 )
GHUD.Power_Meter.Background:SetKeepAspect( false )
GHUD.Power_Meter.Background:SetImage( "ghud/bar_bg.png" )
function GHUD.Power_Meter.Background:PaintOver( w, h )
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	if ( LocalPlayer():GetActiveWeapon() == NULL ) then return end
	if ( LocalPlayer():GetActiveWeapon().GetHitPower == nil ) then return end
	
	local Hit_Power = LocalPlayer():GetActiveWeapon():GetHitPower()
	local Max_Power = LocalPlayer():GetActiveWeapon():GetMaxPower()
	local Power_Meter = Hit_Power / Max_Power * ( w - 64 )
	
	surface.SetDrawColor( Color( 255, 100, 100 ) )
	surface.DrawRect( 32, 1, Power_Meter, h - 2 )
end

GHUD.Power_Meter.Foreground = vgui.Create( "DImage" )
GHUD.Power_Meter.Foreground:SetSize( ScrW() / 1.8, 64 )
GHUD.Power_Meter.Foreground:SetPos( ScrW() / 2 - GHUD.Power_Meter.Foreground:GetWide() / 2, ScrH() - GHUD.Power_Meter.Foreground:GetTall() - 20 )
GHUD.Power_Meter.Foreground:SetKeepAspect( false )
GHUD.Power_Meter.Foreground:SetImage( "ghud/bar_fg.png" )

GHUD.Spin.Panel = vgui.Create( "DPanel" )
GHUD.Spin.Panel:SetSize( ScrW() / 5, ScrH() / 4 )
GHUD.Spin.Panel:SetPos( 20, ScrH() - GHUD.Spin.Panel:GetTall() - 20 )
GHUD.Spin.Panel:SetBackgroundColor( Color( 255, 255, 255, 0 ) )

GHUD.Spin.ModelPanel = vgui.Create( "DModelPanel", GHUD.Spin.Panel )
GHUD.Spin.ModelPanel:SetSize( GHUD.Spin.Panel:GetWide(), GHUD.Spin.Panel:GetTall() )
GHUD.Spin.ModelPanel:Center()
GHUD.Spin.ModelPanel:SetModel( "models/golf_ball/golf_ball.mdl" )
GHUD.Spin.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
function GHUD.Spin.ModelPanel:LayoutEntity( Entity )
	GHUD.Spin.ModelPanel:SetCamPos( Entity:GetPos() - Vector( 7, 0, 0 ) )
	
	return 
end

/*GHUD.Weapon_Selection.Category_Labels = {
	"Wood",
	"Iron",
	"Wedge",
	"Putter",
	"Utilities"
}

GHUD.Weapon_Selection.Categories = {}

GHUD.Weapon_Selection.Panel = vgui.Create( "DPanel" )
GHUD.Weapon_Selection.Panel:SetSize( ScrW() / 1.5, ScrH() )
GHUD.Weapon_Selection.Panel:SetPos( ScrW() / 2 - GHUD.Weapon_Selection.Panel:GetWide() / 2, 5 )
GHUD.Weapon_Selection.Panel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
GHUD.Weapon_Selection.Panel:SetVisible( false )
function GHUD.Weapon_Selection.Panel:Think()
	if !( LocalPlayer():Alive() ) then
		GHUD.Weapon_Selection.Panel:SetVisible( false )
	end
end

GHUD.Weapon_Selection.Weapons = {}
GHUD.Weapon_Selection.Refresh = function()
	if ( table.Count( GHUD.Weapon_Selection.Weapons ) > 0 ) then
		for k, v in pairs( GHUD.Weapon_Selection.Weapons ) do
			v:Remove()
			GHUD.Weapon_Selection.Weapons[k] = nil
		end
	end
	
	if ( table.Count( GHUD.Weapon_Selection.Categories ) > 0 ) then
		for k, v in pairs( GHUD.Weapon_Selection.Categories ) do
			v:Remove()
			GHUD.Weapon_Selection.Categories[k] = nil
		end
	end
	
	for k, v in pairs( GHUD.Weapon_Selection.Category_Labels ) do
		local x = k - 1
		GHUD.Weapon_Selection.Categories[v] = vgui.Create( "DPanel", GHUD.Weapon_Selection.Panel )
		GHUD.Weapon_Selection.Categories[v]:SetSize( GHUD.Weapon_Selection.Panel:GetWide() / 5 - 2, GHUD.Weapon_Selection.Panel:GetTall() / 30 )
		GHUD.Weapon_Selection.Categories[v]:SetPos( x * GHUD.Weapon_Selection.Panel:GetWide() / 5 + 1, 1 )
		GHUD.Weapon_Selection.Categories[v]:SetBackgroundColor( Color( 170, 255, 170 ) )
		GHUD.Weapon_Selection.Categories[v].Count = 0
		
		GHUD.Weapon_Selection.Categories[v].Label = vgui.Create( "DLabel", GHUD.Weapon_Selection.Categories[v] )
		GHUD.Weapon_Selection.Categories[v].Label:SetSize( GHUD.Weapon_Selection.Categories[v]:GetWide(), GHUD.Weapon_Selection.Categories[v]:GetTall() )
		GHUD.Weapon_Selection.Categories[v].Label:SetDark( true )
		GHUD.Weapon_Selection.Categories[v].Label:SetContentAlignment( 5 )
		GHUD.Weapon_Selection.Categories[v].Label:SetFont( "GModNotify" )
		GHUD.Weapon_Selection.Categories[v].Label:SetText( v )
		
		for key, weap in pairs( LocalPlayer():GetWeapons() ) do
			if ( weap.Category ~= v ) then continue end
			
			local Selected_Colour = LocalPlayer():GetActiveWeapon() == weap && Color( 255, 255, 200 ) or Color( 200, 255, 200 )
			local y = GHUD.Weapon_Selection.Categories[v].Count
			
			GHUD.Weapon_Selection.Weapons[key] = vgui.Create( "DPanel", GHUD.Weapon_Selection.Panel )
			GHUD.Weapon_Selection.Weapons[key]:SetSize( GHUD.Weapon_Selection.Panel:GetWide() / 5 - 2, GHUD.Weapon_Selection.Panel:GetTall() / 35 )
			GHUD.Weapon_Selection.Weapons[key]:SetPos( x * ( GHUD.Weapon_Selection.Panel:GetWide() / 5 ) + 1, GHUD.Weapon_Selection.Categories[v]:GetTall() + 2 + ( GHUD.Weapon_Selection.Weapons[key]:GetTall() * ( y ) ) + y )
			GHUD.Weapon_Selection.Weapons[key]:SetBackgroundColor( Selected_Colour )
			GHUD.Weapon_Selection.Weapons[key].Entity = weap
			
			GHUD.Weapon_Selection.Weapons[key].Label = vgui.Create( "DLabel", GHUD.Weapon_Selection.Weapons[key] )
			GHUD.Weapon_Selection.Weapons[key].Label:SetSize( GHUD.Weapon_Selection.Weapons[key]:GetWide(), GHUD.Weapon_Selection.Weapons[key]:GetTall() )
			GHUD.Weapon_Selection.Weapons[key].Label:SetDark( true )
			GHUD.Weapon_Selection.Weapons[key].Label:SetContentAlignment( 5 )
			GHUD.Weapon_Selection.Weapons[key].Label:SetFont( "GModNotify" )
			GHUD.Weapon_Selection.Weapons[key].Label:SetText( weap:GetPrintName() )
			
			GHUD.Weapon_Selection.Categories[v].Count = GHUD.Weapon_Selection.Categories[v].Count + 1
			
			if ( LocalPlayer():GetActiveWeapon() == weap ) then
				GHUD.Weapon_Selection.Selected_Weapon = GHUD.Weapon_Selection.Weapons[key]
			end
		end
	end
end
GHUD.Weapon_Selection.Next_Weapon = function()
	if !( GHUD.Weapon_Selection.Panel:IsVisible() ) then return end
	
	for k, v in pairs( GHUD.Weapon_Selection.Weapons ) do
		local Selected_ID = table.KeyFromValue( GHUD.Weapon_Selection.Weapons, GHUD.Weapon_Selection.Selected_Weapon )
		
		if ( v == GHUD.Weapon_Selection.Selected_Weapon ) then
			v:SetBackgroundColor( Color( 200, 255, 200 ) )
			
			if ( Selected_ID + 1 <= table.Count( GHUD.Weapon_Selection.Weapons ) ) then
				GHUD.Weapon_Selection.Selected_Weapon = GHUD.Weapon_Selection.Weapons[Selected_ID + 1]
			else
				GHUD.Weapon_Selection.Selected_Weapon = GHUD.Weapon_Selection.Weapons[1]
			end
			
			GHUD.Weapon_Selection.Selected_Weapon:SetBackgroundColor( Color( 255, 255, 200 ) )
			break
		end
	end
end
GHUD.Weapon_Selection.Previous_Weapon = function()
	if !( GHUD.Weapon_Selection.Panel:IsVisible() ) then return end
	
	for k, v in pairs( GHUD.Weapon_Selection.Weapons ) do
		local Selected_ID = table.KeyFromValue( GHUD.Weapon_Selection.Weapons, GHUD.Weapon_Selection.Selected_Weapon )
		
		if ( v == GHUD.Weapon_Selection.Selected_Weapon ) then
			v:SetBackgroundColor( Color( 200, 255, 200 ) )
			
			if ( Selected_ID - 1 >= 1 ) then
				GHUD.Weapon_Selection.Selected_Weapon = GHUD.Weapon_Selection.Weapons[Selected_ID - 1]
			else
				GHUD.Weapon_Selection.Selected_Weapon = GHUD.Weapon_Selection.Weapons[table.Count( GHUD.Weapon_Selection.Weapons )]
			end
			
			GHUD.Weapon_Selection.Selected_Weapon:SetBackgroundColor( Color( 255, 255, 200 ) )
			break
		end
	end
end

hook.Add( "PlayerBindPress", "g-olf", function( ply, bind, pressed ) // if there was an easier way to get mouse scrolling i'd use it
	if not pressed then return end
	
	if !IsValid( ply ) then return end
	if ( LocalPlayer():GetActiveWeapon() == NULL ) then return end
	
	local Weapons = LocalPlayer():GetWeapons()
	local Weapon_ID = table.KeyFromValue( Weapons, LocalPlayer():GetActiveWeapon() )
	
	if ( bind == "invnext" ) then // MOUSE_WHEEL_DOWN
		if ( Weapon_ID < table.Count( Weapons ) ) then
			Weapon_ID = Weapon_ID + 1
		else
			Weapon_ID = 1
		end
		
		if !( GHUD.Weapon_Selection.Panel:IsVisible() ) then
			GHUD.Weapon_Selection.Panel:SetVisible( true )
			GHUD.Weapon_Selection.Refresh()
			GHUD.Weapon_Selection.Next_Weapon()
		elseif ( GHUD.Weapon_Selection.Panel:IsVisible() ) then
			GHUD.Weapon_Selection.Next_Weapon()
		end
		
		return true
	elseif ( bind == "invprev" ) then // MOUSE_WHEEL_UP
		if ( Weapon_ID > 1 ) then
			Weapon_ID = Weapon_ID - 1
		else
			Weapon_ID = table.Count( Weapons )
		end
		
		if !( GHUD.Weapon_Selection.Panel:IsVisible() ) then
			GHUD.Weapon_Selection.Panel:SetVisible( true )
			GHUD.Weapon_Selection.Refresh()
			GHUD.Weapon_Selection.Previous_Weapon()
		elseif ( GHUD.Weapon_Selection.Panel:IsVisible() ) then
			GHUD.Weapon_Selection.Previous_Weapon()
		end
		
		return true
	end
	
	if ( bind == "+attack" ) then
		if ( GHUD.Weapon_Selection.Panel:IsVisible() ) then
			input.SelectWeapon( GHUD.Weapon_Selection.Selected_Weapon.Entity )
			
			GHUD.Weapon_Selection.Panel:SetVisible( false )
			
			return true
		end
	end
	
	if ( bind == "+attack2" ) then
		if ( GHUD.Weapon_Selection.Panel:IsVisible() ) then
			GHUD.Weapon_Selection.Panel:SetVisible( false )
			
			return true
		end
	end
end )*/

GHUD.Wind.ModelPanel = vgui.Create( "DModelPanel" )
GHUD.Wind.ModelPanel:SetSize( ScrW() / 9, ScrH() / 5 )
GHUD.Wind.ModelPanel:SetPos( 20, 20 )
GHUD.Wind.ModelPanel:SetModel( "models/wind_arrow/wind_arrow.mdl" )
GHUD.Wind.ModelPanel:SetColor( Color( 255, 100, 100 ) )
GHUD.Wind.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
function GHUD.Wind.ModelPanel:LayoutEntity( Entity )
	if ( !IsValid( LocalPlayer().Golf_Ball ) ) then return end
	
	GHUD.Wind.ModelPanel:SetCamPos( Entity:GetPos() - Vector( 9, 0, 0 ) )
	
	Entity:SetAngles( ( LocalPlayer():GetPos() - LocalPlayer().Golf_Ball:GetPos() ):Angle() - Angle( 90, LocalPlayer():GetAngles().y, 0 ) )
	
	return
end

local function Golf_HUD()
	if ( g_olf.Show_Names ) then
		for k, v in pairs( player.GetAll() ) do
			if !IsValid( v ) then continue end
			if ( v == LocalPlayer() ) then continue end
			
			local Name = v:GetName()
			local Pos = ( v:GetShootPos() ):ToScreen()
			local Alpha = ( v:GetPos():Distance( LocalPlayer():GetPos() ) / 255 * 100 ) / 2
			
			draw.SimpleTextOutlined( Name, "ChatFont", Pos.x, Pos.y - 45, Color( 255, 255, 255, 255 - Alpha ), 1, 1, 1, Color( 0, 0, 0, 255 - Alpha ) )
		end
	end
end
hook.Add( "HUDPaint", "g-olf_hud", Golf_HUD )