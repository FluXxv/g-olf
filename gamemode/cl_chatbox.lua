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
chatbox.FadeChat:InsertColorChange( 255, 255, 255, 255 )
function chatbox.FadeChat:PerformLayout()
	self:SetFontInternal( "ChatFont" )
	self:InsertFade( 5, 2 )
	self:SetContentAlignment( 1 )
end

if ( chatbox.PANEL == nil or !IsValid( chatbox.PANEL ) ) then
	chatbox.PANEL = vgui.Create( "DFrame" )
	chatbox.PANEL:SetSize( ScrW() / 3, ScrH() / 4 + 4 )
	chatbox.PANEL:SetPos( 20, ScrH() / 2 )
	chatbox.PANEL:SetTitle( "G-Olf Chat" )
	chatbox.PANEL:ShowCloseButton( false )
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
	
	chatbox.PANEL.TextEntry = vgui.Create( "DTextEntry", chatbox.PANEL )
	chatbox.PANEL.TextEntry:SetSize( chatbox.PANEL:GetWide() - 4, 20 )
	chatbox.PANEL.TextEntry:SetPos( 2, chatbox.PANEL:GetTall() - 22 )
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
	end
end
