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

local GHUD = {
	Ball = {},
	Equipment = {},
	Mini_Map = {
		Ball = Material( "icon8/minimap_ball.png" ),
		Flag = Material( "icon16/minimap_flag.png" ),
		Pointer = Material( "icon32/minimap_pointer_arrow.png" )
	},
	Power_Meter = {
		Bar = Material( "ghud/bar.png" ),
	},
	Spin = {},
	Weapon_Selection = {},
	Wind = {}
}

GHUD.Equipment.Image = vgui.Create( "DImage" )
GHUD.Equipment.Image:SetSize( ScrW() / 8, ScrH() / 5 )
GHUD.Equipment.Image:SetPos( ScrW() - GHUD.Equipment.Image:GetWide() * 1.3, ScrH() - GHUD.Equipment.Image:GetTall() - 20 )
GHUD.Equipment.Image:SetKeepAspect( false )
GHUD.Equipment.Image:SetImage( "ghud/equipment.png" )

GHUD.Equipment.Label = vgui.Create( "DLabel", GHUD.Equipment.Image )
GHUD.Equipment.Label:SetSize( GHUD.Equipment.Image:GetWide(), GHUD.Equipment.Image:GetTall() / 4 )
GHUD.Equipment.Label:SetPos( 0, GHUD.Equipment.Image:GetTall() - GHUD.Equipment.Label:GetTall() + 4 )
GHUD.Equipment.Label:SetDark( true )
GHUD.Equipment.Label:SetFont( "GModNotify" )
GHUD.Equipment.Label:SetContentAlignment( 5 )
function GHUD.Equipment.Label:Think()
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	if ( LocalPlayer():InVehicle() ) then
		if ( !IsValid( LocalPlayer():GetVehicle() ) ) then return end
		
		if ( GHUD.Equipment.Label:GetText() ~= LocalPlayer():GetClass() ) then
			GHUD.Equipment.Label:SetText( LocalPlayer():GetVehicle():GetClass() )
		end
	else
		local Weapon = LocalPlayer():GetActiveWeapon() ~= NULL && LocalPlayer():GetActiveWeapon():GetPrintName() or "None"
		
		if ( GHUD.Equipment.Label:GetText() ~= Weapon ) then
			GHUD.Equipment.Label:SetText( Weapon )
		end
	end
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

GHUD.Power_Meter.Panel = vgui.Create( "DPanel" )
GHUD.Power_Meter.Panel:SetSize( ScrW() / 1.8, 48 )
GHUD.Power_Meter.Panel:SetPos( ScrW() / 2 - GHUD.Power_Meter.Panel:GetWide() / 2, ScrH() - ( GHUD.Power_Meter.Panel:GetTall() * 2 ) )
function GHUD.Power_Meter.Panel:Paint( w, h )
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	if ( LocalPlayer():GetActiveWeapon() == NULL ) then return end
	if ( LocalPlayer():GetActiveWeapon().GetHitPower == nil ) then return end
	
	local Hit_Power = LocalPlayer():GetActiveWeapon():GetHitPower()
	local Max_Power = LocalPlayer():GetActiveWeapon():GetMaxPower()
	local Power_Meter = Hit_Power / Max_Power * ( w - 48 )
	
	surface.SetDrawColor( Color( 255, 100, 100 ) )
	surface.DrawRect( 24, 1, Power_Meter, h - 2 )
end

GHUD.Power_Meter.Bar = vgui.Create( "DImage" )
GHUD.Power_Meter.Bar:SetSize( ScrW() / 1.8, 48 )
GHUD.Power_Meter.Bar:SetPos( ScrW() / 2 - GHUD.Power_Meter.Bar:GetWide() / 2, ScrH() - ( GHUD.Power_Meter.Bar:GetTall() * 2 ) )
GHUD.Power_Meter.Bar:SetKeepAspect( false )
GHUD.Power_Meter.Bar:SetImage( "ghud/bar.png" )

GHUD.Spin.Image = vgui.Create( "DImage" )
GHUD.Spin.Image:SetSize( ScrW() / 9, ScrW() / 9 )
GHUD.Spin.Image:SetPos( GHUD.Spin.Image:GetWide() / 2.5, ScrH() - GHUD.Spin.Image:GetTall() - 20 )
GHUD.Spin.Image:SetKeepAspect( false )
GHUD.Spin.Image:SetImage( "ghud/ball.png" )

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
	local ent = nil
	
	for k, v in pairs( ents.FindByClass( "golf_ball" ) ) do
		if ( !IsValid( v ) ) then continue end
		if ( v:GetOwner() ~= LocalPlayer() ) then continue end
		
		GHUD.Wind.ModelPanel:SetCamPos( Entity:GetPos() - Vector( 9, 0, 0 ) )
	
		Entity:SetAngles( ( LocalPlayer():GetPos() - v:GetPos() ):Angle() - Angle( 90, LocalPlayer():GetAngles().y, 0 ) )
	end
	
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