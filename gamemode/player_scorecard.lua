/*G-Olf Scorecard*/

local Scorecard = vgui.Create( "DPanel" )
Scorecard:SetSize( ScrW() / 2, ScrH() / 1.5 )
Scorecard:Center()
Scorecard:SetVisible( false )
Scorecard:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
Scorecard.FirstOpen = false
Scorecard:MakePopup()

Scorecard.Header = vgui.Create( "DPanel", Scorecard )
Scorecard.Header:SetSize( Scorecard:GetWide(), Scorecard:GetTall() / 10 )
Scorecard.Header:SetPos( 0, 0 )

Scorecard.Header.Logo = vgui.Create( "DImage", Scorecard )
Scorecard.Header.Logo:SetPos( 0, 0 )
Scorecard.Header.Logo:SetSize( Scorecard.Header:GetTall(), Scorecard.Header:GetTall() )
Scorecard.Header.Logo:SetImage( "scorecard/logo.png" )

Scorecard.Header.Server_Name = vgui.Create( "DLabel", Scorecard.Header )
Scorecard.Header.Server_Name:SetSize( Scorecard.Header:GetWide(), Scorecard.Header:GetTall() )
Scorecard.Header.Server_Name:SetPos( 0, -10 )
Scorecard.Header.Server_Name:SetContentAlignment( 5 )
Scorecard.Header.Server_Name:SetDark( true )
Scorecard.Header.Server_Name:SetFont( "GModNotify" )
Scorecard.Header.Server_Name:SetText( GetHostName() )

Scorecard.Header.Map_Name = vgui.Create( "DLabel", Scorecard.Header )
Scorecard.Header.Map_Name:SetSize( Scorecard.Header:GetWide(), Scorecard.Header:GetTall() )
Scorecard.Header.Map_Name:SetPos( 0, 10 )
Scorecard.Header.Map_Name:SetContentAlignment( 5 )
Scorecard.Header.Map_Name:SetDark( true )
Scorecard.Header.Map_Name:SetFont( "GModNotify" )
Scorecard.Header.Map_Name:SetText( game.GetMap() )

Scorecard.Course_Card_Hole = vgui.Create( "DPanel", Scorecard )
Scorecard.Course_Card_Hole:SetSize( Scorecard:GetWide(), Scorecard:GetTall() / 20 )
Scorecard.Course_Card_Hole:SetPos( 0, Scorecard:GetTall() / 10 )
Scorecard.Course_Card_Hole:SetBackgroundColor( Color( 180, 255, 180 ) )

Scorecard.Course_Card_Hole.Title = vgui.Create( "DLabel", Scorecard.Course_Card_Hole )
Scorecard.Course_Card_Hole.Title:SetSize( Scorecard.Course_Card_Hole:GetWide() / 10, Scorecard.Course_Card_Hole:GetTall() )
Scorecard.Course_Card_Hole.Title:SetPos( 0, 0 )
Scorecard.Course_Card_Hole.Title:SetDark( true )
Scorecard.Course_Card_Hole.Title:SetContentAlignment( 6 )
Scorecard.Course_Card_Hole.Title:SetFont( "Trebuchet18" )
Scorecard.Course_Card_Hole.Title:SetText( "Hole" )

// Course Holes
local Hole_Row = {
	[9] = "OUT",
	[18] = "IN",
	[19] = "TOTAL"
}
for i = 0, 19 do
	local Card_Width = Scorecard.Course_Card_Hole:GetWide() - ( Scorecard.Course_Card_Hole:GetWide() / 10 )
	
	local Hole = vgui.Create( "DLabel", Scorecard.Course_Card_Hole )
	Hole:SetSize( Card_Width / 20, Scorecard.Course_Card_Hole:GetTall() )
	Hole:SetPos( ( Scorecard.Course_Card_Hole:GetWide() / 10 ) + ( Card_Width / 20 * i ), 0 )
	Hole:SetDark( true )
	Hole:SetContentAlignment( 5 )
	Hole:SetFont( "Trebuchet18" )
	
	local text = Hole_Row[i] && Hole_Row[i] or i + 1
	Hole:SetText( text )
end

Scorecard.Divider = vgui.Create( "DPanel", Scorecard ) // Divider between the player list and the course information ( placed here so it renders under the par row )
Scorecard.Divider:SetSize( Scorecard:GetWide(), 5 )
Scorecard.Divider:SetPos( 0, ( Scorecard:GetTall() / 10 ) * 2 )
Scorecard.Divider:SetBackgroundColor( Color( 50, 50, 50 ) )

Scorecard.Course_Card_Par = vgui.Create( "DPanel", Scorecard )
Scorecard.Course_Card_Par:SetSize( Scorecard:GetWide(), Scorecard:GetTall() / 20 )
Scorecard.Course_Card_Par:SetPos( 0, Scorecard:GetTall() / 10 + Scorecard:GetTall() / 20  )
Scorecard.Course_Card_Par:SetBackgroundColor( Color( 200, 255, 200 ) )

