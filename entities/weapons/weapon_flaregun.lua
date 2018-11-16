/*G-Olf Flare Gun*/

AddCSLuaFile()

if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Flare Gun"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Author = "FluXx v"
SWEP.Contact = "https://steamcommunity.com/id/fluxxv/"
SWEP.Purpose = "Fires a flare."
SWEP.Instructions = "Primary: Fire a flare."
 
SWEP.Category = "Utilities"
 
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType( "pistol" )
end

function SWEP:PrimaryAttack()
	self:EmitSound( "weapons/flaregun/fire.wav", 100, 100 )
	
	if ( CLIENT ) then return end
	
	if ( !IsValid( self.Owner ) ) then return end
	
	if ( IsValid( self.Flare ) ) then
		self.Flare:Remove()
	end
	
	self.Muzzle = self:GetAttachment( self:LookupAttachment( "muzzle" ) )
	
	self.Flare = ents.Create( "env_flare" )
	self.Flare:SetPos( self.Muzzle.Pos )
	self.Flare:SetAngles( self.Owner:GetAngles() )
	self.Flare:Fire( "Launch" )
	self.Flare:Spawn()
	
	self.Smoke = ents.Create( "env_smoketrail" )
	self.Smoke:SetPos( self.Flare:GetPos() )
	self.Smoke:SetAngles( self.Flare:GetAngles() )
	self.Smoke:SetKeyValue( "opacity", "1" )
	self.Smoke:SetKeyValue( "spawnrate", "20" )
	self.Smoke:SetKeyValue( "lifetime", "4" )
	self.Smoke:SetKeyValue( "startcolor", "255 0 0" )
	self.Smoke:SetKeyValue( "endcolor", "255 255 255" )
	self.Smoke:SetKeyValue( "startsize", "40" )
	self.Smoke:SetKeyValue( "endsize", "80" )
	self.Smoke:SetParent( self.Flare )
	self.Smoke:Spawn()
	
	self:SetNextPrimaryFire( CurTime() + 1 )
end

function SWEP:SecondaryAttack()
	if ( !IsValid( self.Flare ) ) then return end
	
	self.Explosion = ents.Create( "env_explosion" )
	self.Explosion:SetPos( self.Flare:GetPos() )
	self.Explosion:SetAngles( self.Flare:GetAngles() )
	self.Explosion:SetParent( self.Flare )
	self.Explosion:Fire( "Explode" )
	self.Explosion:Spawn()
	
	timer.Simple( 0.1, function()
		if ( !IsValid( self.Flare ) ) then return end
		
		self.Flare:Remove()
	end )
end

function SWEP:Reload()

end