/*G-Olf Player*/

local function GlobalPrint( str )
	PrintMessage( HUD_PRINTCONSOLE, str )
	print( str )
end

function GM:PlayerConnect( name, ip )
	if ( ip == "none" ) then return end
	
	GlobalPrint( name .. " is connecting." )
	
	net.Start( "g-olf_chat" )
		net.WriteString( name .. " is connecting." )
	net.Broadcast()
end

function GM:PlayerInitialSpawn( ply )
	GlobalPrint( ply:Name() .. " has spawned." )
	
	net.Start( "g-olf_chat" )
		net.WriteString( ply:Name() .. " has spawned." )
	net.Broadcast()
	
	ply:SetModel( player_manager.TranslatePlayerModel( ply:GetInfo( "cl_playermodel" ) ) )
end

function GM:PlayerDisconnected( ply )
	GlobalPrint( ply:Name() .. " has left." )
	
	net.Start( "g-olf_chat" )
		net.WriteString( ply:Name() .. " has left." )
	net.Broadcast()
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

local function Anti_Spam( ply )
	if ( !IsValid( ply ) ) then return end
	if ( timer.Exists( tostring( ply:SteamID() ) .. "_netCountAntiSpam" ) ) then
		net.Start( "g-olf_chat" )
			net.WriteString( "Please refrain from spamming chat, " .. ply:GetName() .. "." )
		net.Send( ply )
		
		return true 
	end
	
	if ( ply.netCount == nil ) then
		ply.netCount = 1
	elseif ( ply.netCount < 5 ) then
		ply.netCount = ply.netCount + 1
	else
		if !( timer.Exists( tostring( ply:SteamID() ) .. "_netCountAntiSpam" ) ) then
			timer.Create( tostring( ply:SteamID() ) .. "_netCountAntiSpam", 5, 1, function()
				if ( !IsValid( ply ) ) then return end
				
				ply.netCount = 0
			end )
			
			net.Start( "g-olf_chat" )
				net.WriteString( "Please refrain from spamming chat, " .. ply:GetName() .. "." )
			net.Send( ply )
		end
		
		return true
	end
	
	timer.Create( "netCountReset", 2, 1, function()
		if ( !IsValid( ply ) ) then return end
			
		ply.netCount = 0
	end )
	
	return false
end

function GM:PlayerSay( ply, text, teamChat )
	if ( !IsValid( ply ) ) then return "" end
	if ( type( text ) ~= "string" ) then return "" end
	if ( Anti_Spam( ply ) ) then return "" end
	
	GlobalPrint( ply:GetName() .. ": " .. text )
	
	net.Start( "g-olf_chat" )
		net.WriteString( ply:GetName() .. ": " .. text )
	net.Broadcast()

	return ""
end

net.Receive( "g-olf_chat", function( len, ply )
	local text = net.ReadString()
	
	if ( !IsValid( ply ) ) then return end
	if ( type( text ) ~= "string" ) then return end
	if ( Anti_Spam( ply ) ) then return end
	
	GlobalPrint( ply:GetName() .. ": " .. text )
	
	net.Start( "g-olf_chat" )
		net.WriteString( tostring( ply:GetName() .. ": " .. text ) )
	net.Broadcast()
end )

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
