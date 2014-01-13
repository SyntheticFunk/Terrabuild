TOOL.Category = 'Terrabuild'
TOOL.Name = 'Terrabuild Linker'
TOOL.Command = nil
TOOL.ConfigName = ''

if ( CLIENT ) then
	language.Add( "tool.terralink.name", "Terrabuild Linker" )
	language.Add( "tool.terralink.desc", "Allows you to link resource systems to nodes." )
	language.Add( "tool.terralink.0", "Left click to select entities, right click a node to link them to it. \n Press reload while aimed at a node to unlink all entities, and and use reload while not aimed at a node to clear your selection." )
end

function TOOL:LeftClick( trace )
	local ent = trace.Entity
	if (!IsValid(ent)) or (ent:IsPlayer()) then return end
	if ent.LSClass and ent.LSClass != "node" then
		local index = table.Count( self.Objects )
		local Phys = ent:GetPhysicsObjectNum( trace.PhysicsBone )
		self:SetObject( index + 1, ent, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal ) --works
		ent:SetColor(Color(0, 0, 255, 200))
	end
	return true

end
 
function TOOL:RightClick( trace )

	local node = trace.Entity
	if !IsValid(node) or node:IsPlayer() or !( node.LSClass == "Node" ) then return end
	local index = table.Count( self.Objects )

	if ( index > 0 ) then
		for k, v in ipairs(self.Objects) do
			local lsEnt = self:GetEnt(k)
			lsEnt:SetColor(Color(255, 255, 255, 255))
			if SERVER then
				local length = ( self:GetPos(k) - node:GetPos() ):Length() --works
				node:TerraLink( lsEnt )
			end
		end
		if SERVER then
			node:UpdateConstants( node.LinkedEnts )
		end
		self:ClearObjects()
	end
	return true
end

function TOOL:Reload(trace)
	local ent = trace.Entity
	if ent.LSClass == "node" then
		for k, node in pairs( ent.LinkedEnts ) do
			node.Linked = false
			node.LinkedTo = nil
		end
		table.Empty( ent.LinkedEnts )
		node:UpdateConstants( node.LinkedEnts )
		return true
	else
		local index = table.Count( self.Objects ) --works
		if index > 0 then
			for k, v in ipairs(self.Objects) do
				local lsEnt  = self:GetEnt(k)
				lsEnt:SetColor(Color(255, 255, 255, 255))
			end
		end
		self:ClearObjects()
		return true
	end
end

function TOOL.BuildCPanel( panel )
	panel:AddControl("Header", { Text = "Example TOOL", Description = "Just an little example" })
end
