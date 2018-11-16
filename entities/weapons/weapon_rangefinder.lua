/*G-Olf Rangefinder*/

AddCSLuaFile()

if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Rangefinder"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Author = "FluXx v"
SWEP.Contact = "https://steamcommunity.com/id/fluxxv/"
SWEP.Purpose = "Finds the range to where you are aiming."
SWEP.Instructions = "Secondary: Zoom in to find range."
 
SWEP.Category = "Utilities"
 
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
SWEP.ViewModel = "models/weapons/c_arms_animations.mdl"
SWEP.WorldModel = "models/MaxOfS2D/camera.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Zoom" )
	
	self:SetZoom( false )
end

function SWEP:Initialize()
	self:SetHoldType( "camera" )
end

local function SetZoom( swep, bVal )
	if ( !IsValid( swep.Owner ) ) then return end
	
	if ( bVal ) then
		swep.Owner:SetFOV( 30, 1 )
		
		swep:SetZoom( true )
	else
		swep.Owner:SetFOV( swep.Owner:GetInfo( "fov_desired" ), 1 )
	
		swep:SetZoom( false )
	end
end

function SWEP:Deploy()
	SetZoom( self, false )
	
	self:SetZoom( false )
end

function SWEP:PrimaryAttack()
	
end

function SWEP:SecondaryAttack()
	if !( IsFirstTimePredicted() ) then return end
	
	SetZoom( self, !self:GetZoom() )
end

function SWEP:Reload()

end

function SWEP:DrawHUD()
	if ( self:GetZoom() ) then
		local Distance = 0.01905 * self.Owner:GetEyeTrace().HitPos:Distance( self.Owner:GetPos() )
		local Pos = Vector( ScrW() / 2 + 45, ScrH() / 2 + 25, 0 )
		local Text_Width, Text_Height = surface.GetTextSize( Distance .. "m" )
			
		draw.SimpleTextOutlined( math.Round( Distance, 1 ) .. "m", "Trebuchet18", Pos.x, Pos.y, Color( 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0 ) )
		
		cam.Start3D()
			render.SetMaterial( Material( "sprites/redglow1" ) )
			render.DrawSprite( self.Owner:GetEyeTrace().HitPos, 16, 16, Color( 255, 255, 255 ) )
		cam.End3D()
	end
end