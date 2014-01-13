ENT.Type = "anim"
ENT.Base = "base_entity"
 
ENT.PrintName		= "Node"
ENT.Author			= "Diggz"
ENT.Contact			= "steam URL /diggz"
ENT.Purpose			= "Central control for life support."
ENT.Instructions	= "link things to it for justice."
ENT.Spawnable 		= true

ENT.LSClass			= "Node"

if SERVER then
--[[
Okay, so I'm thinking we should do almost all the calculations in the node entity.
Create a permanent local table stored in the entity table, lets use ENT.LinkedEnts
Donovan: you seem to want continuous-fire energy weapons
Donovan: and shields
Diggz: energy weapons
Diggz: yeah
Diggz: actually
Diggz: thats a great idea
Diggz: Even the single shot stuff will have a short charge period of continuous draw before poot

]]--
function ENT:Initialize()
 
	self:SetModel( "models/props_interiors/BathTub01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.LinkedEnts = {}
	self.LinkRange = 128
	self.LinkedStorage = {}
	self.LinkedGens = {}
	self.EnergyStorage = 0
	self.EnergyDrain = 0
	self.EnergyGain = 0
	self.AirStorage = 0
	self.AirDrain = 0
	self.AirGain = 0
	self.Energy = 0
	self.Air = 0
	

end
 
function ENT:Use( activator, caller )
    return --Turn it up and down and all around.
end

local consecutivethinks = 0
function ENT:Think()
	local initEnergy = self.Energy
	self.Energy = initEnergy + self.EnergyGain - self.EnergyDrain --Decay occurs roughly at a rate equivalent to Init:Tau, so for 10:1, we see a loss of 1% per second.
	--self.Energy = nrg
--[[	if self.Energy == initEnergy then 
		consecutivethinks = consecutivethinks + 1
		self.Energy = self.Energy * ( 1 - math.exp( ( - consecutivethinks ) / 10 ) )
	else
	consecutivethinks = 0
	end]]--
	self.Air = self.Air + self.AirGain - self.AirDrain
	print(self.Energy)
	self:NextThink( CurTime() + 1 ) 
	return true

end

function ENT:UpdateConstants( tab ) -- Feed this function a table of all of our entities (linked ents) --Make this in the node ent, go ENT:UpdateConstants( tab ) then just call it here.
--Calculate our total storage amounts and output a table in Energy and Air, fuel will be added later.
self.EnergyStorage = 0
self.AirStorage = 0
self.EnergyGain = 0
self.EnergyDrain = 0
self.AirGain = 0
self.AirDrain = 0
self.LinkedStorage = {}
self.LinkedGens = {}
print(table.Count( tab ))
	if table.Count( tab ) > 0 then
	
		for index, ent in pairs ( tab ) do
			if ent.LSClass == "Storage" then
				if ent.StorageType == "Energy" then
					self.EnergyStorage = self.EnergyStorage + ent.StorageAmount --To work within this framework, the entity needs a LSClass string denoting whether its a gen, storage, or something else
				elseif ent.StorageType == "Air" then							--as well as a StorageType string denoting what kind of resource it stores, and a StorageAmount number denoting the quantity it stores.
					self.AirStorage = self.AirStorage + ent.StorageAmount
				end
				table.insert(self.LinkedStorage, ent)
			elseif ent.LSClass == "Generator" then
				if ent.GenType == "Energy" then
					self.EnergyGain = self.EnergyGain + ent.GenQuantity		--To work within this framework, the generator needs a GenType string in its entity table, as well as a GenQuantity string denoting how much it generates
					--self.EnergyDrain = self.EnergyDrain + ent.Wattage	-- on a per second basis. Energy units are Joules, air in Kg, and fuel will probably also be in Kg.
				elseif ent.GenType == "Air" then						
					self.AirGain = self.AirGain + ent.GenQuantity
					self.EnergyDrain = self.EnergyDrain + ent.Wattage	-- Everything is going to need to use energy, and the ents wil need their energy usage in watts stored as Wattage
				end
				table.insert(self.LinkedGens, ent)
			end
		end
	end
end

function ENT:TerraLink( ent )
	--Compare whether or not the entity can be linked, then link it to the node.
	local class = ent.LSClass
	if class and class != "Node" and !ent.Linked then
		table.insert( self.LinkedEnts, ent )
		ent.Linked = true
		ent.LinkedTo = self
		return true
	else
		return false
	end
end

function ENT:TerraUnLink( ent )
	local tab = self.LinkedEnts
	for k, ent in pairs ( tab ) do
		if tab[k] == ent then
			table.remove( tab, ent )
			ent.Linked = false
			ent.LinkedTo = nil
		end
	end
end

else
	function ENT:Draw()
		self:DrawModel() --TODO: Wire input to disable overlay
		--AddWorldTip( self:EntIndex(), "Energy: " .. self.Energy .. " Max: " .. self.EnergyStorage, 0.5, self:GetPos(), self  ) -- Add an example tip.
	end
	 
end