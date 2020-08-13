/*G-Olf 9-Iron*/

AddCSLuaFile()

if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "9-Iron"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true // default false
end

SWEP.Author = "FluXx v"
SWEP.Contact = "https://steamcommunity.com/id/fluxxv/"
SWEP.Purpose = "Drives."
SWEP.Instructions = "Left Click: Swing. Right Click: Set Power. Reload: Resets Power."
 
SWEP.Category = "Iron"
 
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local Swing_Sound = "weapons/slam/throw.wav"
local Hit_Sound = "weapons/crossbow/hit1.wav"

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "SideView" )
	self:NetworkVar( "Int", 0, "HitAngle" )
	self:NetworkVar( "Int", 1, "HitPower" )
	self:NetworkVar( "Int", 2, "MaxPower" )
	
	self:SetSideView( false )
	self:SetMaxPower( 2900 )
	self:SetHitAngle( 48 )
end

function SWEP:Deploy()
	self:SetHitPower( 0 )
	self.Power_Up = false
	self.Power_Down = false
end

function SWEP:PrimaryAttack()
	if !( self.Power_Up && self.Power_Down ) then
		self.Power_Up = true
	end
	
	if ( self.Power_Up or self.Power_Down ) then
		if ( self:GetHitPower() > 0 ) then
			self:EmitSound( Swing_Sound, 100, 100 )
			
			local ent = self.Owner:GetEyeTrace().Entity
			
			if ( !IsValid( ent ) or ent:GetOwner() ~= self.Owner or ent:GetVelocity():Length() > 0 ) then
				self:SetHitPower( 0 )
				self:SetHitAngle( 0 )
				self.Power_Up = false
				self.Power_Down = false
				
				return 
			end
			
			if ( ent:GetClass() == "golf_ball" && self.Owner:GetPos():Distance( ent:GetPos() ) < 50 ) then
				local physobj = ent:GetPhysicsObject()
				
				if IsValid( physobj ) then
					physobj:SetVelocity( -self.Owner:GetRight() * self:GetHitPower() + Vector( 0, 0, self:GetHitAngle() ) )
					ent:EmitSound( Hit_Sound, 100, 100 )
				end
			end
			
			self:SetHitPower( 0 )
			self:SetHitAngle( 0 )
			self.Power_Up = false
			self.Power_Down = false
		end
	end
end

function SWEP:SecondaryAttack()
	self:SetSideView( true )
end

function SWEP:CalcView( ply, pos, ang, fov ) // Side-View
	if ( ply:KeyDown( IN_ATTACK2 ) ) then
		pos = pos + ply:GetForward() * 65 + ply:GetRight() * 150 + Vector( 0, 0, 20 )
		ang = ang + Angle( -ply:GetAngles().p, 90, 0 )
		fov = fov
		
		return pos, ang, fov
	end
end

function SWEP:Reload()

end

function SWEP:Think()
	if ( self.Power_Up ) then
		if ( self:GetHitPower() < self:GetMaxPower() ) then
			self:SetHitPower( self:GetHitPower() + 25 )
			self:SetHitAngle( self:GetHitAngle() + 15 )
		else
			self.Power_Up = false
			self.Power_Down = true
		end
	elseif ( self.Power_Down ) then
		if ( self:GetHitPower() > 0 ) then
			self:SetHitPower( self:GetHitPower() - 25 )
			self:SetHitAngle( self:GetHitAngle() - 15 )
		else
			self.Power_Down = false
		end
	end
	
	if ( self:GetSideView() && !self.Owner:KeyDown( IN_ATTACK2 ) ) then
		self:SetSideView( false )
	end
end