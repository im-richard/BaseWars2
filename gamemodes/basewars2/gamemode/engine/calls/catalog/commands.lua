/*
    @library        : rlib
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
local cfg                   = base.settings
local mf                    = base.manifest

/*
    command prefix
*/

local sf                    = string.format
local _p                    = sf( '%s_', mf.basecmd )
local _c                    = sf( '%s.', mf.basecmd )
local _n                    = sf( '%s', mf.basecmd )

/*
    associated commands

    :   parameters

        enabled     :   determines if the command be useable or not
        bInternal   :   for internal cmds like rlib_rnet_reload; otherwise function will be overwritten
        is_base     :   will be considered the base command of the lib.
        is_hidden   :   determines if the command should be shown or not in the main list
                    :   do not make more than one command the base or you may have issues.
        id          :   command that must be typed in console to access
        clr         :   color to display command in when searched / seen in console list
        pubc        :   public command to execute command
        desc        :   description of command
        args        :   additional args that command supports
        scope       :   what scope the command can be accessed from ( 1 = sv, 2 = sh, 3 = cl )
        showsetup   :   displays the command in the help info after the server owner has been recognized using ?setup
        official    :   official rlib command; displayed within console when 'rlib' command input
        ex          :   examples of how the command can be utilized; used as visual help for user
        flags       :   command arg flags that can be used to access different sub-features
        notes       :   important notes to display when user searches help for a command
        warn        :   displays a warning to the user about using this command and non-liability
        no_console  :   cannot be executed by server-console. must have a valid player running command
*/

