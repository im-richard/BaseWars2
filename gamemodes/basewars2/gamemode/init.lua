/*
    @product        : basewars
    @docs           : https://basewars2.rlib.io

    IF YOU HAVE NOT DIRECTLY RECEIVED THESE FILES FROM THE DEVELOPER, PLEASE CONTACT THE DEVELOPER
    LISTED ABOVE.

    THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE
    ('CCPL' OR 'LICENSE'). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF
    THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.

    BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE TERMS
    OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS
    YOU THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND CONDITIONS.

    UNLESS OTHERWISE MUTUALLY AGREED TO BY THE PARTIES IN WRITING, LICENSOR OFFERS THE WORK AS-IS AND
    ONLY TO THE EXTENT OF ANY RIGHTS HELD IN THE LICENSED WORK BY THE LICENSOR. THE LICENSOR MAKES NO
    REPRESENTATIONS OR WARRANTIES OF ANY KIND CONCERNING THE WORK, EXPRESS, IMPLIED, STATUTORY OR
    OTHERWISE, INCLUDING, WITHOUT LIMITATION, WARRANTIES OF TITLE, MARKETABILITY, MERCHANTIBILITY,
    FITNESS FOR A PARTICULAR PURPOSE, NONINFRINGEMENT, OR THE ABSENCE OF LATENT OR OTHER DEFECTS, ACCURACY,
    OR THE PRESENCE OF ABSENCE OF ERRORS, WHETHER OR NOT DISCOVERABLE. SOME JURISDICTIONS DO NOT ALLOW THE
    EXCLUSION OF IMPLIED WARRANTIES, SO SUCH EXCLUSION MAY NOT APPLY TO YOU.
*/

AddCSLuaFile                ( 'cl_init.lua' )
AddCSLuaFile                ( 'shared.lua' )
include                     ( 'shared.lua' )

/*
    gamemode
*/

GM.Version                  = '2.0.0'
GM.Name                     = 'Basewars 2'
GM.Author                   = 'Richard'

DeriveGamemode              ( 'sandbox' )
DEFINE_BASECLASS            ( 'gamemode_sandbox' )
GM.Sandbox                  = BaseClass

GM.Config                   = GM.Config or { }
GM.NoLicense                = GM.NoLicense or { }

/*
    hook > loader
*/

rhook.run.gmod              ( 'bw2_loader_pre' )


/*
AddCSLuaFile('libraries/sh_cami.lua')
AddCSLuaFile('libraries/simplerr.lua')
AddCSLuaFile('libraries/interfaceloader.lua')
AddCSLuaFile('libraries/modificationloader.lua')
AddCSLuaFile('libraries/disjointset.lua')
AddCSLuaFile('libraries/fn.lua')
AddCSLuaFile('libraries/tablecheck.lua')

AddCSLuaFile('config/config.lua')
AddCSLuaFile('config/addentities.lua')
AddCSLuaFile('config/jobrelated.lua')
AddCSLuaFile('config/ammotypes.lua')

AddCSLuaFile('cl_init.lua')

GM.Config = GM.Config or {}
GM.NoLicense = GM.NoLicense or {}

include('libraries/interfaceloader.lua')

include('config/_MySQL.lua')
include('config/config.lua')
include('config/licenseweapons.lua')

include('libraries/fn.lua')
include('libraries/tablecheck.lua')
include('libraries/sh_cami.lua')
include('libraries/simplerr.lua')
include('libraries/modificationloader.lua')
include('libraries/mysqlite/mysqlite.lua')
include('libraries/disjointset.lua')


hook.Call('DarkRPPreLoadModules', GM)
*/

--[[---------------------------------------------------------------------------
Loading modules
---------------------------------------------------------------------------]]
/*
local fol = GM.FolderName .. '/gamemode/modules/'
local files, folders = file.Find(fol .. '*', 'LUA')

for k, v in pairs(files) do
    if DarkRP.disabledDefaults['modules'][v:Left(-5)] then continue end
    if string.GetExtensionFromFilename(v) ~= 'lua' then continue end
    include(fol .. v)
end

for _, folder in SortedPairs(folders, true) do
    if folder == '.' or folder == '..' or DarkRP.disabledDefaults['modules'][folder] then continue end

    for _, File in SortedPairs(file.Find(fol .. folder .. '/sh_*.lua', 'LUA'), true) do
        AddCSLuaFile(fol .. folder .. '/' .. File)
        if File == 'sh_interface.lua' then continue end
        include(fol .. folder .. '/' .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. '/sv_*.lua', 'LUA'), true) do
        if File == 'sv_interface.lua' then continue end
        include(fol .. folder .. '/' .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. '/cl_*.lua', 'LUA'), true) do
        if File == 'cl_interface.lua' then continue end
        AddCSLuaFile(fol .. folder .. '/' .. File)
    end
end
*/

/*
DarkRP.DARKRP_LOADING = true
include('config/jobrelated.lua')
include('config/addentities.lua')
include('config/ammotypes.lua')
DarkRP.DARKRP_LOADING = nil

DarkRP.finish()

rhook.run.gmod              ( 'bw2_loader_finish' )

hook.Call('DarkRPFinishedLoading', GM)
MySQLite.initialize()
*/