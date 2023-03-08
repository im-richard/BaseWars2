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
local access                = base.a
local helper                = base.h
local font                  = base.f

/*
    library > localize
*/

local _f                    = surface.CreateFont

/*
    prefix ids
*/

local function pref( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and base.manifest.prefix ) or false
    return base.get:pref( str, state )
end

/*
 	font > reg

    registers new font with no prefix at the beginning. whatever id is
    provided is what will be used.

    @param  : str id
    @param  : str name
    @param  : int sz
    @param  : int weight
    @param  : bool bShadow
    @param  : bool bExt
*/

function font.reg( id, name, sz, wt, bShadow, bExt, bSym )
    _f( id, { font = name, size = sz, weight = wt, bShadow or false, antialias = true, extended = bExt or false, symbol = bSyn or false } )
end

/*
 	fonts > new

    registers new font with prefix attahed to beginning of font id string

    @param  : str, tbl mod
    @param  : str id
    @param  : str name
    @param  : int sz
    @param  : int weight
    @param  : bool bShadow
    @param  : bool bExt
    @param  : bool bSym
*/

function font.new( mod, id, name, sz, wt, bShadow, bExt, bSym )
    local pf    = istable( mod ) and mod.id or isstring( mod ) and mod or false
    id          = pref( id, pf )

    _f( id, { font = name, size = sz, weight = wt, bShadow or false, antialias = true, extended = bExt or false, symbol = bSyn or false } )

    base:log( RLIB_LOG_FONT, '+ font » %s', id )
end

/*
 	fonts > get

    returns font id
    all ids have rlib_suffix appended to the front

    @example:   general_name
                rlib.general.name

    @param  : str, tbl mod
    @param  : str id
    @return : str
*/

function font.get( mod, id )
    local pf    = istable( mod ) and mod.id or isstring( mod ) and mod or false
    id          = pref( id, pf )

    return id
end

/*
    new lib font
*/

local _new                  = font.new

/*
    fonts > register
*/