base.c.commands =
{
    [ _n ] =
    {
        enabled             = true,
        is_base             = true,
        id                  = _n,
        name                = 'Base command',
        desc                = 'base command, displays top-level help',
        args                = '[ <command> ], [ <-flag> <search_keyword> ]',
        scope               = 2,
        showsetup           = true,
        official            = true,
        ex =
        {
            _n,
            _n .. ' ' .. _c .. 'version',
            _n .. ' -a',
            _n .. ' -f ' .. _c .. 'version',
            _n .. ' -h ' .. _c .. 'version'
        },
        flags =
        {
            [ 'all' ]       = { flag = '-a',        desc = 'displays all cmds in console regardless of scope' },
            [ 'simple' ]    = { flag = '-s',        desc = 'get a more simplified command list' },
            [ 'filter' ]    = { flag = '-f',        desc = 'filter search results' },
            [ 'help' ]      = { flag = '-h',        desc = 'view help on specific command' },
            [ 'break' ]     = { flag = '-b',        desc = 'add breaks after each command' },
            [ 'modules' ]   = { flag = '-m',        desc = 'displays module commands only' },
        },
        notes =
        {
            'This command is the base command to all sub-levels'
        },
    },
    [ _p .. 'access' ] =
    {
        enabled             = true,
        id                  = _c .. 'access',
        name                = 'Access',
        desc                = 'users access to lib',
        pubc                = '!access',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'admins' ] =
    {
        enabled             = true,
        id                  = _c .. 'admins',
        name                = 'Admins',
        desc                = 'list of steamids with access to lib',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'asay' ] =
    {
        enabled             = true,
        warn                = true,
        no_console          = false,
        id                  = _c .. 'asay',
        name                = 'Tools » ASay',
        desc                = 'Send msgs using asay',
        args                = '[ <msg> ]',
        scope               = 1,
        showsetup           = true,
        official            = true,
        ex =
        {
            _c .. 'asay hello',
        },
    },
    [ _p .. 'calls' ] =
    {
        enabled             = true,
        id                  = _c .. 'calls',
        name                = 'Calls',
        desc                = 'list of registered calls',
        args                = '[ <-flag> <search_keyword> ]',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'calls',
            _c .. 'calls -r',
            _c .. 'calls -s rlib',
        },
        flags =
        {
            [ 'search' ]    = { flag = '-s', desc = 'search results' },
            [ 'raw' ]       = { flag = '-r', desc = 'raw simple output' },
        },
    },
    [ _p .. 'changelog' ] =
    {
        enabled             = true,
        id                  = _c .. 'changelog',
        name                = 'Changelog',
        desc                = 'displays the lib changelog',
        scope               = 2,
        official            = true,
        flags =
        {
            [ 'search' ]    = { flag = '-s', desc = 'search results' },
        },
    },
    [ _p .. 'cs_new' ] =
    {
        enabled             = true,
        id                  = _c .. 'cs.new',
        name                = 'Checksum » New',
        desc                = 'write checksums and deploy lib',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'cs.new',
        },
        flags =
        {
            [ 'algorithm' ] = { flag = '-a', desc = 'algorithm to use (default: sha256)' },
        },
    },
    [ _p .. 'cs_verify' ] =
    {
        enabled             = true,
        id                  = _c .. 'cs.verify',
        name                = 'Checksum » Verify',
        desc                = 'checks the integrity of lib files',
        args                = '[ <command> ], [ <-flag> <search_keyword> ]',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'cs.verify',
            _c .. 'cs.verify -f rlib_core_sv',
        },
        flags =
        {
            [ 'all' ]       = { flag = '-a', desc = 'displays all results' },
            [ 'filter' ]    = { flag = '-f', desc = 'filter search results' },
        },
    },
    [ _p .. 'cs_now' ] =
    {
        enabled             = true,
        id                  = _c .. 'cs.now',
        name                = 'Checksum » Now',
        desc                = 'shows current checksums',
        args                = '[ <command> ], [ <-flag> <search_keyword> ]',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'cs.now',
        },
    },
    [ _p .. 'cs_obf' ] =
    {
        enabled             = true,
        id                  = _c .. 'cs.obf',
        name                = 'Checksum » Obf',
        desc                = 'Internal release prepwork',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'cs.obf',
        },
    },
    [ _p .. 'sap_encode' ] =
    {
        enabled             = true,
        id                  = _c .. 'sap.encode',
        name                = 'SAP » Encode',
        desc                = 'Encode SAP string',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'sap.encode',
        },
    },
    [ _p .. 'clear' ] =
    {
        enabled             = true,
        id                  = _c .. 'clear',
        alias               = 'clr',
        name                = 'Clear console',
        desc                = 'clears the console so you can start fresh',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'connections' ] =
    {
        enabled             = true,
        id                  = _c .. 'connections',
        name                = 'Connections',
        desc                = 'total connections since last restart',
        pubc                = '!connections',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'debug' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug',
        name                = 'Debug',
        desc                = 'toggles debug mode on and off',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'debug_status' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug.status',
        name                = 'Debug » Status',
        desc                = 'status of debug mode',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'debug_clean' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug.clean',
        name                = 'Debug » Clean',
        desc                = 'erases all debug logs from server',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'debug.clean',
            _c .. 'debug.clean -c',
        },
        flags =
        {
            [ 'cancel' ]    = { flag = '-c', desc = 'cancel cleaning action' },
        },
    },
    [ _p .. 'debug_diag' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug.diag',
        name                = 'Debug » Diagnostic',
        desc                = 'dev => production preparation',
        scope               = 1,
        showsetup           = true,
        official            = true,
        ex =
        {
            _c .. 'debug.diag',
        },
    },
    [ _p .. 'debug_devop' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug.devop',
        name                = 'Debug » DevOP',
        desc                = 'devop hook (dev only)',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'help' ] =
    {
        enabled             = true,
        id                  = _c .. 'help',
        name                = 'Help',
        desc                = 'help info for lib',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'languages' ] =
    {
        enabled             = true,
        id                  = _c .. 'languages',
        name                = 'Languages',
        desc                = 'language info',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'license' ] =
    {
        enabled             = true,
        id                  = _c .. 'license',
        name                = 'License',
        desc                = 'license for lib',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'manifest' ] =
    {
        enabled             = true,
        id                  = _c .. 'manifest',
        name                = 'Manifest',
        desc                = 'lib manifest',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'map_ents' ] =
    {
        enabled             = true,
        id                  = _c .. 'map.ents',
        name                = 'Map ents',
        desc                = 'returns list of map ents',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'mats' ] =
    {
        enabled             = true,
        id                  = _c .. 'mats',
        name                = 'Material List',
        desc                = 'registered mats',
        scope               = 3,
        official            = true,
    },
    [ _p .. 'modules' ] =
    {
        enabled             = true,
        id                  = _c .. 'modules',
        name                = 'rcore modules',
        desc                = 'all rcore modules',
        scope               = 1,
        showsetup           = true,
        official            = true,
        ex =
        {
            _c .. 'modules',
            _c .. 'modules -p',
        },
        flags =
        {
            [ 'paths' ]     = { flag = '-p', desc = 'display module install paths' },
        },
    },
    [ _p .. 'modules_reload' ] =
    {
        enabled             = true,
        id                  = _c .. 'modules.reload',
        name                = 'reload rcore modules',
        desc                = 'reload all rcore modules',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'modules.reload',
        },
    },
    [ _p .. 'modules_errlog' ] =
    {
        enabled             = true,
        id                  = _c .. 'modules.errlog',
        name                = 'errlogs',
        desc                = 'displays errlog for modules',
        scope               = 1,
        showsetup           = true,
        official            = true,
        ex =
        {
            _c .. 'modules.errlog',
        },
    },
    [ _p .. 'oort' ] =
    {
        enabled             = true,
        id                  = _c .. 'oort',
        name                = 'Oort Engine',
        desc                = 'manage rlib oort services',
        scope               = 1,
        showsetup           = false,
        official            = true,
        ex =
        {
            _c .. 'oort',
            _c .. 'oort -s debug 1',
            _c .. 'oort -s debug off',
        },
        flags =
        {
            [ 'set' ]     = { flag = '-s', desc = 'sets the status of oort debugging' },
        },
    },
    [ _p .. 'oort_update' ] =
    {
        enabled             = true,
        id                  = _c .. 'oort.update',
        name                = 'Oort » Update',
        desc                = 'updates oort engine',
        scope               = 1,
        showsetup           = false,
        official            = true,
    },
    [ _p .. 'oort_sendlog' ] =
    {
        enabled             = true,
        id                  = _c .. 'oort.sendlog',
        name                = 'Oort » Send Log',
        desc                = 'Sends log to developer',
        scope               = 1,
        showsetup           = false,
        official            = true,
    },
    [ _p .. 'packages' ] =
    {
        enabled             = true,
        id                  = _c .. 'packages',
        name                = 'Packages',
        desc                = 'list of running packages',
        scope               = 1,
        official            = true,
    },
    [ _p .. 'panels' ] =
    {
        enabled             = true,
        id                  = _c .. 'panels',
        name                = 'Panels » Registered',
        desc                = 'list of registered panels',
        args                = '[ <-flag> <search_keyword> ]',
        scope               = 3,
        official            = true,
        ex =
        {
            _c .. 'panels',
            _c .. 'panels -s rlib',
        },
        flags =
        {
            [ 'search' ]    = { flag = '-s', desc = 'search results' },
        },
    },
    [ _p .. 'terms' ] =
    {
        enabled             = true,
        id                  = _c .. 'terms',
        name                = 'Terms',
        desc                = 'displays terms / intro panel',
        scope               = 3,
        official            = true,
        ex =
        {
            _c .. 'terms',
        },
    },
    [ _p .. 'rcc_rehash' ] =
    {
        enabled             = true,
        id                  = _c .. 'rcc.rehash',
        name                = 'Rehash RCC',
        desc                = 'refreshes registered command calls',
        scope               = 2,
        official            = true,
        ex =
        {
            _c .. 'rcc.rehash',
        },
    },
    [ _p .. 'reload' ] =
    {
        enabled             = true,
        warn                = true,
        id                  = _c .. 'reload',
        name                = 'Reload',
        desc                = 'reloads lib on server',
        scope               = 1,
        official            = true,
    },
    [ _p .. 'restart' ] =
    {
        enabled             = true,
        id                  = _c .. 'restart',
        name                = 'Restart',
        desc                = 'server restart | Def: 30s',
        args                = '[ <seconds> ]',
        scope               = 1,
        official            = true,
        flags =
        {
            [ 'cancel' ]    = { flag = { '-c', 'cancel', '-cancel' }, desc = 'cancel restart' },
            [ 'instant' ]   = { flag = { '-i', 'instant', '-instant' }, desc = 'instant restart' },
        },
        ex =
        {
            _c .. 'restart',
            _c .. 'restart -c',
            _c .. 'restart -i',
        },
        notes =
        {
            'Can be cancelled with the command [ rlib.restart -c ]',
            'Default: 30 seconds',
            'Use rlib.restart -i for instant restart'
        },
    },
    [ _p .. 'rpm' ] =
    {
        enabled             = true,
        id                  = _c .. 'rpm',
        name                = 'Rlib Package Manager',
        desc                = 'loads an external package from rpm server',
        args                = '[ <-flag> <package]> ]',
        scope               = 1,
        official            = true,
        flags =
        {
            [ 'install' ]   = { flag = '-i' },
            [ 'list' ]      = { flag = '-l' },
        },
        ex =
        {
            _c .. 'rpm',
            _c .. 'rpm -l',
            _c .. 'rpm -i package',
        },
    },
    [ _p .. 'running' ] =
    {
        enabled             = true,
        id                  = _c .. 'running',
        name                = 'Running',
        desc                = 'current modules installed on server',
        pubc                = '!running',
        scope               = 2,
        showsetup           = false,
        official            = true,
    },
    [ _p .. 'services' ] =
    {
        enabled             = true,
        id                  = _c .. 'services',
        name                = 'Services » Status',
        desc                = 'list of services and status',
        args                = '[ <-flag> <search_keyword> ]',
        scope               = 2,
        official            = true,
        ex =
        {
            _c .. 'services',
            _c .. 'services -s pco',
        },
        flags =
        {
            [ 'search' ]    = { flag = '-s', desc = 'search results' },
        },
    },
    [ _p .. 'tools_pco' ] =
    {
        enabled             = true,
        warn                = true,
        no_console          = true,
        id                  = _c .. 'tools.pco',
        name                = 'Tools » PCO',
        desc                = '(player client optimization), return / set status of pco',
        args                = '[ <state> ]',
        scope               = 1,
        showsetup           = true,
        official            = true,
        ex =
        {
            _c .. 'tools.pco',
            _c .. 'tools.pco enable',
            _c .. 'tools.pco disable',
        },
    },
    [ _p .. 'tools_rdo' ] =
    {
        enabled             = true,
        warn                = true,
        id                  = _c .. 'tools.rdo',
        name                = 'Tools » RDO',
        desc                = '(render distance optimization), return / set status of rdo',
        args                = '[ <state> ]',
        scope               = 1,
        showsetup           = true,
        official            = true,
        ex =
        {
            _c .. 'tools.rdo',
            _c .. 'tools.rdo enable',
            _c .. 'tools.rdo disable',
        },
    },
    [ _p .. 'session' ] =
    {
        enabled             = true,
        warn                = true,
        id                  = _c .. 'session',
        name                = 'Session',
        desc                = 'your current sess id',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'setup' ] =
    {
        enabled             = true,
        id                  = _c .. 'setup',
        name                = 'Setup library',
        desc                = 'setup lib | should be ran at first install',
        pubc                = '!setup',
        scope               = 1,
        official            = true,
    },
    [ _p .. 'status' ] =
    {
        enabled             = true,
        id                  = _c .. 'status',
        name                = 'Status',
        desc                = 'stats and data for the lib',
        scope               = 1,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'udm' ] =
    {
        enabled             = true,
        id                  = _c .. 'udm',
        name                = 'Update Manager',
        desc                = 'Check for updates',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'uptime' ] =
    {
        enabled             = true,
        id                  = _c .. 'uptime',
        name                = 'Uptime',
        desc                = 'uptime of the server',
        pubc                = '!uptime',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'user' ] =
    {
        enabled             = true,
        id                  = _c .. 'user',
        name                = 'Manage User',
        desc                = 'manages player perms for lib',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'user add player',
            _c .. 'user remove player',
            _c .. 'user status player',
            _c .. 'user -a player',
            _c .. 'user -r player',
            _c .. 'user -s player',
        },
        flags =
        {
            [ 'add' ]       = { flag = '-a', desc = 'adds a player to rlib access' },
            [ 'remove' ]    = { flag = '-r', desc = 'removes a player from rlib access' },
            [ 'status' ]    = { flag = '-s', desc = 'checks a players access to rlib' },
        },
    },
    [ _p .. 'version' ] =
    {
        enabled             = true,
        id                  = _c .. 'version',
        name                = 'Version',
        desc                = 'current running ver of lib',
        pubc                = '!version',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'workshops' ] =
    {
        enabled             = true,
        id                  = _c .. 'workshops',
        name                = 'Workshops',
        desc                = 'workshop ids loaded between modules / lib',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'rnet_reload' ] =
    {
        bInternal           = true,
        enabled             = true,
        id                  = _c .. 'rnet.reload',
        name                = 'Reload RNet',
        desc                = 'reload all registered rnet entries',
        scope               = 1,
        showsetup           = false,
        official            = true,
    },
}