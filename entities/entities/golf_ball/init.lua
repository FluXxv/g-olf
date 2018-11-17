// Golf Ball

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/golf_ball/golf_ball.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end
	
	local max = self:OBBMaxs() / 1.6
	self:PhysicsInitSphere( max.x, "concrete" )
	self:SetCollisionBounds( Vector( -max.x, -max.x, -max.x ), Vector( max.x, max.x, max.x ) )
	
	self.Trail = util.SpriteTrail( self, 0, Color( 255, 255, 255 ), true, 2, 2, 1, 1 / ( 2 + 2 ) * 0.5, "sprites/laserbeam" )
end

function ENT:Think()
	if ( !IsValid( self:GetOwner() ) ) then
		if ( IsValid( self.Tee ) ) then
			self.Tee:Remove()
			self.Tee = nil
		end
		self:Remove()
		
		return 
	end
	
	local ply = self:GetOwner()
	local colour = string.ToColor( ply:GetInfo( "cl_golfballcolour" ) .. " 255" )
	
	if ( self:GetColor() ~= colour ) then
		self:SetColor( colour )
		self.Trail:SetColor( colour )
	end
	
	local phys = self:GetPhysicsObject()
	if ( math.Round( phys:GetVelocity():Length() ) > 0 && math.Round( phys:GetVelocity().z ) == 0 ) then
		phys:SetVelocity( phys:GetVelocity() / 1.1 )
	end
	
	if ( self.FirstHit && IsValid( self.Tee ) && phys:GetVelocity():Length() == 0 ) then
		self.Tee:Remove()
		self.Tee = nil
	end
end