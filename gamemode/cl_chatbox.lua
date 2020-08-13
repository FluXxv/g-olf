/* G-Olf Chat Box */

local chatbox = {}

net.Receive( "g-olf_chat", function( len, ply )
	local text = net.ReadString()
	
	if ( chatbox.FadeChat ~= nil ) then
		chatbox.FadeChat:AppendText( "\n" .. text )
		chatbox.PANEL.Chat:AppendText( "\n" .. text )
	end
end )

chatbox.FadeChat = vgui.Create( "RichText" )
chatbox.FadeChat:SetSize( ScrW() / 3 - 4, ScrH() / 4 - 39 )
chatbox.FadeChat:SetPos( 22, ScrH() / 2 + 25 )
chatbox.FadeChat:SetVerticalScrollbarEnabled( false )
chatbox.FadeChat:SetMouseInputEnabled( false )
chatbox.FadeChat:SetContentAlignment( 1 )
chatbox.FadeChat:InsertColorChange( 255, 255, 255, 255 )
function chatbox.FadeChat:PerformLayout()
	self:SetFontInternal( "ChatFont" )
	self:InsertFade( 7, 2 )
end

if ( chatbox.PANEL == nil or !IsValid( chatbox.PANEL ) ) then
	chatbox.PANEL = vgui.Create( "DFrame" )
	chatbox.PANEL:SetSize( ScrW() / 3, ScrH() / 4 + 4 )
	chatbox.PANEL:SetPos( 20, ScrH() / 2 )
	chatbox.PANEL:SetTitle( "G-Olf Chat" )
	chatbox.PANEL:ShowCloseButton( false )
	chatbox.PANEL:SetDraggable( false )
	chatbox.PANEL:SetVisible( false )
	chatbox.PANEL:MakePopup()
	
	chatbox.PANEL.Chat = vgui.Create( "RichText", chatbox.PANEL )
	chatbox.PANEL.Chat:SetSize( chatbox.PANEL:GetWide() - 4, chatbox.PANEL:GetTall() - 43 )
	chatbox.PANEL.Chat:SetPos( 2, 25 )
	chatbox.PANEL.Chat:InsertColorChange( 255, 255, 255, 255 )
	function chatbox.PANEL.Chat:PerformLayout()
		self:SetFontInternal( "ChatFont" )
		self:SetContentAlignment( 1 )
	end
	
	chatbox.PANEL.TextEntry_Background = vgui.Create( "DPanel", chatbox.PANEL )
	chatbox.PANEL.TextEntry_Background:SetSize( chatbox.PANEL:GetWide() - 4, 18 )
	chatbox.PANEL.TextEntry_Background:SetPos( 2, chatbox.PANEL:GetTall() - 20 )
	chatbox.PANEL.TextEntry_Background:SetBackgroundColor( Color( 200, 200, 200 ) )
	
	chatbox.PANEL.TextEntry_Default = vgui.Create( "DLabel", chatbox.PANEL.TextEntry_Background )
	chatbox.PANEL.TextEntry_Default:SetSize( chatbox.PANEL.TextEntry_Background:GetWide(), chatbox.PANEL.TextEntry_Background:GetTall() )
	chatbox.PANEL.TextEntry_Default:SetPos( 3, 0 )
	chatbox.PANEL.TextEntry_Default:SetFont( "ChatFont" )
	chatbox.PANEL.TextEntry_Default:SetTextColor( Color( 255, 255, 255 ) )
	chatbox.PANEL.TextEntry_Default:SetContentAlignment( 4 )
	chatbox.PANEL.TextEntry_Default:SetText( "Say:" )
	
	chatbox.PANEL.TextEntry = vgui.Create( "DTextEntry", chatbox.PANEL.TextEntry_Background )
	chatbox.PANEL.TextEntry:SetSize( chatbox.PANEL.TextEntry_Background:GetWide() - 39 - chatbox.PANEL.TextEntry_Background:GetTall(), chatbox.PANEL.TextEntry_Background:GetTall() )
	chatbox.PANEL.TextEntry:SetPos( 39, 0 )
	chatbox.PANEL.TextEntry:SetCursorColor( Color( 0, 0, 0, 255 ) )
	chatbox.PANEL.TextEntry:SetFont( "ChatFont" )
	chatbox.PANEL.TextEntry:SetTextColor( Color( 255, 255, 255 ) )
	chatbox.PANEL.TextEntry:SetPaintBackground( false )
	chatbox.PANEL.TextEntry:SetAllowNonAsciiCharacters( true )
	chatbox.PANEL.TextEntry.TextString = ""
	chatbox.PANEL.TextEntry:RequestFocus()
	chatbox.PANEL.TextEntry.OnEnter = function( self )
		if ( self:GetValue() ~= nil && self:GetValue() ~= "" ) then
			net.Start( "g-olf_chat" )
				net.WriteString( self:GetValue() )
			net.SendToServer()
			
			self:SetText( "" )
		end
		
		chatbox.Close()
	end
	
	chatbox.PANEL.ImageButton = vgui.Create( "DImageButton", chatbox.PANEL.TextEntry_Background )
	chatbox.PANEL.ImageButton:SetSize( 16, 16 )
	chatbox.PANEL.ImageButton:SetPos( chatbox.PANEL.TextEntry_Background:GetWide() - 18, 1 )
	chatbox.PANEL.ImageButton:SetImage( "icon16/emoticon_smile.png" )
	chatbox.PANEL.ImageButton:SetEnabled( false )
	chatbox.PANEL.ImageButton.DoClick = function()
		chatbox.PANEL.SilkIcons:SetVisible( !chatbox.PANEL.SilkIcons:IsVisible() )
	end
	
	chatbox.PANEL.SilkIcons = vgui.Create( "DPanel" )
	chatbox.PANEL.SilkIcons:SetSize( ScrW() / 12, ScrH() / 4 + 4 )
	chatbox.PANEL.SilkIcons:SetPos( ScrW() / 3 + 20, ScrH() / 2 )
	chatbox.PANEL.SilkIcons:SetVisible( false )
	
	chatbox.PANEL.SilkIcons.IconBrowser = vgui.Create( "DIconBrowser", chatbox.PANEL.SilkIcons )
	chatbox.PANEL.SilkIcons.IconBrowser:Dock( FILL )
	chatbox.PANEL.SilkIcons.IconBrowser.OnChange = function( self )
		//chatbox.PANEL.TextEntry:SetText( chatbox.PANEL.TextEntry:GetText() .. self:GetSelectedIcon() )
		surface.SetFont( "ChatFont" )
		local w, h = surface.GetTextSize( chatbox.PANEL.TextEntry:GetText() )
		local Emoticon = chatbox.PANEL.TextEntry:Add( "DImage" )
		Emoticon:SetPos( w + 5, 0 )
		Emoticon:SetSize( 16, 16 )
		Emoticon:SetImage( self:GetSelectedIcon() )
	end
end

hook.Add( "PlayerBindPress", "g-olf", function( ply, bind, pressed )
	if ( bind == "messagemode" or bind == "messagemode2" ) then
		chatbox.Open()
		
		return true
	else
		return
	end
end )

chatbox.Open = function()
	if ( chatbox.PANEL ~= nil && IsValid( chatbox.PANEL ) ) then
		RestoreCursorPosition()
		
		chatbox.PANEL:SetVisible( true )
		chatbox.PANEL.TextEntry:RequestFocus()
	end
end

chatbox.Close = function()
	if ( chatbox.PANEL ~= nil && IsValid( chatbox.PANEL ) ) then
		RememberCursorPosition()
		
		chatbox.PANEL:SetVisible( false )
		chatbox.PANEL.SilkIcons:SetVisible( false )
	end
end