Scorecard.Course_Card_Par.Title = vgui.Create( "DLabel", Scorecard.Course_Card_Par )
Scorecard.Course_Card_Par.Title:SetSize( Scorecard.Course_Card_Par:GetWide() / 10, Scorecard.Course_Card_Par:GetTall() )
Scorecard.Course_Card_Par.Title:SetPos( 0, 0 )
Scorecard.Course_Card_Par.Title:SetDark( true )
Scorecard.Course_Card_Par.Title:SetContentAlignment( 6 )
Scorecard.Course_Card_Par.Title:SetFont( "Trebuchet18" )
Scorecard.Course_Card_Par.Title:SetText( "Par" )

// Hole Pars
local Par_Row = {
	[9] = 9, // map info: out
	[18] = 9, // map_info: in
	[19] = 18 // map_info: sum of in + out
}
for i = 0, 19 do
	local card_width = Scorecard.Course_Card_Par:GetWide() - ( Scorecard.Course_Card_Par:GetWide() / 10 )
	
	local par = vgui.Create( "DLabel", Scorecard.Course_Card_Par )
	par:SetSize( card_width / 20, Scorecard.Course_Card_Par:GetTall() )
	par:SetPos( ( Scorecard.Course_Card_Par:GetWide() / 10 ) + ( card_width / 20 * i ), 0 )
	par:SetDark( true )
	par:SetContentAlignment( 5 )
	par:SetFont( "Trebuchet18" )
	
	local text = Par_Row[i] && Par_Row[i] or 1
	par:SetText( text )
end

Scorecard.Players = vgui.Create( "DScrollPanel", Scorecard )
Scorecard.Players:SetSize( Scorecard:GetWide(), Scorecard:GetTall() - ( Scorecard:GetTall() / 10 ) * 2 )
Scorecard.Players:SetPos( 0, ( Scorecard:GetTall() / 10 ) * 2 + 1 )
local VBar = Scorecard.Players:GetVBar()
function Scorecard.Players:OnScrollbarAppear()
	VBar:SetSize( 0, 0 )
end

Scorecard.Players.Refresh = function()
	Scorecard.Players:Clear()
	
	for k, v in pairs( player.GetAll() ) do
		local colour = tobool( k % 2 ) && Color( 255, 255, 160 ) or Color( 255, 255, 200 )
		
		local ply = Scorecard.Players:Add( vgui.Create( "DPanel" ) )
		ply:Dock( TOP )
		ply:SetSize( Scorecard:GetWide(), Scorecard:GetTall() / 20 )
		ply:SetBackgroundColor( colour )
		
		if ( v ~= LocalPlayer() ) then
			ply.Mute = vgui.Create( "DImageButton", ply )
			ply.Mute:SetSize( ply:GetTall() / 2, ply:GetTall() / 2 )
			ply.Mute:SetPos( ply:GetTall() / 2.5, ply:GetTall() / 4 )
			if !( v:IsMuted() ) then
				ply.Mute:SetImage( "icon16/sound.png" )
			else
				ply.Mute:SetImage( "icon16/sound_mute.png" )
			end
			
			ply.Mute.DoClick = function()
				if !( v:IsMuted() ) then
					v:SetMuted( true )
					
					ply.Mute:SetImage( "icon16/sound_mute.png" )
				else
					v:SetMuted( false )
					
					ply.Mute:SetImage( "icon16/sound.png" )
				end
			end
		end
		
		ply.Name = vgui.Create( "DLabel", ply )
		ply.Name:SetSize( ply:GetWide() / 7, ply:GetTall() )
		ply.Name:SetContentAlignment( 5 )
		ply.Name:SetDark( true )
		ply.Name:SetFont( "Trebuchet18" )
		ply.Name:SetText( v:GetName() )
		
		local Ply_Score_Row = {
			[ 9 ] = 0,
			[ 18 ] = 0,
			[ 19 ] = 0,
		}
		for i = 0, 19 do
			local card_width = ply:GetWide() - ( ply:GetWide() / 10 )
			
			local par = vgui.Create( "DLabel", ply )
			par:SetSize( card_width / 20, ply:GetTall() )
			par:SetPos( ( ply:GetWide() / 10 ) + ( card_width / 20 * i ), 0 )
			par:SetDark( true )
			par:SetContentAlignment( 5 )
			par:SetFont( "Trebuchet18" )
			
			local score = Ply_Score_Row[i] && Ply_Score_Row[i] or 0
			par:SetText( score )
		end
	end
end

gameevent.Listen( "player_spawn" )
hook.Add( "player_spawn", "g-olf", function( data )
	local id = data.userid
	local ply = Player( id )
	
	if !( ply.InitialSpawn ) then
		ply.InitialSpawn = true
		
		timer.Simple( 0.1, function()
			Scorecard.Players.Refresh()
		end )
	end
end )

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "g-olf", function( data )
	timer.Simple( 0.1, function()
		Scorecard.Players.Refresh()
	end )
end )

function ShowScorecard()
	if !( Scorecard.FirstOpen ) then
		Scorecard.Players.Refresh()
		
		Scorecard.FirstOpen = true
	end
	Scorecard:SetVisible( true )
	
	return false
end
hook.Add( "ScoreboardShow", "ShowScoreCard", ShowScorecard )

function HideScorecard()
	Scorecard:SetVisible( false )
end
hook.Add( "ScoreboardHide", "HideScorecard", HideScorecard )