local function fonts_register( pl )

    /*
        perm > reload
    */

        if ( ( helper.ok.ply( pl ) or access:bIsConsole( pl ) ) and not access:allow_throwExcept( pl, 'rlib_root' ) ) then return end

    /*
        fonts > scale
    */

        local fs            = RScale( 0.4 )

    /*
        fonts > uclass
    */

        _new( false, 'ucl_font_def',                    'Roboto Light',         16 * fs, 400, false )
        _new( false, 'ucl_tippy',                       'Roboto Light',         19 * fs, 200, false )

    /*
        fonts > design
    */

        _new( false, 'design_dialog_sli_title',         'Roboto Light',         23, 100, true )
        _new( false, 'design_dialog_sli_msg',           'Roboto',               17, 300, true )
        _new( false, 'design_dialog_sli_x',             'Segoe UI Light',       42, 800, false )
        _new( false, 'design_text_default',             'Roboto Light',         16, 100, false )
        _new( false, 'design_rsay_text',                'Roboto Light',         30, 100, true )
        _new( false, 'design_rsay_text_sub',            'Roboto Light',         20, 100, true )
        _new( false, 'design_draw_textscroll',          'Roboto Light',         14, 100, true )
        _new( false, 'design_bubble_msg',               'Montserrat Medium',    18, 200, true )
        _new( false, 'design_bubble_msg_2',             'Montserrat Medium',    18, 200, true )
        _new( false, 'design_bubble_ico',               'Roboto Condensed',     48, 400, true )

    /*
        fonts > notification > notify
    */

        _new( false, 'design_notify_msg',               'Roboto Light',         18, 400, false )

    /*
        fonts > notification > push
    */

        _new( false, 'design_push_name',                'Segoe UI Light',       20, 700, false )
        _new( false, 'design_push_msg',                 'Roboto Light',         18, 100, false )
        _new( false, 'design_push_ico',                 'GSym Solid',           40, 800, false, true )

    /*
        fonts > notification > sos
    */

        _new( false, 'design_sos_name',                 'Segoe UI Light',       24 * fs, 700, false, false )
        _new( false, 'design_sos_msg',                  'Segoe UI Light',       20 * fs, 100, false, false )
        _new( false, 'design_sos_ico',                  'GSym Solid',           50 * fs, 800, false, true )



    /*
        fonts > notification > nms
    */

        _new( false, 'design_nms_name',                 'Segoe UI Light',       46, 100, false, false )
        _new( false, 'design_nms_msg',                  'Segoe UI Light',       26, 100, false, false )
        _new( false, 'design_nms_qclose',               'Roboto Light',         20, 100, true, false )
        _new( false, 'design_nms_ico',                  'GSym Solid',           68, 800, false, true )

    /*
        fonts > notification > restart
    */

        _new( false, 'design_rs_title',                 'Segoe UI Light',       20 * fs, 400, false, false )
        _new( false, 'design_rs_cntdown',               'Segoe UI Light',       48 * fs, 200, false, false )
        _new( false, 'design_rs_status',                'Segoe UI Light',       30 * fs, 200, false, false )

    /*
        fonts > notification > debug
    */


        _new( false, 'design_debug_title',              'Segoe UI Light',       20 * fs, 400, false, false )
        _new( false, 'design_debug_cntdown',            'Segoe UI Light',       48 * fs, 200, false, false )
        _new( false, 'design_debug_status',             'Segoe UI Light',       30 * fs, 200, false, false )

    /*
        fonts > elements
    */

        _new( false, 'elm_tab_name',                    'Raleway Light',        15, 200, false, false )
        _new( false, 'elm_text',                        'Segoe UI Light',       17, 400, false, false )

    /*
        fonts > about
    */

        _new( false, 'about_exit',                      'Roboto', 24,           800, false, false )
        _new( false, 'about_resizer',                   'Roboto Light',         24, 100, false, false )
        _new( false, 'about_icon',                      'Roboto Light',         24, 100, false, false )
        _new( false, 'about_name',                      'Roboto Light',         44, 100, false, false )
        _new( false, 'about_title',                     'Roboto Light',         16, 600, false, false )
        _new( false, 'about_entry',                     'Roboto', 15,           300, false, false )
        _new( false, 'about_entry_label',               'Roboto', 17,           200, false, false )
        _new( false, 'about_entry_value',               'Roboto Light',         17, 200, false, false )
        _new( false, 'about_status',                    'Roboto', 14,           800, false, false )
        _new( false, 'about_status_conn',               'Roboto', 14,           400, false, false )

    /*
        fonts > rcfg
    */

        _new( false, 'rcfg_exit',                       'Roboto Light',         36, 800, false, false )
        _new( false, 'rcfg_refresh',                    'Roboto Light',         24, 800, false, false )
        _new( false, 'rcfg_resizer',                    'Roboto Light',         24, 100, false, false )
        _new( false, 'rcfg_icon',                       'Roboto Light',         24, 100, false, false )
        _new( false, 'rcfg_name',                       'Segoe UI Light',       40, 100, false, false )
        _new( false, 'rcfg_sub',                        'Roboto Light',         16, 100, false, false )
        _new( false, 'rcfg_title',                      'Roboto Light',         16, 600, false, false )
        _new( false, 'rcfg_entry',                      'Roboto',               15, 300, false, false )
        _new( false, 'rcfg_entry',                      'Roboto',               15, 300, false, false )
        _new( false, 'rcfg_entry',                      'Roboto',               14, 800, false, false )
        _new( false, 'rcfg_status_conn',                'Roboto',               14, 400, false, false )
        _new( false, 'rcfg_lst_name',                   'Roboto Lt',            18, 100, false, false )
        _new( false, 'rcfg_lst_ver',                    'Roboto Lt',            14, 500, false, false )
        _new( false, 'rcfg_lst_rel',                    'Segoe UI Light',       19, 100, false, false )
        _new( false, 'rcfg_lst_desc',                   'Roboto Lt',            13, 100, false, false )
        _new( false, 'rcfg_sel_name',                   'Roboto Lt',            32, 100, false, false )
        _new( false, 'rcfg_sel_ver',                    'Roboto Lt',            16, 600, false, false )
        _new( false, 'rcfg_sel_rel',                    'Segoe UI Light',       14, 100, false, false )
        _new( false, 'rcfg_sel_desc',                   'Roboto Lt',            17, 100, false, false )
        _new( false, 'rcfg_footer_i',                   'Roboto',               13, 400, false, false )
        _new( false, 'rcfg_symbol',                     'GSym Light',           48, 800, false, true )
        _new( false, 'rcfg_soon',                       'Segoe UI Light',       36, 100, false, false )
        _new( false, 'rcfg_ws',                         'Segoe UI Light',       20, 100, false, false )

    /*
        fonts > lang
    */

        _new( false, 'lang_close',                      'Roboto',               34 * fs, 800, false, false )
        _new( false, 'lang_icon',                       'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'lang_title',                      'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'lang_desc',                       'Roboto Light',         17 * fs, 400, false, false )
        _new( false, 'lang_item',                       'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'lang_cbo_sel',                    'Segoe UI Light',       20 * fs, 100, false, false )
        _new( false, 'lang_cbo_opt',                    'Segoe UI Light',       17 * fs, 100, false, false )

    /*
        fonts > reports
    */

        _new( false, 'report_exit',                     'Roboto',               24 * fs, 800, false, false )
        _new( false, 'report_resizer',                  'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'report_btn_clr',                  'Roboto',               15 * fs, 800, false, false )
        _new( false, 'report_btn_auth',                 'Roboto',               29 * fs, 800, false, false )
        _new( false, 'report_btn_send',                 'Roboto',               15 * fs, 800, false, false )
        _new( false, 'report_err',                      'Roboto',               14 * fs, 800, false, false )
        _new( false, 'report_icon',                     'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'report_title',                    'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'report_desc',                     'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'report_auth',                     'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'report_auth_icon',                'Roboto Light',         24 * fs, 100, false, false )

    /*
        fonts > mviewer
    */

        _new( false, 'mdlv_exit',                       'Roboto',               40 * fs, 800, false, false )
        _new( false, 'mdlv_resizer',                    'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'mdlv_icon',                       'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'mdlv_name',                       'Roboto Light',         44 * fs, 100, false, false )
        _new( false, 'mdlv_title',                      'Roboto Light',         16 * fs, 600, true, false )
        _new( false, 'mdlv_clear',                      'Roboto',               20 * fs, 800, false, false )
        _new( false, 'mdlv_enter',                      'Roboto',               20 * fs, 800, false, false )
        _new( false, 'mdlv_control',                    'Roboto Condensed',     16 * fs, 200, false, false )
        _new( false, 'mdlv_searchbox',                  'Roboto Light',         18 * fs, 100, false, false )
        _new( false, 'mdlv_minfo',                      'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'mdlv_copyclip',                   'Roboto Light',         14 * fs, 100, true, false )

    /*
        fonts > servinfo
    */

        _new( false, 'diag_icon',                       'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'diag_ctrl_exit',                  'Roboto',               40 * fs, 200, false, false )
        _new( false, 'diag_ctrl_min',                   'Roboto',               40 * fs, 200, false, false )
        _new( false, 'diag_title',                      'Segoe UI Light',       19 * fs, 200, false, false )
        _new( false, 'diag_value',                      'Segoe UI Light',       30 * fs, 600, false, false )
        _new( false, 'diag_hdr_value',                  'Segoe UI Light',       14 * fs, 400, false, false )
        _new( false, 'diag_chart_legend',               'Segoe UI Light',       14 * fs, 400, false, false )
        _new( false, 'diag_chart_value',                'Segoe UI Light',       23 * fs, 600, false, false )
        _new( false, 'diag_resizer',                    'Roboto Light',         24 * fs, 100, false, false )

    /*
        fonts > dc
    */

        _new( false, 'dc_exit',                         'Roboto',               24 * fs, 800, false, false )
        _new( false, 'dc_icon',                         'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'dc_name',                         'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'dc_title',                        'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'dc_msg',                          'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'dc_btn',                          'Roboto',               22 * fs, 200, false, false )

    /*
        fonts > welcome
    */

        _new( false, 'welcome_exit',                    'Roboto Light',         36 * fs, 800, false, false )
        _new( false, 'welcome_icon',                    'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'welcome_title',                   'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'welcome_name',                    'Segoe UI Light',       40 * fs, 100, false, false )
        _new( false, 'welcome_intro',                   'Open Sans Light',      20 * fs, 100, false, false )
        _new( false, 'welcome_ticker',                  'Open Sans',            14 * fs, 100, false, false )
        _new( false, 'welcome_btn',                     'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'welcome_data',                    'Roboto Light',         12 * fs, 200, false, false )
        _new( false, 'welcome_fx',                      'Roboto Light',         150 * fs, 100, false, false )

    /*
        concommand > reload
    */

        if helper.ok.ply( pl ) or access:bIsConsole( pl ) then
            base:log( 4, '[ %s ] reloaded fonts', base.manifest.name )
            if not access:bIsConsole( pl ) then
                base.msg:target( pl, base.manifest.name, 'reloaded fonts' )
            end
        end

end
hook.Add( 'rlib.fonts.register', '_lib_fonts_register', fonts_register )
concommand.Add( 'rlib.fonts.reload', fonts_register )