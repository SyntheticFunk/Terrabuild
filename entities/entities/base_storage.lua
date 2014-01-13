ENT.Type = "anim"
ENT.Base = "base_entity"
 
ENT.PrintName		= "Storage Container"
ENT.Author			= "Diggz"
ENT.Contact			= "steam URL /diggz"
ENT.Purpose			= "Holds things."
ENT.Instructions	= "Put it in me."
ENT.Spawnable 		= false


function ENT:Initialize()
 
	self:SetModel( "models/props_interiors/BathTub01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.LSClass = "Storage"
	self.StorageType = "Unavailable"
	self.StorageAmount = "Unavailable"
	self.Wattage = "Unavailable"
end

function ENT:Use( activator, caller )
    return
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel() 
		AddWorldTip( self:EntIndex(), "Sample Text", 0.5, self:GetPos(), self  ) -- Add an example tip.
	end
	 
end