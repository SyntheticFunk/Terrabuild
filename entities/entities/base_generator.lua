ENT.Type = "anim"
ENT.Base = "base_entity"
 
ENT.PrintName		= "Generating Name"
ENT.Author			= "Diggz"
ENT.Contact			= "steam URL /diggz"
ENT.Purpose			= "Makes things."
ENT.Instructions	= "I have something for you."
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
	self.LSClass = "Generator"
	self.GenType = "Unavailable"
	self.GenQuantity = "Unavailable"
	self.Wattage = "Unavailable"
end


function ENT:Use( activator, caller )
    return
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel() 
	end
	 
end