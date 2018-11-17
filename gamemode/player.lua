/*G-Olf Player*/

function GM:PlayerInitialSpawn( ply )
	PrintMessage( HUD_PRINTTALK, ply:Name() .. " has joined the server." )
	
	ply:SetModel( player_manager.TranslatePlayerModel( ply:GetInfo( "cl_playermodel" ) ) )
end

function GM:PlayerDisconnected( ply )
	PrintMessage( HUD_PRINTTALK, ply:Name() .. " has left the server." )
end

function GM:PlayerLoadout( ply )
	ply:Give( "weapon_driver" )
	ply:Give( "weapon_3wood" )
	/*ply:Give( "weapon_5wood" )
	ply:Give( "weapon_7wood" )
	ply:Give( "weapon_3iron" )
	ply:Give( "weapon_4iron" )
	ply:Give( "weapon_5iron" )
	ply:Give( "weapon_6iron" )
	ply:Give( "weapon_7iron" )
	ply:Give( "weapon_8iron" )
	ply:Give( "weapon_9iron" )
	ply:Give( "weapon_pitchingwedge" )
	ply:Give( "weapon_sandwedge" )*/
	ply:Give( "weapon_putter" )
	ply:Give( "weapon_flaregun" )
	ply:Give( "weapon_rangefinder" )

	return true
end

function GM:GravGunPickupAllowed( ply, ent )
	if ( !IsValid( ent ) or !IsValid( ply ) ) then return end
	
	if ( ent:GetClass() == "golf_ball" ) then
		return false
	end
end

function GM:GravGunPunt( ply, ent )
	if ( !IsValid( ent ) or !IsValid( ply ) ) then return end
	
	if ( ent:GetClass() == "golf_ball" ) then
		return false
	end
end

function GM:PhysgunPickup( ply, ent )
	if ( !IsValid( ent ) or !IsValid( ply ) ) then return end
	
	if ( ent:GetClass() == "golf_ball" ) then
		return false
	end
end

concommand.Add( "cart", function( ply ) // debugging for golf cart
	if ( !IsValid( ply ) ) then return end
	
	local cart = ents.Create( "sent_ball" )
	if ( !IsValid( cart ) ) then return end
	cart:SetPos( ply:GetForward() * 60 )
	cart:Spawn()
end )

local function SpawnGolfBall( ply ) // debugging for golf ball
	if ( !IsValid( ply ) ) then return end
	if ( IsValid( ply.Golf_Ball ) ) then return end
	
	local colour = ply:GetInfo( "cl_golfballcolour" ) .. " 255"
	
	local Tee = ents.Create( "prop_physics" )
	Tee:SetModel( "models/tee/tee.mdl" )
	Tee:SetPos( ply:GetEyeTrace().HitPos + Vector( 0, 0, 0.5 ) )
	Tee:SetColor( string.ToColor( colour ) )
	Tee:SetCollisionGroup( COLLISION_GROUP_WORLD )
	Tee:SetSolid( SOLID_NONE )
	
	local Ball = ents.Create( "golf_ball" )
	if ( !IsValid( Ball ) ) then return end
	Ball:SetColor( string.ToColor( colour ) )
	Ball:SetOwner( ply )
	Ball.Tee = Tee
	Ball:Spawn()
	
	Ball:SetPos( Tee:GetPos() + Vector( 0, 0, Ball:OBBMaxs().z * 2.83 ) )
	
	ply.Golf_Ball = Ball
end
concommand.Add( "undo", SpawnGolfBall )
concommand.Add( "gmod_undo", SpawnGolfBall )

concommand.Add( "golf_noclip", function( ply, cmd, args )  // debugging
	if !IsValid( ply ) then return end
	
	if ( ply:GetMoveType() ~= MOVETYPE_NOCLIP ) then
		ply:SetMoveType( MOVETYPE_NOCLIP )
	elseif ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then
		ply:SetMoveType( MOVETYPE_WALK )
	end
end )
