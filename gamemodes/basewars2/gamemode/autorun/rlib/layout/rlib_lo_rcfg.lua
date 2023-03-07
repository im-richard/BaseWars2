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
local design                = base.d
local ui                    = base.i
local tools                 = base.t
local cvar                  = base.v

/*
    localization > misc
*/

local cfg                   = base.settings
local mf                    = base.manifest

/*
    localization > glua
*/

local sf                    = string.format

/*
    Localized translation func
*/

local function lang( ... )
    return base:lang( ... )
end

/*
 	prefix ids
*/

local function pref( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and mf.prefix ) or false
    return base.get:pref( str, state )
end

/*
    panel
*/

local PANEL = { }

/*
    accessorfunc
*/

AccessorFunc( PANEL, 'm_bDraggable', 'Draggable', FORCE_BOOL )

/*
    initialize
*/

function PANEL:Init( )

    local s                         = self
    local abs                       = math.abs
    local clp                       = math.Clamp
    local sin                       = math.sin
    local cal                       = ColorAlpha

    /*
        sizing
    */

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :shadow                         ( true                                  )
    :size                           ( s._w, s._h                            )
    :minwide                        ( s._w                                  )
    :mintall                        ( s._h                                  )
    :popup                          (                                       )
    :notitle                        (                                       )
    :canresize                      ( false                                 )
    :noclose                        (                                       )
    :padding                        ( 0, 34, 0, 0 )
    :anim_fadein                    ( 0.2, 2                                )

    /*
        declarations > misc
    */

    self.hdr_title                  = 'rcfg'

    /*
        titlebar

        to overwrite existing properties from the skin; do not change this
        labels name to anything other than lblTitle otherwise it wont
        inherit position/size properties
    */

    self.lblTitle                   = ui.new( 'lbl', self                   )
    :notext                         (                                       )
    :font                           ( pref( 'rcfg_title' )                  )
    :clr                            ( Color( 255, 255, 255, 255 )           )

                                    :draw( function( s, w, h )
                                        if not self.title or self.title == '' then self.title = 'rcfg' end
                                        draw.SimpleText( utf8.char( 9930 ), pref( 'rcfg_icon' ), 0, 8, self.clr_hdr_ico, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( self.title, pref( 'rcfg_title' ), 25, h / 2, self.clr_hdr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        button > close

        to overwrite existing properties from the skin; do not change this
        buttons name to anything other than btnClose otherwise it wont
        inherit position/size properties
    */

    self.btnClose                   = ui.new( 'btn', self                   )
    :bsetup                         (                                       )
    :notext                         (                                       )
    :tooltip                        ( lang( 'tooltip_close' )               )

                                    :draw( function( s, w, h )
                                        local clr_txt = s.hover and self.clr_hdr_btn_h or self.clr_hdr_btn_n
                                        draw.SimpleText( helper.get:utf8( 'close' ), pref( 'rcfg_exit' ), w / 2 - 7, h / 2 + 4, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

                                    :oc( function( s )
                                        local parent = ui.get( self )
                                        :anim_fadeout( 0.2, 0, function( )
                                            ui:dispatch( self )
                                        end )
                                    end )

    /*
        button > maximize ( refresh )

        to overwrite existing properties from the skin; do not change this
        buttons name to anything other than btnClose otherwise it wont
        inherit position/size properties
    */

    self.btnMaxim                   = ui.new( 'btn', self                   )
    :bsetup                         (                                       )
    :notext                         (                                       )
    :tooltip                        ( lang( 'tooltip_act_refresh' )         )
    :ocr                            ( self                                  )

                                    :draw( function( s, w, h )
                                        local clr_txt = s.hover and self.clr_hdr_btn_h or self.clr_hdr_btn_n
                                        draw.SimpleText( helper.get:utf8( 'arrow_c' ), pref( 'rcfg_refresh' ), w / 2 - 7, h / 2 + 4, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

                                    :oc( function( s )
                                        ui:dispatch( self )
                                        timex.simple( 0.5, function( )
                                            tools.rcfg:Run( )
                                        end )
                                    end )

    /*
        header
    */

    self.p_hdr                      = ui.new( 'pnl', self                   )
    :top                            ( 'm', 0                                )
    :tall                           ( 80                                    )

                                    :draw( function( s, w, h )
                                        design.rbox( 0, 5, 0, w - 10, h, Color( 47, 47, 47, 255 ) )

                                        local pulse     = math.abs( math.sin( CurTime( ) * 1.2 ) * 255 )
                                        pulse           = math.Clamp( pulse, 125, 255 )

                                        draw.SimpleText( self.hdr_title:upper( ), pref( 'rcfg_name' ), 23, h / 2 - 8, Color( 200, 200, 200, pulse ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( 'MODULE MANAGEMENT', pref( 'rcfg_sub' ), 26, h / 2 + 14, Color( 200, 200, 200, pulse ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( '', pref( 'rcfg_symbol' ), w - 25, h / 2, Color( 255, 255, 255, 5 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        subparent pnl
    */

    self.ct_sub                     = ui.new( 'pnl', self                   )
    :fill                           ( 'm', 5, 0, 5, 0                       )
    :padding                        ( 0                                     )

                                    :draw( function( s, w, h )

                                    end )

    /*
        content pnl
    */

    self.ct_content                 = ui.new( 'pnl', self.ct_sub            )
    :fill                           ( 'm', 0                                )
    :padding                        ( 0                                     )

                                    :draw( function( s, w, h )

                                    end )

    /*
        item > right
    */

    self.ct_left                    = ui.new( 'pnl', self.ct_content        )
    :nodraw                         (                                       )
    :left                           ( 'p', 0, 0, 0, 0                       )
    :wide                           ( 320                                   )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, rclr.Hex( '252525' ) )
                                    end )

    /*
        sel > right
    */

    self.ct_right                   = ui.new( 'pnl', self.ct_content        )
    :nodraw                         (                                       )
    :fill                           ( 'p', 0, 0, 0, 0                       )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, rclr.Hex( '272727' ) )
                                    end )


    /*
        sel > right > content
    */

    self.ct_right_cont              = ui.new( 'pnl', self.ct_content        )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0, 0, 0, 0                       )

    /*
        scroll panel
    */

    self.dsp                        = ui.new( 'rlib.ui.scrollpanel', self.ct_left )
    :fill                           ( 'm', 0, 0, 0, 0                       )
    :var                            ( 'AlphaOR', true                       )
    :var                            ( 'SetKnobColor', 'a93838'              )

    /*
        declarations
    */

    local sz_item                   = 52
    local i_modules                 = table.Count( base.modules:list( ) )
    local str_modules               = sf( '%i modules installed', i_modules )
    local str_rlib_ver              = sf( 'rlib version: %s', base.get:ver2str_mf( ) )
    local item_sb_oset              = 15

    /*
        loop modules
    */

    local i = 0
    local selected = false
    for k, v in SortedPairs( base.modules:list( ) ) do

        local clr_box               = i % 2 == 0 and rclr.Hex( 'FFFFFF', 1 ) or rclr.Hex( 'FFFFFF', 3 )
        local clr_mat               = i % 2 == 0 and Color( 255, 255, 255, 0 ) or Color( 255, 255, 255, 3 )

        /*
            declare modules data
        */

        local m_name                = isstring( v.name ) and v.name or v.id
        local m_ver                 = sf( '%s', rlib.get:ver2str_mf( v ) )
        local m_rel                 = v.released and os.date( '%m.%d.%y', v.released )
        local m_def                 = 'http://cdn.rlib.io/gms/env.png'
        local m_img                 = ( isstring( v.icon ) and v.icon ~= '' and v.icon ) or m_def
        local m_url                 = ( isstring( v.url ) and v.url ) or mf.site
        local m_desc                = isstring( v.desc ) and v.desc or 'No description'
        m_desc                      = helper.str:truncate( m_desc, 60, '...' ) or lang( 'err' )
        m_desc                      = helper.str:ucfirst( m_desc )

        /*
            item > parent
        */

        local lst_i                 = ui.new( 'btn', self.dsp               )
        :top                        ( 'm', 0, 0, 0, 0                       )
        :padding( 0 )
        :bsetup                     (                                       )
        :notext                     (                                       )
        :tall                       ( sz_item - 5                          )

                                    :draw( function( s, w, h )
                                        design.rbox( 4, 0, 0, w, h, clr_box )

                                        if s.selected then
                                            local clr_a     = abs( sin( CurTime( ) * 4 ) * 255 )
                                            clr_a	        = clp( clr_a, 150, 255 )

                                            self.clr_box_s  = cal( rclr.Hex( '465897' ), clr_a )

                                            design.box( 0, 0, w, h, self.clr_box_s )
                                        end
                                    end )

                                    :logic_sl( 0.5, function( s )
                                        if not ui:ok( self.dsp ) then return end

                                        local sbar              = self.dsp:GetVBar( )
                                        local mar_r_s           = ui:visible( sbar ) and 15 or 0
                                        local mar_r_dsp         = ui:visible( sbar ) and 5 or 0

                                        s:DockMargin            ( 0, 0, mar_r_s, 0  )
                                        self.dsp:DockMargin     ( 5, 5, mar_r_dsp, 0 )
                                    end )

        /*
            item > sub
        */

        local lst_i_sub             = ui.new( 'pnl', lst_i                  )
        :nodraw                     (                                       )
        :fill                       ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        //design.box( 0, 0, w, h, rclr.Hex( 'FFF', 25 ) )
                                    end )

        /*
            item > right
        */

        local lst_i_r               = ui.new( 'pnl', lst_i_sub              )
        :nodraw                     (                                       )
        :fill                       ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        design.text( m_name:upper( ), 5, h / 2, self.clr_title, pref( 'rcfg_lst_name' ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

                                        //design.rbox( 4, ( w / 2 ) - ( 74 / 2 ), ( h / 2 ) - ( 15 / 2 ) - 8, 74, 14, self.clr_ver_box )
                                        //design.text( m_ver, w / 2, h / 2 - 8, self.clr_ver_txt, pref( 'rcfg_lst_ver' ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                        //design.text( m_rel, w / 2 - 1, h / 2 + 8, self.clr_rel_txt, pref( 'rcfg_lst_rel' ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

        /*
            image > container
        */

        local lst_i_ct_img          = ui.new( 'pnl', lst_i_sub              )
        :left                       ( 'm', 4                                )
        :wide                       ( sz_item - 15                          )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, self.clr_item_img_box )
                                    end )

        /*
            image > dhtml src
        */

        local lst_i_av_url          = ui.new( 'dhtml', lst_i_ct_img         )
        :nodraw                     (                                       )
        :fill                       ( 'm', 1                                )
        :sbar                       ( false                                 )

                                    lst_i_av_url:SetHTML(
                                    [[
                                        <body style='overflow: hidden; height: 100%; width: 100%; margin:0px;'>
                                            <img width='100%' height='100%' style='width:100%;height:100%;' src=']] .. m_img .. [['>
                                        </body>
                                    ]])

        /*
            image > dhtml src
        */

        local lst_i_av_def          = ui.new( 'dhtml', lst_i_ct_img         )
        :nodraw                     (                                       )
        :fill                       ( 'm', 1                                )
        :sbar                       ( false                                 )

                                    lst_i_av_url:SetHTML(
                                    [[
                                        <body style='overflow: hidden; height: 100%; width: 100%; margin:0px;'>
                                            <img width='100%' height='100%' style='width:100%;height:100%;' src=']] .. m_def .. [['>
                                        </body>
                                    ]])

        /*
            image > btn
        */

        local lst_i_b_hover         = ui.new( 'btn', lst_i                  )
        :bsetup                     (                                       )
        :notext                     (                                       )
        :fill                       ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        if s.hover then
                                            design.rbox( 4, w - 5, 0, 5, h, self.clr_item_hvr_box )
                                        end

                                    end )

                                    :oc( function( s )

                                        /*
                                            clear mini tabs selection
                                        */

                                        for b in helper.get.data( self.tabs ) do
                                            b.selected = false
                                        end


                                        self:SetData( v )

                                        /*
                                            set selected
                                        */

                                        table.insert( self.tabs, lst_i )
                                        lst_i.selected = true
                                    end )

        /*
            count loop progress
        */

        i = i + 1

        /*
            hide spacer if last item in list
        */

        if i == i_modules then
            ui:hide( self.sp )
        end

    end

    /*
        spacer > bottom
    */

    self.ct_ftr_sp                  = ui.new( 'pnl', self.dsp               )
    :nodraw                         (                                       )
    :top                            ( 'm', 0                                )
    :tall                           ( 0                                     )

    /*
        footer
    */

    self.ct_ftr                     = ui.new( 'pnl', self                   )
    :bottom                         ( 'm', 0, 0, 0, 0                       )
    :tall                           ( 30                                    )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, self.clr_pnl_ftr_box )
                                        draw.SimpleText( str_rlib_ver, pref( 'rcfg_footer_i' ), 10, h / 2, self.clr_pnl_ftr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( str_modules, pref( 'rcfg_footer_i' ), w - 10, h / 2, self.clr_pnl_ftr_txt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                                    end )

end

/*
    SetData

    @param  : tbl module
*/

function PANEL:SetData( mod )

    /*
        declare > parent
    */

    local parent                    = self.ct_right_cont
                                    parent:Clear( )

    /*
        declare > module info
    */

    local sel_name                  = mod.name           or 'Untitled Module'
    local sel_ver                   = sf( '%s', rlib.get:ver2str_mf( mod ) )
    local sel_rel                   = mod.released and os.date( '%m.%d.%y', mod.released )     or 'Unknown'
    local sel_desc                  = mod.desc           or 'No description'
    local sel_sid                   = mod.owner          or 'Unregistered'
    sel_sid                         = sel_sid:gsub( '{{ owner_id }}', 'Unregistered' )
    local sel_id                    = mod.script_id      or '0000'
    sel_id                          = sel_id:gsub( '{{ script_id }}', 'Unregistered' )

    local sel_ws                    = mod.ws_lst or mod.workshops or mod.workshop or false

    /*
        validate workshops
    */

    if istable( sel_ws ) and not table.IsEmpty( sel_ws ) then
        sel_ws = sel_ws[ 1 ]
    end

    if istable( sel_ws ) and table.IsEmpty( sel_ws ) then
        sel_ws = false
    end

    /*
        declare > parent
    */

    local sel_oid = nil
    steamworks.RequestPlayerInfo( sel_sid, function( steamName )
        sel_oid = helper.str:ok( steamName )  and steamName or 'Unregistered'
    end )

    /*
        module > selected > name
    */

    self.sel_par                    = ui.new( 'pnl', parent                 )
    :nodraw                         (                                       )
    :top                            ( 'm', 0, 0, 0, 5                      )
    :tall                           ( 50                                    )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, rclr.Hex( '202020' ) )
                                    end )

    /*
        module > selected > name
    */

    local obj_name                  = ui.new( 'dt', self.sel_par            )
    :fill                           ( 'm', 10, 0, 0, 0                      )
    :tall                           ( 31                                    )
    :drawbg                         ( false                                 )
    :mline	                        ( false 				                )
    :ascii	                        ( false 				                )
    :canedit	                    ( false 				                )
    :scur	                        ( Color( 255, 255, 255, 255 ), 'beam'   )
    :txt	                        ( sel_name, Color( 255, 255, 255, 210 ), pref( 'rcfg_sel_name' ) )
    :ocnf                           ( true                                  )

    /*
        module > selected > ver
    */

    local obj_ver                   = ui.new( 'lbl', self.sel_par           )
    :right                          ( 'm', 0, 0, 10, 0                       )
    :tall                           ( 20                                    )
    :mline	                        ( false 				                )
    :txt	                        ( sel_ver, Color( 222, 222, 222, 244 ), pref( 'rcfg_sel_ver' ) )
    :align                          ( 6                                     )
    :wide                           ( 100                                   )

    /*
        module > selected > desc
    */

    local sel_sub                    = ui.new( 'pnl', parent                )
    :nodraw                         (                                       )
    :fill                            ( 'm', 5, 5, 5, 5                      )

    local obj_desc 				    = ui.new( 'rlib.elm.text', sel_sub       )
    :fill                           ( 'm', 5, 0, 0, 20                       )
    :param                          ( 'SetTextColor', Color( 255, 255, 255, 100 ) )
    :param                          ( 'SetFont', pref( 'rcfg_sel_desc' )    )
    :paramv                         ( 'SetData', sel_desc, 15               )
    :param                          ( 'SetAlwaysVisible', true              )

    local lst_data =
    {
        { name = 'Owner', data = sel_oid, sort = 1 },
        { name = 'Released', data = sel_rel, sort = 2 },
        { name = 'Version', data = rlib.get:ver2str( mod.version ), sort = 4 },
        { name = 'Requires Lib', data = rlib.get:ver2str( mod.libreq ), sort = 5 },
        { name = 'Status', data = mod.enabled and 'Enabled' or 'Disabled', sort = 3 },
    }

    table.SortByMember( lst_data, "sort" )

    for k, v in pairs( lst_data ) do

        /*
            module > selected > owner
        */

        local obj_sid                   = ui.new( 'dt', sel_sub                  )
        :nodraw                         (                                       )
        :bottom                         ( 'm', 0, 0, 0, 0                       )
        :tall                           ( 31                                    )

                                        :draw( function( s, w, h )
                                            design.box( 0, 0, w, h, rclr.Hex( '2d2d2d' ) )
                                            design.box( 0, 0, 120, h, rclr.Hex( '242424' ) )
                                            design.box( 120, 0, 1, h, rclr.Hex( 'FFFFFF', 5 ) )
                                            design.box( 0, 0, w, 1, rclr.Hex( 'FFFFFF', 5 ) )
                                            design.box( 0, 0, 1, h, rclr.Hex( 'FFFFFF', 5 ) )
                                            design.box( 0, h - 1, w, 1, rclr.Hex( 'FFFFFF', 5 ) )
                                            design.box( w - 1, 0, 1, h, rclr.Hex( 'FFFFFF', 5 ) )
                                            design.text( v.name, 120 - 15, h / 2, rclr.Hex( 'b05353' ), pref( 'rcfg_sel_ver' ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                                            design.text( v.data, 120 + 10, h / 2, Color( 255, 255, 255, 155 ), pref( 'rcfg_sel_ver' ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        end )

    end

    /*
        module > workshop button
    */

    local obj_ws                    = ui.new( 'btn', sel_sub                )
    :bsetup                         (                                       )
    :nodraw                         (                                       )
    :bottom                         ( 'm', 0, 0, 0, 10                      )
    :notext                         (                                       )
    :tall                           ( 40                                    )
    :state                          ( sel_ws and true or false              )

                                    :draw( function( s, w, h )
                                        design.rbox( 4, 0, 0, w, h, rclr.Hex( '3750ae' ) )
                                        if s.hover then
                                            design.rbox( 4, 0, 0, w, h, rclr.Hex( 'FFFFFF', 100 ) )
                                        end

                                        design.text( 'View Workshop', w / 2, h / 2, Color( 255, 255, 255, 155 ), pref( 'rcfg_ws' ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

                                    :oc( function( s )
                                        local url           = ( ( isstring( sel_ws ) or isnumber( sel_ws ) ) and sel_ws ) or false
                                                            if not url then return end
                                        local ws_url        = string.format( 'https://steamcommunity.com/sharedfiles/filedetails/?id=%i', url )

                                        gui.OpenURL( ws_url )
                                    end )


end

/*
    Think
*/

function PANEL:Think( )
    self.BaseClass.Think( self )

    local mousex    = math.Clamp( gui.MouseX( ), 1, ScrW( ) - 1 )
    local mousey    = math.Clamp( gui.MouseY( ), 1, ScrH( ) - 1 )

    if self.Dragging then
        local x     = mousex - self.Dragging[ 1 ]
        local y     = mousey - self.Dragging[ 2 ]

        if self:GetScreenLock( ) then
            x       = math.Clamp( x, 0, ScrW( ) - self:GetWide( ) )
            y       = math.Clamp( y, 0, ScrH( ) - self:GetTall( ) )
        end

        self:SetPos ( x, y )
    end

    if self.Sizing then
        local x         = mousex - self.Sizing[ 1 ]
        local y         = mousey - self.Sizing[ 2 ]
        local px, py    = self:GetPos( )

        if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW( ) - px and self:GetScreenLock( ) ) then x = ScrW( ) - px end
        if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH( ) - py and self:GetScreenLock( ) ) then y = ScrH( ) - py end

        self:SetSize    ( x, y )
        self:SetCursor  ( 'sizenwse' )
        return
    end

    if ( self.Hovered and self.m_bSizable and mousex > ( self.x + self:GetWide( ) - 20 ) and mousey > ( self.y + self:GetTall( ) - 20 ) ) then
        self:SetCursor  ( 'sizenwse' )
        return
    end

    if ( self.Hovered and self:GetDraggable( ) and mousey < ( self.y + 24 ) ) then
        self:SetCursor  ( 'sizeall' )
        return
    end

    self:SetCursor( 'arrow' )

    if self.y < 0 then self:SetPos( self.x, 0 ) end

end

/*
    OnMousePressed
*/

function PANEL:OnMousePressed( )
    if ( self.m_bSizable and gui.MouseX( ) > ( self.x + self:GetWide( ) - 20 ) and gui.MouseY( ) > ( self.y + self:GetTall( ) - 20 ) ) then
        self.Sizing =
        {
            gui.MouseX( ) - self:GetWide( ),
            gui.MouseY( ) - self:GetTall( )
        }
        self:MouseCapture( true )
        return
    end

    if ( self:GetDraggable( ) and gui.MouseY( ) < ( self.y + 24 ) ) then
        self.Dragging =
        {
            gui.MouseX( ) - self.x,
            gui.MouseY( ) - self.y
        }
        self:MouseCapture( true )
        return
    end
end

/*
    OnMouseReleased
*/

function PANEL:OnMouseReleased( )
    self.Dragging           = nil
    self.Sizing             = nil
    self:MouseCapture       ( false )
end

/*
    PerformLayout
*/

function PANEL:PerformLayout( )
    local titlePush         = 0
    self.BaseClass.PerformLayout( self )

    self.lblTitle:SetPos    ( 17 + titlePush, 7 )
    self.lblTitle:SetSize   ( self:GetWide( ) - 25 - titlePush, 20 )
end

/*
    Paint

    @param  : int w
    @param  : int h
*/

function PANEL:Paint( w, h )
    design.rbox_adv( 0, 5, 0, w - 10, 34, Color( 30, 30, 30, 255 ), true, true, false, false )
end

/*
    ActionHide
*/

function PANEL:ActionHide( )
    self:SetMouseInputEnabled       ( false )
    self:SetKeyboardInputEnabled    ( false )
end

/*
    ActionShow
*/

function PANEL:ActionShow( )
    self:SetMouseInputEnabled       ( true )
    self:SetKeyboardInputEnabled    ( true )
end

/*
    GetTitle

    @return : str
*/

function PANEL:GetTitle( )
    return self.title
end

/*
    SetTitle

    @param  : str title
*/

function PANEL:SetTitle( title )
    self.lblTitle:SetText( '' )
    self.title = title
end

/*
    Destroy
*/

function PANEL:Destroy( )
    timex.expire( 'rlib_udm_check' )
    ui:destroy( self, true, true )
end

/*
    SetState

    @param  : bool bVisible
*/

function PANEL:SetState( bVisible )
    if bVisible then
        ui:show( self, true )
    else
        ui:hide( self, true )
    end
end

/*
    _Colorize
*/

function PANEL:_Colorize( )

    /*
        declare > cats
    */

    self.clr_hdr_ico                = Color( 240, 72, 133, 255 )
    self.clr_hdr_txt                = Color( 237, 237, 237, 255 )
    self.clr_hdr_btn_n              = Color( 237, 237, 237, 255 )
    self.clr_hdr_btn_h              = Color( 200, 55, 55, 255 )
    self.clr_title                  = Color( 38, 175, 99 )
    self.clr_ver_box                = Color( 194, 43, 84, 255 )
    self.clr_ver_txt                = Color( 255, 255, 255, 255 )
    self.clr_rel_txt                = Color( 255, 255, 255, 150 )
    self.clr_des_txt                = Color( 230, 230, 230, 255 )
    self.clr_pnl_ftr_box            = Color( 30, 30, 30, 255 )
    self.clr_pnl_ftr_txt            = Color( 150, 150, 150, 255 )
    self.clr_item_img_box           = Color( 255, 255, 255, 25 )
    self.clr_item_hvr_box           = rclr.Hex( 'FFF', 100 )

end

/*
    _Declare
*/

function PANEL:_Declare( )

    local s                     = self
    s._w, s._h                  = cfg.rcfg.ui.width, cfg.rcfg.ui.height

    s.tabs                      = { }

end

/*
    _Call
*/

function PANEL:_Call( )

    /*
        delay > setup tips
    */

    timex.simple( 0.1, function( )
        if not ui:ok( self ) then return end
    end )

end

/*
    register
*/

vgui.Register( 'rlib.lo.rcfg', PANEL, 'DFrame' )