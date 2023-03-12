/*
    @library        : rlib
    @package        : rcc
    @docs           : https://docs.rlib.io

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

/*
    library
*/

local base                  = rlib
local access                = base.a
local helper                = base.h
/*
    library > localize
*/

local mf                    = base.manifest

/*
    lua > localize
*/

local dcat                  = 9
local sf                    = string.format

/*
    localize clrs
*/

local clr_r                 = Color( 255, 0, 0 )
local clr_y                 = Color( 255, 255, 0 )
local clr_g                 = Color( 0, 255, 0 )
local clr_w                 = Color( 255, 255, 255 )
local clr_p                 = Color( 255, 0, 255 )

/*
    localize output functions
*/

local function con      ( ... ) base:console( ... ) end
local function log      ( ... ) base:log( ... ) end
local function route    ( ... ) base.msg:route( ... ) end
local function target   ( ... ) base.msg:target( ... ) end

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    call id > get

    @source : lua\autorun\libs\_calls
    @param  : str id
*/

local function g_CallID( id )
    return base:call( 'commands', id )
end

/*
    prefix > create id
*/

local function cid( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or mf.prefix
    affix           = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%p%c%s]', '.' )

    return string.format( '%s%s', affix, id )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and mf.prefix ) or false
    return cid( str, state )
end

/*
    define module
*/

module( 'rcc', package.seeall )

/*
    local declarations
*/

local pkg           = rcc
local pkg_name      = _NAME or 'rcc'

/*
    pkg declarations
*/

local manifest =
{
    author          = 'richard',
    desc            = 'console commands',
    build           = 032620,
    version         = { 2, 0, 0 },
    debug_id        = 'rcc.debug.delay',
}

/*
    required tables
*/

cfg                 = cfg or { }
sys                 = sys or { }
new                 = new or { }
run                 = run or { }
drop                = drop or { }
call                = call or { }
storage             = storage or { }

/*
    net > debugging

    determines if debugging mode is enabled
*/

cfg.debug           = cfg.debug or false

/*
 	prefix > getid
*/

local function gid( id )
    id = isstring( id ) and id or nil
    if not isstring( id ) then
        local trcback = debug.traceback( )
        base:log( dcat, '[ %s ] :: invalid id\n%s', pkg_name, tostring( trcback ) )
        return
    end

    id = g_CallID( id )

    return id
end

/*
    rcc id

    creates rcc command with package name appended to the front
    of the string.

    @param  : str str
*/

function g_PackageId( str )
    str         = isstring( str ) and str ~= '' and str or false
                if not str then return pkg_name end

    return pid( str, pkg_name )
end

/*
    new > rlib

    @ex     : rcc.new.rlib( 'module_concommand_name', module_fn_name )

    @param  : str name
    @param  : varg ( ... )
*/

function new.rlib( name, ... )
    name = gid( name )
    concommand.Add( name, ... )
end

/*
    new > gmod

    @param  : varg ( ... )
*/

function new.gmod( ... )
    concommand.Add( ... )
end

/*
    drop > rlib

    @param  : str name
*/

function drop.rlib( name )
    name = gid( name )
    concommand.Remove( name )
end

/*
    drop > gmod

    @param  : str name
*/

function drop.gmod( name )
    concommand.Remove( name )
end

/*
    run > rlib

    @param  : str cmd
    @param  : varg ( ... )
*/

function run.rlib( cmd, ... )
    cmd = gid( cmd )
    RunConsoleCommand( cmd, ... )
end

/*
    run > gmod

    @param  : varg ( ... )
*/

function run.gmod( ... )
    RunConsoleCommand( ... )
end

/*
    register

    @param  : str cmd
    @param  : func fn
*/

function register( cmd, fn )
    if not isstring( cmd ) then return end
    storage[ cmd ] = fn
end

/*
    get

    @param  : str cmd
    @return : func
*/

function get( cmd )
    if not isstring( cmd ) then return end
    return storage[ cmd ] or nil
