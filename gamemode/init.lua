/*G-Olf*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

AddCSLuaFile( "cl_chatbox.lua" )
AddCSLuaFile( "player_hud.lua" )
AddCSLuaFile( "player.lua" )
AddCSLuaFile( "player_inventory.lua" )
AddCSLuaFile( "player_scorecard.lua" )

include( "shared.lua" )
include( "player.lua" )

local function AddResources( golf_files, golf_directories, path )
	if ( golf_files == nil or golf_directories == nil ) then return end
	
	for k, v in pairs( golf_files ) do
		local file_path = string.Replace( path .. v, "gamemodes/g-olf/content/", "" )
		resource.AddFile( file_path )
	end
	
	for k, v in pairs( golf_directories ) do
		local new_files, new_directories = file.Find( path .. v .. "/*", "GAME" )
		local new_path = path .. v .. "/"
		AddResources( new_files, new_directories, new_path )
	end
end

local golf_files, golf_directories = file.Find( "gamemodes/g-olf/content/*", "GAME" )
AddResources( golf_files, golf_directories, "gamemodes/g-olf/content/" )