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
local helper                = base.h
local design                = base.d
local ui                    = base.i

/*
    Localized translation func
*/

local function ln( ... )
    return base:lang( ... )
end

/*
 	prefix ids
*/

local function pref( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and mf.prefix ) or false
    return rlib.get:pref( str, state )
end

/*
    netlib
*/

local function netlib_udm_check( )
    mf.astra.oort.validated     = net.ReadBool( )
    mf.astra.oort.has_latest    = net.ReadBool( )
end
net.Receive( 'rlib.udm.check', netlib_udm_check )

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

    /*
        declare > sizes
    */

    self.ui_w, self.ui_h            = cfg.rlib.ui.width, cfg.rlib.ui.height

    /*
        declare > colors
    */

    local clr_cur                   = Color( 200, 200, 200, 255 )
    local clr_text                  = Color( 255, 255, 255, 255 )
    local clr_hl                    = Color( 25, 25, 25, 255 )
    local clr_box_status            = Color( 150, 50, 50, 255 )
    local state, r, g, b            = 0, 255, 0, 0

    /*
        parent
    */

    self:SetPaintShadow             ( true                                  )
    self:SetSize                    ( self.ui_w, self.ui_h                  )
    self:SetMinWidth                ( self.ui_w                             )
    self:SetMinHeight               ( self.ui_h                             )
    self:SetTitle                   ( ''                                    )
    self:MakePopup                  (                                       )
    self:SetSizable                 ( true                                  )
    self:ShowCloseButton            ( false                                 )
    self:DockPadding                ( 0, 34, 0, 0                           )

    /*
        declare > initialize
    */

    self.bInitialized               = false

    /*
        declare > general
    */

    self.conn_status                = ln( 'lib_oort_abt_status_pending' )
    self.conn_clr                   = Color( 200, 100, 100, 255 )
    self.svg_w                      = 100
    self.margin                     = self:GetWide( ) / 2 - 70

    /*
        animation
    */

    ui.anim_tocenter                ( self                                  )

    /*
        titlebar
    */

    self.lblTitle                   = ui.new( 'lbl', self                   )
    :notext                         (                                       )
    :font                           ( pref( 'about_title' )                 )
    :clr                            ( Color( 255, 255, 255, 255 )           )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( utf8.char( 9930 ), pref( 'about_icon' ), 0, 8, Color( 240, 72, 133, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( self:GetTitle( ), pref( 'about_title' ), 25, h / 2, Color( 237, 237, 237, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        close button

        to overwrite existing properties from the skin; do not change this
        buttons name to anything other than btnClose otherwise it wont
        inherit position/size properties
    */

    self.btnClose                   = ui.new( 'btn', self                   )
    :bsetup                         (                                       )
    :notext                         (                                       )
    :tooltip                        ( ln( 'tooltip_close' )                 )
    :ocr                            ( self                                  )

                                    :draw( function( s, w, h )
                                        local clr_txt = s.hover and Color( 200, 55, 55, 255 ) or Color( 237, 237, 237, 255 )
                                        draw.SimpleText( helper.get:utf8( 'close' ), pref( 'about_exit' ), w / 2, h / 2 + 4, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        subparent pnl
    */

    self.p_sub_header               = ui.new( 'pnl', self                   )
    :static                         ( TOP                                   )
    :margin                         ( 0                                     )
    :tall                           ( 70                                    )

                                    :draw( function( s, w, h )
                                        design.rbox( 0, 5, 0, w - 10, h, Color( 34, 34, 34, 255 ) )
                                        design.box( 5, h - 1, w - 10, 2, Color( 35, 35, 35, 255 ) )

                                        if ( state == 0 ) then
                                            g = g + 1
                                            if ( g == 255 ) then state = 1 end
                                        elseif ( state == 1 ) then
                                            r = r - 1
                                            if ( r == 0 ) then state = 2 end
                                        elseif ( state == 2 ) then
                                            b = b + 1
                                            if ( b == 255 ) then state = 3 end
                                        elseif ( state == 3 ) then
                                            g = g - 1
                                            if ( g == 0 ) then state = 4 end
                                        elseif ( state == 4 ) then
                                            r = r + 1
                                            if ( r == 255 ) then state = 5 end
                                        elseif ( state == 5 ) then
                                            b = b - 1
                                            if ( b == 0 ) then state = 0 end
                                        end

                                        local clr_rgb = Color( r, g, b )

                                        draw.SimpleText( self:GetHeader( ), pref( 'about_name' ), w / 2, h / 2, clr_rgb, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        status :: container
    */

    self.p_status                   = ui.new( 'pnl', self                   )
    :static                         ( TOP                                   )
    :margin                         ( 0                                     )
    :tall                           ( 20                                    )

                                    :draw( function( s, w, h )
                                        design.rbox( 0, 2, 1, w - 4, h, Color( 15, 15, 15, 230 ) )
                                        design.blur( s, 0.5 )
                                        design.rbox( 0, 0, 2, w, h, Color( clr_box_status.r, clr_box_status.g, clr_box_status.b, 255 ) )
                                    end )

    /*
        tags
    */

    self.p_tags                     = ui.new( 'pnl', self, 1                )
    :static                         ( TOP                                   )
    :margin                         ( 0, 20, 0, 0                          )
    :tall                           ( 30                                    )

    /*
        svg :: objects
    */

    self.svg_updated                = ui.new( 'rlib.lo.svg.c', self.p_tags  )
    :fill                           ( 'm', self.margin, 0, self.margin, 0   )
    :tall                           ( 30                                    )
    :param                          ( 'SetImg', mf.astra.svg.updated        )

    /*
        status :: label
    */

    self.l_status                   = ui.new( 'lbl', self.p_status          )
    :static                         ( FILL                                  )
    :margin                         ( 3, 5, 3, 1                            )
    :font                           ( pref( 'about_status' )                )
    :text                           ( ln( 'lib_udm_checking' )              )
    :clr                            ( Color( 255, 255, 255, 255 )           )
    :align                          ( 5                                     )

                                    :logic( function( s )
                                        s:SetColor( Color( 255, 255, 255, 255 ) )
                                    end )

    /*
        subparent pnl
    */

    self.p_subparent                = ui.new( 'pnl', self, 1                )
    :static                         ( FILL                                  )
    :margin                         ( 10, 10, 10, 10                        )

    /*
        line :: version
    */

    self.p_entry_one                = ui.new( 'pnl', self.p_subparent       )
    :static                         ( TOP                                   )
    :margin                         ( 0                                     )
    :tall                           ( 35                                    )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( ln( 'label_version' ), pref( 'about_entry_label' ), w / 2 - 20, h / 2, Color( 200, 100, 100, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( base.get:ver2str_mf( ), pref( 'about_entry_value' ), w / 2, h / 2, Color( 237, 237, 237, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        line :: release date
    */

    self.p_entry_two                = ui.new( 'pnl', self.p_subparent       )
    :static                         ( TOP                                   )
    :margin                         ( 0                                     )
    :tall                           ( 35                                    )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( ln( 'label_released' ), pref( 'about_entry_label' ), w / 2 - 20, h / 2, Color( 200, 100, 100, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( os.date( '%m.%d.%Y', mf.released ), pref( 'about_entry_value' ), w / 2, h / 2, Color( 237, 237, 237, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        line :: author
    */

    self.p_entry_three              = ui.new( 'pnl', self.p_subparent       )
    :static                         ( TOP                                   )
    :margin                         ( 0, 0, 0, 15                           )
    :tall                           ( 35                                    )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( ln( 'label_author' ), pref( 'about_entry_label' ), w / 2 - 20, h / 2, Color( 200, 100, 100, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( mf.author, pref( 'about_entry_value' ), w / 2, h / 2, Color( 237, 237, 237, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        desc container
    */

    self.p_desc                     = ui.new( 'pnl', self.p_subparent       )
    :static                         ( FILL                                  )
    :padding                        ( 10                                    )

                                    :draw( function( s, w, h )
                                        design.rbox( 6, 0, 0, w, h, Color( 30, 30, 30, 255 ) )
                                    end )

    /*
        dtxt_input textentry
    */

    self.dtxt_desc                  = ui.new( 'entry', self.p_desc          )
    :static		                    ( FILL 					                )
    :padding		                ( 0 			                        )
    :drawbg                         ( false                                 )
    :mline	                        ( true 				                    )
    :enabled                        ( true                                  )
    :canedit                        ( true                                  )
    :autoupdate	                    ( true 					                )
    :scur	                        ( Color( 255, 255, 255, 255 ), 'beam'   )
    :txt	                        ( mf.about, Color( 255, 255, 255, 255 ), pref( 'about_entry' ) )
    :drawentry                      ( clr_text, clr_cur, clr_hl             )

                                    :ontxtchg( function( s )
                                        s:SetText( mf.about )
                                    end )

    /*
        footer
    */

    local clr_box, clr_box2         = Color( 46, 46, 46, 255 ), Color( 46, 46, 46, 255 )

    self.p_ftr                      = ui.new( 'pnl', self.p_subparent       )
    :static                         ( BOTTOM                                )
    :margin                         ( 0, 5, 0, 3                            )
    :tall                           ( 20                                    )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, Color( 50, 50, 50, 255 ) )
                                        design.box( 1, 1, w - 2, h - 2, Color( 34, 34, 34, 255 ) )

                                        design.box( 6, ( h / 2 ) - ( 10 / 2 ), 10, 10, clr_box )
                                        design.box( 6 + 10 + 3, ( h / 2 ) - ( 10 / 2 ), 10, 10, clr_box2 )

                                        draw.SimpleText( self.conn_status, pref( 'about_status_conn' ), w - 6, h / 2 + 1, self.conn_clr, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                                    end )

                                    :logic( function( s )
                                        if not ui:ok( s ) then return end
                                        if not mf.astra.oort.validated then return end
                                        if not timex.exists( 'rlib_about_indic_l1_r1' ) then
                                            timex.create( 'rlib_about_indic_l1_r1', math.random( 0.5, 1 ), 1, function( )
                                                clr_box = Color( 46, 46, 50, 255 )
                                            end )
                                            if not timex.exists( 'rlib_about_indic_l1_r2' ) then
                                                timex.create( 'rlib_about_indic_l1_r2', math.random( 0.5, 1 ), 1, function( )
                                                    clr_box2 = Color( 46, 46, 50, 255 )
                                                end )
                                            end
                                        end

                                        if not timex.exists( 'rlib_about_indic_l2_r1' ) then
                                            timex.create( 'rlib_about_indic_l2_r1', math.random( 0.5, 3 ), 1, function( )
                                                clr_box = Color( 255, 50, 50, 255 )
                                            end )
                                            if not timex.exists( 'rlib_about_indic_l2_r2' ) then
                                                timex.create( 'rlib_about_indic_l2_r2', math.random( 0.5, 3 ), 1, function( )
                                                    clr_box2 = Color( 255, 50, 50, 255 )
                                                end )
                                            end
                                        end
                                    end )

    /*
        update timer

        checks the current version of rlib installed with the latest version to determine
        if updates are needed
    */

    timex.create( 'rlib_udm_check', 30, 1, function( )

        /*
            network update check
        */

        net.Start           ( 'rlib.udm.check' )
        net.SendToServer    ( )

        rlib:log( 6, ln( 'lib_udm_timer_ran' ) )

    end )

    /*
        initialize timer
    */

    timex.simple( 'rlib_about_run', 3, function( )
        if not ui:ok( self ) then return end
        if not mf.astra.oort.has_latest then
            ui:show( self.p_status )
            self.l_status:SetText   ( ln( 'lib_udm_outdated' ) )
        else
            self.l_status:SetText   ( ln( 'lib_udm_latest' ) )
            clr_box_status          = Color( 50, 80, 50, 255 )
        end

        if mf.astra.oort.validated then
            self.conn_status        = ln( 'lib_oort_abt_status_ok' )
            self.conn_clr           = Color( 0, 134, 51, 255 )
            return
        end

        self.conn_status            = ln( 'lib_oort_abt_status_err' )
    end )

end

/*
    FirstRun
*/

function PANEL:FirstRun( )
    self.bInitialized = true
end

/*
    Think
*/

function PANEL:Think( )
    self.BaseClass.Think( self )

    local mousex = math.Clamp( gui.MouseX( ), 1, ScrW( ) - 1 )
    local mousey = math.Clamp( gui.MouseY( ), 1, ScrH( ) - 1 )

    if self.Dragging then
        local x = mousex - self.Dragging[ 1 ]
        local y = mousey - self.Dragging[ 2 ]

        if self:GetScreenLock( ) then
            x = math.Clamp( x, 0, ScrW( ) - self:GetWide( ) )
            y = math.Clamp( y, 0, ScrH( ) - self:GetTall( ) )
        end

        self:SetPos( x, y )
    end

    if self.Sizing then
        local x         = mousex - self.Sizing[ 1 ]
        local y         = mousey - self.Sizing[ 2 ]
        local px, py    = self:GetPos( )

        if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW( ) - px and self:GetScreenLock( ) ) then x = ScrW( ) - px end
        if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH( ) - py and self:GetScreenLock( ) ) then y = ScrH( ) - py end

        self:SetSize( x, y )
        self:SetCursor( 'sizenwse' )
        return
    end

    if ( self.Hovered and self.m_bSizable and mousex > ( self.x + self:GetWide( ) - 20 ) and mousey > ( self.y + self:GetTall( ) - 20 ) ) then
        self:SetCursor( 'sizenwse' )
        return
    end

    if ( self.Hovered and self:GetDraggable( ) and mousey < ( self.y + 24 ) ) then
        self:SetCursor( 'sizeall' )
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
    self.Dragging   = nil
    self.Sizing     = nil
    self:MouseCapture( false )
end

/*
    PerformLayout
*/

function PANEL:PerformLayout( )

    /*
        initialize only
    */

    if not self.bInitialized then
        self:FirstRun( )
    end

    local titlePush = 0
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
    design.rbox( 4, 5, 0, w - 10, h - 8, Color( 40, 40, 40, 255 ) )
    design.rbox_adv( 0, 5, 0, w - 10, 34, Color( 30, 30, 30, 255 ), true, true, false, false )

    -- resizing arrow
    draw.SimpleText( utf8.char( 9698 ), pref( 'about_resizer' ), w - 3, h - 10, Color( 240, 72, 133, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
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
    SetTitle

    @param  : str str
*/

function PANEL:SetTitle( str )
    self.lblTitle:SetText( '' )
    self._title = str
end

/*
    GetTitle

    @return : str
*/

function PANEL:GetTitle( )
    self.lblTitle:SetText( '' )
    return ( helper.str:ok( self._title ) and self._title ) or ln( 'title_about' )
end

/*
    SetHeader

    @param  : str str
*/

function PANEL:SetHeader( str )
    self._header = str
end

/*
    GetHeader

    @return : str
*/

function PANEL:GetHeader( )
    return ( helper.str:ok( self._header ) and self._header ) or mf.name
end

/*
    SetHeader

    @param  : str str
*/

function PANEL:SetHeader( str )
    self._header = str
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
    register
*/

vgui.Register( 'rlib.lo.main', PANEL, 'DFrame' )