end

/*
    rcc > prepare

    takes all of the registered commands through rlib and turns them into
    a command usable with rcc

    accepts an alternative source table but struct must be the same as the
    original.

    @call   : rcc.prepare( )

    @param  : tbl source
    @return : void
*/

function prepare( source )

    source = istable( source ) and source or base._rcalls.commands

    for k, v in pairs( source ) do
        if not v.enabled then continue end
        if v.bInternal then continue end -- for commands like rlib_rnet_reload; otherwise function will be overwritten

        if SERVER and ( v.scope == 1 or v.scope == 2 ) then
            local fn                = rcc.get( k )
                                    if not fn then fn = v.assoc end
            rcc.new.gmod( v.id, fn )

            if v.alias then
                rcc.new.gmod( v.alias, fn )
            end
        elseif CLIENT and ( v.scope == 2 or v.scope == 3 ) then
            local fn                = rcc.get( k )
                                    if not fn then fn = v.assoc end

            rcc.new.gmod( v.id, fn )
            if v.alias then
                rcc.new.gmod( v.alias, fn )
            end
        else
            continue
        end

        if SERVER and v.pubc then
            -- register commands with public triggers
            local id                    = isstring( v.pubc ) and v.pubc
            base._rcalls.pubc           = base._rcalls.pubc or { }
            base._rcalls.pubc[ id ]     = { cmd = id, func = rcc.get( k ) }

            sys.calls                   = ( sys.calls or 0 ) + 1
        end
    end

end

/*
    rcc > source

    returns source tbl for commands

    @return : tbl
*/

function source( )
    return base.calls:get( 'commands' ) or { }
end

/*
    rcc > base

    base package command
*/

