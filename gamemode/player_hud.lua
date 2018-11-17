/*G-Olf PlayerHUD*/

local CHud = {
	"CHudAmmo",
	"CHudBattery",
	//"CHudChat",
	"CHudHealth",
	"CHudSecondaryAmmo",
	"CHudWeaponSelection"
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
	Materials = {
		Circle_Frame = Material( "ghud/circle_frame.png" ),
		Circle_Hollow_Frame = Material( "ghud/circle_hollow_frame.png" )
	},
	Mini_Map = {
		Ball = Material( "icon8/minimap_ball.png" ),
		Flag = Material( "icon16/minimap_flag.png" ),
		Pointer = Material( "icon32/minimap_pointer_arrow.png" )
	},
	Power_Meter = {},
	Spin = {},
	Weapon_Selection = {},
	Wind = {}
}

/*GHUD.Club.Panel = vgui.Create( "DPanel" )
GHUD.Club.Panel:SetSize( ScrW() / 9, ScrH() / 5 )
GHUD.Club.Panel:SetPos( ScrW() - GHUD.Club.Panel:GetWide() - 20, ScrH() - GHUD.Club.Panel:GetTall() - 20 )
GHUD.Club.Panel:NoClipping( true )
function GHUD.Club.Panel:Paint( w, h )
	if !IsValid( LocalPlayer() ) then return end
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( GHUD.Materials.Circle_Frame )
	surface.DrawTexturedRect( 0, 0, w, h )
	
	local weapon = LocalPlayer():GetActiveWeapon() ~= NULL && LocalPlayer():GetActiveWeapon():GetPrintName() or "None"
	surface.SetFont( "Trebuchet18" )
	local w_w, w_h = surface.GetTextSize( weapon )
	draw.SimpleTextOutlined( weapon, "Trebuchet18", w - w - 4 - ( w_w / 2 ), h / 2, Color( 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ) )
end

GHUD.Club.ModelPanel = vgui.Create( "DModelPanel", GHUD.Club.Panel )
GHUD.Club.ModelPanel:SetSize( GHUD.Club.Panel:GetWide(), GHUD.Club.Panel:GetTall() )
GHUD.Club.ModelPanel:Center()
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
end*/

/*GHUD.Cart.Panel = vgui.Create( "DPanel" )
GHUD.Cart.Panel.ClubPosX, GHUD.Cart.Panel.ClubPosY = GHUD.Club.Panel:GetPos()
GHUD.Cart.Panel:SetSize( GHUD.Club.Panel:GetWide() / 2, GHUD.Club.Panel:GetTall() / 2 )
GHUD.Cart.Panel:SetPos( GHUD.Cart.Panel.ClubPosX - GHUD.Cart.Panel:GetWide() / 3, GHUD.Cart.Panel.ClubPosY - GHUD.Cart.Panel:GetTall() / 3 )
GHUD.Cart.Panel:MoveToBack()
function GHUD.Cart.Panel:Paint( w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( GHUD.Materials.Circle_Frame )
	surface.DrawTexturedRect( 0, 0, w, h )
end

GHUD.Cart.ModelPanel = vgui.Create( "DModelPanel", GHUD.Cart.Panel )
GHUD.Cart.ModelPanel:SetSize( GHUD.Cart.Panel:GetWide(), GHUD.Cart.Panel:GetTall() )
GHUD.Cart.ModelPanel:Center()
GHUD.Cart.ModelPanel:SetModel( "models/player/breen.mdl" )
function GHUD.Cart.ModelPanel:LayoutEntity( Entity ) return end*/

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
GHUD.Power_Meter.Panel:SetSize( ScrW() / 1.8, ScrH() / 28 )
GHUD.Power_Meter.Panel:SetPos( ScrW() / 2 - GHUD.Power_Meter.Panel:GetWide() / 2, ScrH() - GHUD.Power_Meter.Panel:GetTall() * 2 )
GHUD.Power_Meter.Panel.Last_Hit_Power = 0
function GHUD.Power_Meter.Panel:Paint( w, h )
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	draw.RoundedBox( 20, 0, 0, w, h, Color( 0, 0, 0 ) )
	draw.RoundedBox( 20, 1, 1, w - 2, h - 2, Color( 255, 255, 255 ) )
	
	if ( LocalPlayer():GetActiveWeapon() == NULL ) then return end
	if ( LocalPlayer():GetActiveWeapon().GetHitPower == nil ) then return end
	
	local Hit_Power = LocalPlayer():GetActiveWeapon():GetHitPower()
	local Max_Power = LocalPlayer():GetActiveWeapon():GetMaxPower()
	local Power_Meter = Hit_Power / Max_Power * ( w - 2 )
	
	draw.RoundedBox( 20, 1, 1, Power_Meter, h - 2, Color( 255, 100, 100 ) )
end

/*GHUD.Spin.Panel = vgui.Create( "DPanel" )
GHUD.Spin.Panel:SetSize( ScrW() / 9, ScrH() / 5 )
GHUD.Spin.Panel:SetPos( 20, ScrH() - GHUD.Spin.Panel:GetTall() - 20 )
GHUD.Spin.Panel:MoveToBack()
function GHUD.Spin.Panel:Paint( w, h )
	if !IsValid( LocalPlayer() ) then return end
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( GHUD.Materials.Circle_Frame )
	surface.DrawTexturedRect( 0, 0, w, h )
end

GHUD.Spin.ModelPanel = vgui.Create( "DModelPanel", GHUD.Spin.Panel )
GHUD.Spin.ModelPanel:SetSize( GHUD.Spin.Panel:GetWide(), GHUD.Spin.Panel:GetTall() )
GHUD.Spin.ModelPanel:Center()
GHUD.Spin.ModelPanel:SetModel( "models/golf_ball/golf_ball.mdl" )
GHUD.Spin.ModelPanel:SetLookAng( Angle( 0, 0, 0 ) )
function GHUD.Spin.ModelPanel:LayoutEntity( Entity )
	GHUD.Spin.ModelPanel:SetCamPos( Entity:GetPos() - Vector( 7, 0, 0 ) )
	Entity:SetAngles( Angle( 0, 90, 0 ) )
	
	return 
end*/

/*GHUD.Ball.Panel = vgui.Create( "DPanel" )
GHUD.Ball.Panel.SpinPosX, GHUD.Ball.Panel.SpinPosY = GHUD.Spin.Panel:GetPos()
GHUD.Ball.Panel:SetSize( GHUD.Spin.Panel:GetWide() / 2, GHUD.Spin.Panel:GetTall() / 2 )
GHUD.Ball.Panel:SetPos( GHUD.Ball.Panel.SpinPosX + ( GHUD.Ball.Panel:GetWide() / 3 * 4 ), GHUD.Ball.Panel.SpinPosY - GHUD.Ball.Panel:GetTall() / 3 )
GHUD.Ball.Panel:MoveToBack()
function GHUD.Ball.Panel:Paint( w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( GHUD.Materials.Circle_Frame )
	surface.DrawTexturedRect( 0, 0, w, h )
end*/

GHUD.Weapon_Selection.Category_Labels = {
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
end )

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
	/*Player Names*/
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