--[[

Okay, we're gonna need to do this the hard way. We can't rip it from spacebuild because spacebuild doesnt work right with what we want to do. This shit is gonna require
a full rewrite. 

Ok so
Step 1)	FInd how spacebuild 3 detects the brush entities and whatever

Step 2) Spawn a entity that cant be collided with and isn't drawn (draw it for testing) in the center of the planet. Put the radius of the planet as a variable on it.
Also possibly a "habitable" variable. Add them all to a table too for easy lookup.

Step 3) Just do a check every second or so for all players, and if they're within a planet ents radius then bam, you dont die.

Got joey to verify, the logic cases are in the very center of planets. So our radius thang will work perfectly :D

]]--
--[[
This is pretty fucking esoteric, but thankfully rather simplistic.  Blank = Carried to the right from left
Case1 seems to be the planets class
Table:    Planet1					Planet2			Cube		Star2
Case2 -- radius
Case3 -- gravity												temp1
Case4 -- atmosphere (wat?)										temp2
Case5 -- temperature (S temp?)		Pressure					temp3
Case6 -- temperature (L Temp? )		STemp						name
Case7 -- Color ID					LTemp
Case8 -- Bloom ID					Flags
Case9								Oxygen
Case10								CO2
Case11								N2
Case12								H2
Case13								Name
Case14								
Case15 -- disabled?					ColorID
Case16 -- flags						BloomID
]]--
--[[
if SERVER then
	
	CreateConVar( "space_forceactive", 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED } )
	
	if game.GetMap():sub(1,3) ~= "sb_" then
		print( "Not a Spacebuild map!" )
		return
	end
	
else
	
	CreateClientConVar( "space_forceactive", 0, true, false )
	
	if game.GetMap():sub(1,3) ~= "sb_" then
		print( "Not a Spacebuild map!" )
		return
	end
	
end]]--
planetoids = {}

function CleanPlanetTable( marker, tab )
	local product = {}
	if tab.Case01 == "planet" then
		product.entity = marker
		product.class = tab.Case01
		product.name = "No Data"
		product.radius = tonumber(tab.Case02)
		product.gravity = tonumber(tab.Case03)
		product.atmosphere = tonumber(tab.Case04)
		product.stemp = tonumber(tab.Case05)
		product.ltemp = tonumber(tab.Case06)
	elseif tab.Case01 == "planet2" or tab.Case01 == "cube" then
		product.entity = marker
		product.class = tab.Case01
		product.name = tostring(tab.Case13)
		product.radius = tonumber(tab.Case02)
		product.gravity = tonumber(tab.Case03)
		product.atmosphere = tonumber(tab.Case04)
		product.pressure = tonumber(tab.Case05)
		product.stemp = tonumber(tab.Case06)
		product.ltemp = tonumber(tab.Case07)
		product.oxygen = tonumber(tab.Case09)
	elseif tab.Case01 == "star2" then
		product.entity = marker
		product.class = tab.Case01
		product.name = tostring(tab.Case06)
		product.surfacetemp = math.max( tonumber(tab.Case03), tonumber(tab.Case04), tonumber(tab.Case05) )
	elseif tab.Case01 == "star" then
		product.entity = marker
		product.class = tab.Case01
		product.name = "No Data"
	end
	return product
end

function InSpace( ent )
	if not ent or not IsValid(ent) or not ent.GetPos then return end
	for k, v in pairs( planetoids ) do
		if ent:GetPos():Distance( planetoids[k].entity:GetPos() ) > planetoids[k].radius then
				if planetoids[k].class ~= "star" or planetoids[k].class ~= "star2" then
					return true, planetoids[k].gravity
				end
			else
			return false
		end
	end
end

function PlanetDetection()
	if SERVER then
		for id, ent in pairs(ents.GetAll()) do
			space, gravity = InSpace( ent )
			if ent:IsPlayer() then
				if space then
					ent:SetGravity( 1 / 9e9 )
					ent:SetMoveType( MOVETYPE_WALK )
				else
					if gravity then
						ent:SetGravity( gravity )
					end
				end
			else
				if space then
					ent:GetPhysicsObject():EnableGravity( false )
				else
					ent:GetPhysicsObject():EnableGravity( true )
					if gravity then
						ent:SetGravity( gravity )
					end
				end
			end	
		end
	end
end


function QueryPlanetoids()
	for k, v in pairs( ents.FindByClass( "logic_case" ) ) do
		
		if v and v:IsValid() and v:GetClass() == "logic_case" and tonumber( v:GetKeyValues().Case02 ) then
			local cases = v:GetKeyValues()
				if cases.Case01 == "planet2" or cases.Case01 == "planet" or cases.Case01 == "cube" then
					local marker = ents.Create( "terra_planet" )
					marker:SetPos( v:GetPos() )
					planetoids[k] = CleanPlanetTable( marker, cases)
				elseif cases.Case01 == "star2" or cases.Case01 == "star" then
					local marker = ents.Create( "terra_star" )
					marker:SetPos( v:GetPos() )
					planetoids[k] = CleanPlanetTable(marker, cases)
				end
		end
	end
	timer.Create( "GravityUpdate", 1, 0, PlanetDetection )
end

hook.Add( "InitPostEntity", "Terra_Planet_Init", QueryPlanetoids )