local function rcc_base( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rcc' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, mf.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, mf.name, ccmd.id )
        return
    end

    /*
        output
    */

    base.msg:route( pl, false, pkg_name, mf.name .. ' package' )
    base.msg:route( pl, false, pkg_name, 'v' .. rlib.get:ver2str( manifest.version ) .. ' build-' .. manifest.build )
    base.msg:route( pl, false, pkg_name, 'developed by ' .. manifest.author )
    base.msg:route( pl, false, pkg_name, manifest.desc .. '\n' )

end

/*
    rcc > rehash

    refreshes all console commands
*/

local function rcc_rehash( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rcc_rehash' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, mf.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, mf.name, ccmd.id )
        return
    end

    /*
        execute
    */

    RegisterRCC( true )

end

/*
    rcc > check

    returns if a command has a valid registered function
*/

local function rcc_check( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rcc_check' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, mf.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, mf.name, ccmd.id )
        return
    end

    /*
        args
    */

    local arg_cmd               = __GetArg( args, 1 )

    /*
        no arg
    */

    if not arg_cmd then
        base.con:S          (  )
        con( 'c',           clr_w, ' Command not provided' )
        base.con:E          (  )
        return
    end

    /*
        command not found
    */

    local cmdExists = get( arg_cmd )
    if not cmdExists then
        base.con:S          (  )
        con( 'c',           clr_w, ' Command ', clr_r, arg_cmd, clr_w, ' not registered' )
        base.con:E          (  )
        return
    end

    /*
        command registered
    */

    base.con:S          (  )
    con( 'c',           clr_w, ' Command ', clr_p, arg_cmd, clr_w, ' is registered' )
    base.con:E          (  )

end

/*
    rcc > storage
*/

local function rcc_storage( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rcc_storage' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, mf.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, mf.name, ccmd.id )
        return
    end

    /*
        execute
    */

    local tblStorage        = storage or { }
    local rCalls            = base._rcalls.commands or { }

    base.con:S              (  )

    local a1_l              = sf( '%-30s',  'Command'       )
    local a2_l              = sf( '%-30s',  'Name'          )
    local a3_l              = sf( '%-5s',   '»'             )
    local a4_l              = sf( '%-35s',  'Function'      )

    con( 'c',               Color( 255, 255, 0 ), a1_l, Color( 255, 255, 0 ),  a2_l, Color( 255, 255, 255 ), a3_l, a4_l )
    con( 'c', 0 )
    con( 'c', 1 )

    for k, v in SortedPairs( tblStorage ) do

        local cmd_id        = k
        local name          = 'Unknown'
        if rCalls[ k ] then
            cmd_id          = ( rCalls[ k ] and rCalls[ k ].id ) or k
            name            = ( rCalls[ k ] and rCalls[ k ].name ) or cmd_id
        end

        local bHasFunc      = isfunction( v ) and true or false
        bHasFunc            = helper.util:humanbool( bHasFunc, true )

        local a1_2          = sf( '%-30s',  cmd_id          )
        local a2_2          = sf( '%-30s',  name            )
        local a3_2          = sf( '%-5s',  '»'              )
        local a4_2          = sf( '%-35s',  bHasFunc        )

        con( 'c',           Color( 255, 255, 0 ), a1_2, Color( 255, 255, 0 ), a2_2, Color( 255, 255, 255 ), a3_2, a4_2 )
    end

    base.con:E              (  )

end

/*
    rcc > register
*/

function RegisterRCC( bOutput )

    local pkg_commands =
    {
        [ pkg_name ] =
        {
            enabled         = true,
            warn            = true,
            id              = g_PackageId( ),
            name            = pkg_name,
            desc            = 'returns package information',
            scope           = 2,
            clr             = Color( 255, 255, 0 ),
            assoc           = function( ... )
                                rcc_base( ... )
                            end,
        },
        [ pkg_name .. '_rehash' ] =
        {
            enabled         = true,
            warn            = true,
            id              = g_PackageId( 'rehash' ),
            name            = 'Rehash commands',
            desc            = 'reload all module rcc commands',
            scope           = 1,
            clr             = Color( 255, 255, 0 ),
            assoc           = function( ... )
                                rcc_rehash( ... )
                            end,
        },
        [ pkg_name .. '_check' ] =
        {
            enabled         = true,
            warn            = true,
            id              = g_PackageId( 'check' ),
            name            = 'Check Commands',
            desc            = 'checks if command is registered with a function',
            scope           = 1,
            clr             = Color( 255, 255, 0 ),
            assoc           = function( ... )
                                rcc_check( ... )
                            end,
        },
        [ pkg_name .. '_storage' ] =
        {
            enabled         = true,
            warn            = true,
            id              = g_PackageId( 'storage' ),
            name            = 'Storage',
            desc            = 'return storage information on rcc commands',
            scope           = 1,
            clr             = Color( 255, 255, 0 ),
            assoc           = function( ... )
                                rcc_storage( ... )
                            end,
        },
    }

    /*
        rcc > register
    */

    base.calls.commands:Register( pkg_commands )

    /*
        save output
    */

    if not bOutput then return end

    local i = table.Count( pkg_commands )
    base:log( RLIB_LOG_OK, ln( 'rcc_rehash_i', i, pkg_name ) )
end
hook.Add( pid( 'cmd.register' ), pid( '__rcc.cmd.register' ), RegisterRCC )

/*
    register packages
*/

function Packages( )
    if not istable( _M ) then return end
    base.package:Register( _M )
end
hook.Add( pid( 'pkg.register' ), pid( '__rcc.pkg.register' ), Packages )

/*
    module info > manifest
*/

function pkg:manifest( )
    return self.__manifest
end

/*
    __tostring
*/

function pkg:__tostring( )
    return self:_NAME( )
end

/*
    create new class
*/

function pkg:loader( class )
    class = class or { }
    self.__index = self
    return setmetatable( class, self )
end

/*
    __index / manifest declarations
*/

pkg.__manifest =
{
    __index     = _M,
    name        = _NAME,
    build       = manifest.build,
    version     = manifest.version,
    author      = manifest.author,
    desc        = manifest.desc
}

pkg.__index     = pkg