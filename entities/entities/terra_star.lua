ENT.Type = "anim"
ENT.Base = "base_entity"
 
ENT.PrintName		= "This marks stars and makes stars stars."
ENT.Author			= "Diggz"
ENT.Contact			= "steam URL /diggz"
ENT.Purpose			= "Starbro."
ENT.Instructions	= "It isn't here."
ENT.Spawnable 		= false

function ENT:Initialize()
		--The purpose of this entity is to just... exist. It just sits there and says "THIS IS A PLANET GUISE"
		--Future TODO: Store planet information in this entity, to be called when something needs it.
		--self:PhysicsInit( SOLID_NONE ) Why have a physobj?
		self:SetMoveType( MOVETYPE_NONE )
		--self:GetPhysicsObject():SetCollisionGroup(COLLISION_GROUP_WORLD)
end

if CLIENT then
function ENT:Draw() --It shouldn't draw, it shouldn't even exist.

end
end