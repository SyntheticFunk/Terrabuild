AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("entities/sent_prop.lua")
AddCSLuaFile("entities/terra_planet.lua")
AddCSLuaFile("entities/terra_star.lua")
AddCSLuaFile("entities/terra_node.lua")
AddCSLuaFile("entities/gen_solar_small.lua")
AddCSLuaFile("entities/stor_small_energy.lua")
AddCSLuaFile("entities/weapons/gmod_tool/stools/terralink.lua")
AddCSLuaFile("spropprotection/sh_SPropProtection.lua")
AddCSLuaFile( "shrinking.lua" )
include( 'shared.lua' )
include( 'spropprotection/sh_SPropProtection.lua' )
include( 'shrinking.lua' )

if SERVER then
		
	if game.GetMap():sub(1,3) ~= "sb_" then
		print( "Not a spacebuild map, disabling space code!" )
		return
	else
		include( 'Space.lua' )
	end
	
end