ENT.Type = "anim"
ENT.Base = "base_entity"
 
ENT.PrintName		= "Vegan Power"
ENT.Author			= "Diggz"
ENT.Contact			= "steam URL /diggz"
ENT.Purpose			= "Lowers power bills."
ENT.Instructions	= "Place under sun."
ENT.Spawnable 		= true

ENT.LSClass			= "Generator"

if SERVER then
function ENT:Initialize()
 
	self:SetModel( "models/props_interiors/BathTub01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.GenType = "Energy"
	self.GenQuantity = "10"
	self.Linked = false
	self.LinkedTo = nil
	self.Active = false
	--self.Wattage = "Unavailable"
end

function ENT:Use( activator, caller )
    return
end

else
	function ENT:Draw()
		self:DrawModel() 
	end
	 
end

