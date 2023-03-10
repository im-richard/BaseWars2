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
local helper                = base.h
local design                = base.d
local ui                    = base.i

/*
*   PANEL
*/

local PANEL = { }

/*
*   AccessorFunc
*/

AccessorFunc( PANEL, 'Padding',     'Padding' )
AccessorFunc( PANEL, 'pnlCanvas',   'Canvas' )

/*
*   Init
*/

function PANEL:Init( )

    /*
    *   declarations
    */

    self.bInitialized               = false

    /*
    *   canvas
    */

    self.pnlCanvas                  = ui.new( 'pnl', self                   )
    :nodraw                         (                                       )
    :allowmouse                     ( true                                  )
    :var                            ( 'Alpha', 255                          )

                                    :ompd( function( s, code )
                                        self:GetParent( ):OnMousePressed( code )
                                    end )

                                    :pl( function( s, w, h )
                                        self:PerformLayout( )
                                        self:InvalidateParent( )
                                    end )

    /*
    *   vbar
    */

    self.VBar                       = ui.new( 'rlib.ui.sbar.v1', self       )
    :right                          ( 'm', 0, 0, 6, 0                       )

    /*
    *   parent
    */

    self                            = ui.get( self                          )
    :spad                           (                                       )
    :allowmouse                     ( true                                  )
    :enginedraw                     ( false                                 )

end

/*
*   AddItem
*/

function PANEL:AddItem( pnl )
    pnl:SetParent( self:GetCanvas( ) )
end

/*
*   OnChildAdded
*/

function PANEL:OnChildAdded( child )
    self:AddItem( child )
end

/*
*   SizeToContents
*/

function PANEL:SizeToContents( )
    self:SetSize( self.pnlCanvas:GetSize( ) )
end

/*
*   GetVBar
*/

function PANEL:GetVBar( )
    return self.VBar
end

/*
*   GetCanvas
*/

function PANEL:GetCanvas( )
    return self.pnlCanvas
end

/*
*   GetAlphaOR
*/

function PANEL:GetAlphaOR( )
    return self.AlphaOR
end

/*
*   SetKnobColor
*/

function PANEL:SetKnobColor( clr )
    local color             = IsColor( clr ) and clr or Color( 255, 255, 255, 200 )
    self.KnobColor          = color
end

/*
*   GetKnobColor
*/

function PANEL:GetKnobColor( )
    return self.KnobColor
end

/*
*   InnerWidth
*/

function PANEL:InnerWidth( )
    return self:GetCanvas( ):GetWide( )
end

/*
*   Rebuild
*/

function PANEL:Rebuild( )
    self:GetCanvas( ):SizeToChildren( false, true )

    if ( self.m_bNoSizing and self:GetCanvas( ):GetTall( ) < self:GetTall( ) ) then
        self:GetCanvas( ):SetPos( 0, ( self:GetTall( ) - self:GetCanvas( ):GetTall( ) ) * 0.5 )
    end
end

/*
*   OnMouseWheeled
*/

function PANEL:OnMouseWheeled( dlta )
    return self.VBar:OnMouseWheeled( dlta )
end

/*
*   OnVScroll
*
*   @param  : int diff
*/

function PANEL:OnVScroll( diff )
    self.pnlCanvas:SetPos( 0, diff )
end

/*
*   ScrollToChild
*
*   @param  : pnl pnl
*/

function PANEL:ScrollToChild( pnl )
    self:PerformLayout( )

    local x, y              = self.pnlCanvas:GetChildPosition( pnl )
    local w, h              = pnl:GetSize( )
    y                       = y + h * 0.5
    y                       = y - self:GetTall( ) * 0.5

    self.VBar:AnimateTo     ( y, 0.5, 0, 0.5 )
end

/*
*   PerformLayout
*/

function PANEL:PerformLayout( )

    /*
    *   initialize only
    */

    if not self.bInitialized then
        self.bInitialized   = true
    end

    local sz_tall           = self.pnlCanvas:GetTall( )
    local sz_wide           = self:GetWide( )
    local pos_y             = 0

    self:Rebuild( )

    self.VBar:SetUp         ( self:GetTall( ), self.pnlCanvas:GetTall( ) )
    pos_y                   = self.VBar:GetOffset( )

    if ( self.VBar.Enabled ) then sz_wide = sz_wide - self.VBar:GetWide( ) end

    self.pnlCanvas:SetPos   ( 0, pos_y )
    self.pnlCanvas:SetWide  ( sz_wide )

    self:Rebuild( )

    if sz_tall ~= self.pnlCanvas:GetTall( ) then
        self.VBar:SetScroll( self.VBar:GetScroll( ) )
    end
end

/*
*   Think
*/

function PANEL:Think( )
    if self.AlphaOR then
        self.Alpha          = 255
        self.VBar.AlphaOR   = self.AlphaOR
    end

    if self.KnobColor then
        self.VBar.KnobColor = self.KnobColor
    end
end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h ) end

/*
*   Clear
*/

function PANEL:Clear( )
    return self.pnlCanvas:Clear( )
end

/*
*   DefineControl
*/

derma.DefineControl( 'rlib.ui.scrollpanel', 'rlib scrollpanel', PANEL, 'DPanel' )