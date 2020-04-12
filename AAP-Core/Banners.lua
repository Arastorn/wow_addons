AAP.Banners = {}
AAP.Banners.BannersFrame = {}
AAP.Banners.Range = {}
AAP.Banners.Range.P1 = {}
AAP.Banners.Range.P1.B1 = {}
AAP.Banners.Range.P1.B2 = {}
AAP.Banners.Range.P1.B3 = {}
AAP.Banners.Range.P2 = {}
AAP.Banners.Range.P2.B1 = {}
AAP.Banners.Range.P2.B2 = {}
AAP.Banners.Range.P2.B3 = {}
AAP.Banners.Range.P3 = {}
AAP.Banners.Range.P3.B1 = {}
AAP.Banners.Range.P3.B2 = {}
AAP.Banners.Range.P3.B3 = {}
AAP.Banners.Range.P4 = {}
AAP.Banners.Range.P4.B1 = {}
AAP.Banners.Range.P4.B2 = {}
AAP.Banners.Range.P4.B3 = {}
AAP.Banners.Range.P5 = {}
AAP.Banners.Range.P5.B1 = {}
AAP.Banners.Range.P5.B2 = {}
AAP.Banners.Range.P5.B3 = {}
AAP.Banners.Group = {}
AAP.Banners.Group["Nr"] = 0
AAP_RegisterChatBanner = C_ChatInfo.RegisterAddonMessagePrefix("AAPChatBanner")

function AAP_MakeBanners()
	AAP.Banners.BannersFrame = CreateFrame("frame", "AAP_BannersFrame", UIParent)
	AAP.Banners.BannersFrame:SetWidth(1)
	AAP.Banners.BannersFrame:SetHeight(1)
	AAP.Banners.BannersFrame:SetMovable(true)
	AAP.Banners.BannersFrame:EnableMouse(true)
	AAP.Banners.BannersFrame:SetFrameStrata("LOW")
	AAP.Banners.BannersFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	AAP.Banners.BannersFrame.Frame = CreateFrame("frame", "AAP_BannersFrames1", AAP.Banners.BannersFrame)
	AAP.Banners.BannersFrame.Frame:SetWidth(32)
	AAP.Banners.BannersFrame.Frame:SetHeight(20)
	AAP.Banners.BannersFrame.Frame:SetPoint("TOPLEFT", AAP.Banners.BannersFrame, "TOPLEFT",0,0)
	AAP.Banners.BannersFrame.Frame:Hide()
	AAP.Banners.BannersFrame.Frame:SetBackdrop( { 
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 10, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }
	});
	AAP.Banners.BannersFrame.Frame:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			AAP.Banners.BannersFrame:StartMoving();
			AAP.Banners.BannersFrame.isMoving = true;
		end
	end)
	AAP.Banners.BannersFrame.Frame:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and AAP.Banners.BannersFrame.isMoving then
			AAP.Banners.BannersFrame:StopMovingOrSizing();
			AAP.Banners.BannersFrame.isMoving = false;
			AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"] = AAP.Banners.BannersFrame:GetLeft()
			AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"] = AAP.Banners.BannersFrame:GetTop() - GetScreenHeight()
			AAP.Banners.BannersFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"])
		end
	end)
	AAP.Banners.BannersFrame.Frame:SetScript("OnHide", function(self)
		if ( AAP.Banners.BannersFrame.isMoving ) then
			AAP.Banners.BannersFrame:StopMovingOrSizing();
			AAP.Banners.BannersFrame.isMoving = false;
			AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"] = AAP.Banners.BannersFrame:GetLeft()
			AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"] = AAP.Banners.BannersFrame:GetTop() - GetScreenHeight()
			AAP.Banners.BannersFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"])
		end
	end)

	AAP.Banners.BannersFrame.FrameFS1 = AAP.Banners.BannersFrame.Frame:CreateFontString("BannerAAPFS1","ARTWORK", "ChatFontNormal")
	AAP.Banners.BannersFrame.FrameFS1:SetParent(AAP.Banners.BannersFrame.Frame)
	AAP.Banners.BannersFrame.FrameFS1:SetPoint("CENTER",AAP.Banners.BannersFrame.Frame,"CENTER",0,0)
	AAP.Banners.BannersFrame.FrameFS1:SetWidth(30)
	AAP.Banners.BannersFrame.FrameFS1:SetHeight(20)
	AAP.Banners.BannersFrame.FrameFS1:SetJustifyH("CENTER")
	AAP.Banners.BannersFrame.FrameFS1:SetFontObject("GameFontNormal")
	AAP.Banners.BannersFrame.FrameFS1:SetText(strsub(UnitName("player"),1,4))
	AAP.Banners.BannersFrame.FrameFS1:SetTextColor(1, 1, 0)

	AAP.Banners.BannersFrame.B1 = CreateFrame("Button", "AAP_BannersFrames1B1", UIParent, "SecureActionButtonTemplate")
	AAP.Banners.BannersFrame.B1:SetPoint("TOP", AAP.Banners.BannersFrame.Frame, "BOTTOM", 0, 0)
	AAP.Banners.BannersFrame.B1:SetWidth(30)
	AAP.Banners.BannersFrame.B1:SetHeight(30)
	AAP.Banners.BannersFrame.B1:SetText("")
	AAP.Banners.BannersFrame.B1:SetParent(AAP.Banners.BannersFrame.Frame)
	AAP.Banners.BannersFrame.B1:SetNormalFontObject("GameFontNormal")

	AAP.Banners.BannersFrame.B1ntex = AAP.Banners.BannersFrame.B1:CreateTexture()
	AAP.Banners.BannersFrame.B1ntex:SetTexture("Interface\\Icons\\inv_guild_standard_horde_c")
	AAP.Banners.BannersFrame.B1ntex:SetAllPoints()	
	AAP.Banners.BannersFrame.B1:SetNormalTexture(AAP.Banners.BannersFrame.B1ntex)
	AAP.Banners.BannersFrame.B1htex = AAP.Banners.BannersFrame.B1:CreateTexture()
	AAP.Banners.BannersFrame.B1htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	AAP.Banners.BannersFrame.B1htex:SetTexCoord(0, 0.625, 0, 0.6875)
	AAP.Banners.BannersFrame.B1htex:SetAllPoints()
	AAP.Banners.BannersFrame.B1CD = CreateFrame("Cooldown", "AAP_BannerCooldownB1", AAP.Banners.BannersFrame.B1, "CooldownFrameTemplate")
	AAP.Banners.BannersFrame.B1CD:SetAllPoints()
	AAP.Banners.BannersFrame.B1:SetHighlightTexture(AAP.Banners.BannersFrame.B1htex)
	AAP.Banners.BannersFrame.B1:SetNormalTexture("Interface\\Icons\\inv_guild_standard_horde_c")
	AAP.Banners.BannersFrame.B1:SetAttribute("type", "item");
	local aapfactionz = UnitFactionGroup("player")
	if (aapfactionz == "Alliance") then
		AAP.Banners.BannersFrame.B1:SetAttribute("item", "item:64399");
	else
		AAP.Banners.BannersFrame.B1:SetAttribute("item", "item:64402");
	end


	AAP.Banners.BannersFrame.B2 = CreateFrame("Button", "AAP_BannersFrames1B2", UIParent, "SecureActionButtonTemplate")
	AAP.Banners.BannersFrame.B2:SetPoint("TOP", AAP.Banners.BannersFrame.Frame, "BOTTOM", 0, -30)
	AAP.Banners.BannersFrame.B2:SetWidth(30)
	AAP.Banners.BannersFrame.B2:SetHeight(30)
	AAP.Banners.BannersFrame.B2:SetText("")
	AAP.Banners.BannersFrame.B2:SetParent(AAP.Banners.BannersFrame.Frame)
	AAP.Banners.BannersFrame.B2:SetNormalFontObject("GameFontNormal")
	AAP.Banners.BannersFrame.B2ntex = AAP.Banners.BannersFrame.B2:CreateTexture()
	AAP.Banners.BannersFrame.B2ntex:SetTexture("Interface\\Icons\\inv_guild_standard_horde_b")
	AAP.Banners.BannersFrame.B2ntex:SetAllPoints()	
	AAP.Banners.BannersFrame.B2:SetNormalTexture(AAP.Banners.BannersFrame.B2ntex)
	AAP.Banners.BannersFrame.B2htex = AAP.Banners.BannersFrame.B2:CreateTexture()
	AAP.Banners.BannersFrame.B2htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	AAP.Banners.BannersFrame.B2htex:SetTexCoord(0, 0.625, 0, 0.6875)
	AAP.Banners.BannersFrame.B2htex:SetAllPoints()
	AAP.Banners.BannersFrame.B2:SetHighlightTexture(AAP.Banners.BannersFrame.B2htex)
	AAP.Banners.BannersFrame.B2ptex = AAP.Banners.BannersFrame.B2:CreateTexture()
	AAP.Banners.BannersFrame.B2ptex:SetTexture("Interface\\Icons\\inv_guild_standard_horde_b")
	AAP.Banners.BannersFrame.B2ptex:SetAllPoints()
	AAP.Banners.BannersFrame.B2:SetPushedTexture(AAP.Banners.BannersFrame.B2ptex)
	AAP.Banners.BannersFrame.B2CD = CreateFrame("Cooldown", "AAP_BannerCooldownB2", AAP.Banners.BannersFrame.B2, "CooldownFrameTemplate")
	AAP.Banners.BannersFrame.B2CD:SetAllPoints()
	AAP.Banners.BannersFrame.B2:SetAttribute("type", "item");
	local aapfactionz = UnitFactionGroup("player")
	if (aapfactionz == "Alliance") then
		AAP.Banners.BannersFrame.B2:SetAttribute("item", "item:64398");
	else
		AAP.Banners.BannersFrame.B2:SetAttribute("item", "item:64401");
	end

	AAP.Banners.BannersFrame.B3 = CreateFrame("Button", "AAP_BannersFrames1B3", UIParent, "SecureActionButtonTemplate")
	AAP.Banners.BannersFrame.B3:SetPoint("TOP", AAP.Banners.BannersFrame.Frame, "BOTTOM", 0, -60)
	AAP.Banners.BannersFrame.B3:SetWidth(30)
	AAP.Banners.BannersFrame.B3:SetHeight(30)
	AAP.Banners.BannersFrame.B3:SetText("")
	AAP.Banners.BannersFrame.B3:SetParent(AAP.Banners.BannersFrame.Frame)
	AAP.Banners.BannersFrame.B3:SetNormalFontObject("GameFontNormal")
	AAP.Banners.BannersFrame.B3ntex = AAP.Banners.BannersFrame.B3:CreateTexture()
	AAP.Banners.BannersFrame.B3ntex:SetTexture("Interface\\Icons\\inv_guild_standard_horde_a")
	AAP.Banners.BannersFrame.B3ntex:SetAllPoints()	
	AAP.Banners.BannersFrame.B3:SetNormalTexture(AAP.Banners.BannersFrame.B3ntex)
	AAP.Banners.BannersFrame.B3htex = AAP.Banners.BannersFrame.B3:CreateTexture()
	AAP.Banners.BannersFrame.B3htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	AAP.Banners.BannersFrame.B3htex:SetTexCoord(0, 0.625, 0, 0.6875)
	AAP.Banners.BannersFrame.B3htex:SetAllPoints()
	AAP.Banners.BannersFrame.B3:SetHighlightTexture(AAP.Banners.BannersFrame.B3htex)
	AAP.Banners.BannersFrame.B3ptex = AAP.Banners.BannersFrame.B3:CreateTexture()
	AAP.Banners.BannersFrame.B3ptex:SetTexture("Interface\\Icons\\inv_guild_standard_horde_a")
	AAP.Banners.BannersFrame.B3ptex:SetAllPoints()
	AAP.Banners.BannersFrame.B3:SetPushedTexture(AAP.Banners.BannersFrame.B3ptex)
	AAP.Banners.BannersFrame.B3CD = CreateFrame("Cooldown", "AAP_BannerCooldownB3", AAP.Banners.BannersFrame.B3, "CooldownFrameTemplate")
	AAP.Banners.BannersFrame.B3CD:SetAllPoints()
	AAP.Banners.BannersFrame.B3:SetAttribute("type", "item");
	local aapfactionz = UnitFactionGroup("player")
	if (aapfactionz == "Alliance") then
		AAP.Banners.BannersFrame.B3:SetAttribute("item", "item:63359");
	else
		AAP.Banners.BannersFrame.B3:SetAttribute("item", "item:64400");
	end

	AAP.Banners.BannersFrame.FrameFS2 = AAP.Banners.BannersFrame.Frame:CreateFontString("BannerAAPFS2","ARTWORK", "ChatFontNormal")
	AAP.Banners.BannersFrame.FrameFS2:SetParent(AAP.Banners.BannersFrame.Frame)
	AAP.Banners.BannersFrame.FrameFS2:SetPoint("TOP", AAP.Banners.BannersFrame.Frame, "BOTTOM", 0, -90)
	AAP.Banners.BannersFrame.FrameFS2:SetWidth(30)
	AAP.Banners.BannersFrame.FrameFS2:SetHeight(20)
	AAP.Banners.BannersFrame.FrameFS2:SetJustifyH("CENTER")
	AAP.Banners.BannersFrame.FrameFS2:SetFontObject("GameFontNormal")
	AAP.Banners.BannersFrame.FrameFS2:SetText("")
	AAP.Banners.BannersFrame.FrameFS2:SetTextColor(1, 1, 0)

	local CLi
	for CLi = 1, 4 do
		AAP.Banners.BannersFrame["Frame"..CLi] = CreateFrame("frame", "AAP_BannersFrames"..CLi+1, AAP.Banners.BannersFrame)
		AAP.Banners.BannersFrame["Frame"..CLi]:SetWidth(32)
		AAP.Banners.BannersFrame["Frame"..CLi]:SetHeight(20)
		AAP.Banners.BannersFrame["Frame"..CLi]:SetPoint("TOPLEFT", AAP.Banners.BannersFrame, "TOPLEFT",-(32*CLi),0)
		AAP.Banners.BannersFrame["Frame"..CLi]:Hide()
		AAP.Banners.BannersFrame["Frame"..CLi]:SetBackdrop( { 
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true, tileSize = 10, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
		AAP.Banners.BannersFrame["Frame"..CLi]:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				AAP.Banners.BannersFrame:StartMoving();
				AAP.Banners.BannersFrame.isMoving = true;
			end
		end)
		AAP.Banners.BannersFrame["Frame"..CLi]:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" and AAP.Banners.BannersFrame.isMoving then
				AAP.Banners.BannersFrame:StopMovingOrSizing();
				AAP.Banners.BannersFrame.isMoving = false;
				AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"] = AAP.Banners.BannersFrame:GetLeft()
				AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"] = AAP.Banners.BannersFrame:GetTop() - GetScreenHeight()
				AAP.Banners.BannersFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"])
			end
		end)
		AAP.Banners.BannersFrame["Frame"..CLi]:SetScript("OnHide", function(self)
			if ( AAP.Banners.BannersFrame.isMoving ) then
				AAP.Banners.BannersFrame:StopMovingOrSizing();
				AAP.Banners.BannersFrame.isMoving = false;
				AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"] = AAP.Banners.BannersFrame:GetLeft()
				AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"] = AAP.Banners.BannersFrame:GetTop() - GetScreenHeight()
				AAP.Banners.BannersFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"])
			end
		end)
		AAP.Banners.BannersFrame["FrameFS1"..CLi] = AAP.Banners.BannersFrame.Frame:CreateFontString("BannerAAPFS1"..CLi,"ARTWORK", "ChatFontNormal")
		AAP.Banners.BannersFrame["FrameFS1"..CLi]:SetParent(AAP.Banners.BannersFrame["Frame"..CLi])
		AAP.Banners.BannersFrame["FrameFS1"..CLi]:SetPoint("CENTER",AAP.Banners.BannersFrame["Frame"..CLi],"CENTER",0,0)
		AAP.Banners.BannersFrame["FrameFS1"..CLi]:SetWidth(30)
		AAP.Banners.BannersFrame["FrameFS1"..CLi]:SetHeight(20)
		AAP.Banners.BannersFrame["FrameFS1"..CLi]:SetJustifyH("CENTER")
		AAP.Banners.BannersFrame["FrameFS1"..CLi]:SetFontObject("GameFontNormal")
		AAP.Banners.BannersFrame["FrameFS1"..CLi]:SetText("Name")
		AAP.Banners.BannersFrame["FrameFS1"..CLi]:SetTextColor(1, 1, 0)


		AAP.Banners.BannersFrame["FrameB2"..CLi] = CreateFrame("frame", "AAP_BannersFrames2B"..CLi, AAP.Banners.BannersFrame["Frame"..CLi])
		AAP.Banners.BannersFrame["FrameB2"..CLi]:SetWidth(30)
		AAP.Banners.BannersFrame["FrameB2"..CLi]:SetHeight(30)
		AAP.Banners.BannersFrame["FrameB2"..CLi]:SetPoint("TOP", AAP.Banners.BannersFrame["Frame"..CLi], "BOTTOM", 0, 0)
		AAP.Banners.BannersFrame["B2"..CLi] = AAP.Banners.BannersFrame["FrameB2"..CLi]:CreateTexture("AAP_BannersFramesz2B"..CLi, "OVERLAY")
		AAP.Banners.BannersFrame["B2"..CLi]:SetTexture("Interface\\Icons\\inv_guild_standard_horde_c")
		AAP.Banners.BannersFrame["B2"..CLi]:SetAllPoints()
		AAP.Banners.BannersFrame["B2CD"..CLi] = CreateFrame("Cooldown", "AAP_BannerCooldownB1", AAP.Banners.BannersFrame["FrameB2"..CLi], "CooldownFrameTemplate")
		AAP.Banners.BannersFrame["B2CD"..CLi]:SetAllPoints()

		AAP.Banners.BannersFrame["FrameB3"..CLi] = CreateFrame("frame", "AAP_BannersFrames3B"..CLi, AAP.Banners.BannersFrame["Frame"..CLi])
		AAP.Banners.BannersFrame["FrameB3"..CLi]:SetWidth(30)
		AAP.Banners.BannersFrame["FrameB3"..CLi]:SetHeight(30)
		AAP.Banners.BannersFrame["FrameB3"..CLi]:SetPoint("TOP", AAP.Banners.BannersFrame["Frame"..CLi], "BOTTOM", 0, -30)
		AAP.Banners.BannersFrame["B3"..CLi] = AAP.Banners.BannersFrame["FrameB3"..CLi]:CreateTexture("AAP_BannersFramesz3B"..CLi, "OVERLAY")
		AAP.Banners.BannersFrame["B3"..CLi]:SetTexture("Interface\\Icons\\inv_guild_standard_horde_b")
		AAP.Banners.BannersFrame["B3"..CLi]:SetAllPoints()
		AAP.Banners.BannersFrame["B3CD"..CLi] = CreateFrame("Cooldown", "AAP_BannerCooldownB3", AAP.Banners.BannersFrame["FrameB3"..CLi], "CooldownFrameTemplate")
		AAP.Banners.BannersFrame["B3CD"..CLi]:SetAllPoints()

		AAP.Banners.BannersFrame["FrameB4"..CLi] = CreateFrame("frame", "AAP_BannersFrames4B"..CLi, AAP.Banners.BannersFrame["Frame"..CLi])
		AAP.Banners.BannersFrame["FrameB4"..CLi]:SetWidth(30)
		AAP.Banners.BannersFrame["FrameB4"..CLi]:SetHeight(30)
		AAP.Banners.BannersFrame["FrameB4"..CLi]:SetPoint("TOP", AAP.Banners.BannersFrame["Frame"..CLi], "BOTTOM", 0, -60)
		AAP.Banners.BannersFrame["B4"..CLi] = AAP.Banners.BannersFrame["FrameB4"..CLi]:CreateTexture("AAP_BannersFramesz4B"..CLi, "OVERLAY")
		AAP.Banners.BannersFrame["B4"..CLi]:SetTexture("Interface\\Icons\\inv_guild_standard_horde_a")
		AAP.Banners.BannersFrame["B4"..CLi]:SetAllPoints()
		AAP.Banners.BannersFrame["B4CD"..CLi] = CreateFrame("Cooldown", "AAP_BannerCooldownB4", AAP.Banners.BannersFrame["FrameB4"..CLi], "CooldownFrameTemplate")
		AAP.Banners.BannersFrame["B4CD"..CLi]:SetAllPoints()

		AAP.Banners.BannersFrame["FrameFSs"..CLi] = AAP.Banners.BannersFrame["Frame"..CLi]:CreateFontString("BannerAAPFSs"..CLi,"ARTWORK", "ChatFontNormal")
		AAP.Banners.BannersFrame["FrameFSs"..CLi]:SetParent(AAP.Banners.BannersFrame["Frame"..CLi])
		AAP.Banners.BannersFrame["FrameFSs"..CLi]:SetPoint("TOP", AAP.Banners.BannersFrame["Frame"..CLi], "BOTTOM", 0, -90)
		AAP.Banners.BannersFrame["FrameFSs"..CLi]:SetWidth(30)
		AAP.Banners.BannersFrame["FrameFSs"..CLi]:SetHeight(20)
		AAP.Banners.BannersFrame["FrameFSs"..CLi]:SetJustifyH("CENTER")
		AAP.Banners.BannersFrame["FrameFSs"..CLi]:SetFontObject("GameFontNormal")
		AAP.Banners.BannersFrame["FrameFSs"..CLi]:SetText("")
		AAP.Banners.BannersFrame["FrameFSs"..CLi]:SetTextColor(1, 1, 0)

	end
end
function AAP_BannerRange()
	if (IsInInstance() ~= false) then
		return
	end
	local BannnerOnlinechk = 0
	local d_y, d_x = UnitPosition("player")
	local CheckSetR = 0
	if (AAP.Banners.Range.P2.X and AAP.Banners.Range.P2.Y) then
		local x, y
		x = AAP.Banners.Range.P2.X
		y = AAP.Banners.Range.P2.Y
		local deltaX, deltaY = d_x - x, y - d_y
		local distance = floor((deltaX * deltaX + deltaY * deltaY)^0.5)
		distance = 100-distance
		if (distance > 0) then
			AAP.Banners.BannersFrame["FrameFSs1"]:SetText(distance.."y")
		else
			AAP.Banners.BannersFrame["FrameFSs1"]:SetText("")
			AAP.Banners.Range.P2.X = nil
			AAP.Banners.Range.P2.Y = nil
		end
		BannnerOnlinechk = 1
	else
		AAP.Banners.BannersFrame["FrameFSs1"]:SetText("")
	end
	if (AAP.Banners.Range.P3.X and AAP.Banners.Range.P3.Y) then
		local x, y
		x = AAP.Banners.Range.P3.X
		y = AAP.Banners.Range.P3.Y
		local deltaX, deltaY = d_x - x, y - d_y
		local distance = floor((deltaX * deltaX + deltaY * deltaY)^0.5)
		distance = 100-distance
		if (distance > 0) then
			AAP.Banners.BannersFrame["FrameFSs2"]:SetText(distance.."y")
		else
			AAP.Banners.BannersFrame["FrameFSs2"]:SetText("")
			AAP.Banners.Range.P3.X = nil
			AAP.Banners.Range.P3.Y = nil
		end
		BannnerOnlinechk = 1
	else
		AAP.Banners.BannersFrame["FrameFSs2"]:SetText("")
	end
	if (AAP.Banners.Range.P4.X and AAP.Banners.Range.P4.Y) then
		local x, y
		x = AAP.Banners.Range.P4.X
		y = AAP.Banners.Range.P4.Y
		local deltaX, deltaY = d_x - x, y - d_y
		local distance = floor((deltaX * deltaX + deltaY * deltaY)^0.5)
		distance = 100-distance
		if (distance > 0) then
			AAP.Banners.BannersFrame["FrameFSs3"]:SetText(distance.."y")
		else
			AAP.Banners.BannersFrame["FrameFSs3"]:SetText("")
			AAP.Banners.Range.P4.X = nil
			AAP.Banners.Range.P4.Y = nil
		end
		BannnerOnlinechk = 1
	else
		AAP.Banners.BannersFrame["FrameFSs3"]:SetText("")
	end
	if (AAP.Banners.Range.P5.X and AAP.Banners.Range.P5.Y) then
		local x, y
		x = AAP.Banners.Range.P5.X
		y = AAP.Banners.Range.P5.Y
		local deltaX, deltaY = d_x - x, y - d_y
		local distance = floor((deltaX * deltaX + deltaY * deltaY)^0.5)
		distance = 100-distance
		if (distance > 0) then
			AAP.Banners.BannersFrame["FrameFSs4"]:SetText(distance.."y")
		else
			AAP.Banners.BannersFrame["FrameFSs4"]:SetText("")
			AAP.Banners.Range.P5.X = nil
			AAP.Banners.Range.P5.Y = nil
		end
		BannnerOnlinechk = 1
	else
		AAP.Banners.BannersFrame["FrameFSs4"]:SetText("")
	end




	if (AAP.Banners.Range.P1.B1.X and d_y and d_x) then
		local x, y
		x = AAP.Banners.Range.P1.B1.X
		y = AAP.Banners.Range.P1.B1.Y
		local deltaX, deltaY = d_x - x, y - d_y
		local distance = floor((deltaX * deltaX + deltaY * deltaY)^0.5)
		distance = 100-distance
		if (distance > 0) then
			AAP.Banners.BannersFrame.FrameFS2:SetText(distance.."y")
			CheckSetR = 1
		else
			AAP.Banners.BannersFrame.B1:SetText("")
			AAP.Banners.Range.P1.B1.X = nil
			AAP.Banners.Range.P1.B1.Y = nil
		end
		BannnerOnlinechk = 1
	else
		AAP.Banners.BannersFrame.B1:SetText("")
	end
	if (AAP.Banners.Range.P1.B2.X and d_y and d_x) then
		local x, y
		x = AAP.Banners.Range.P1.B2.X
		y = AAP.Banners.Range.P1.B2.Y
		local deltaX, deltaY = d_x - x, y - d_y
		local distance = floor((deltaX * deltaX + deltaY * deltaY)^0.5)
		distance = 100-distance
		if (distance > 0 and CheckSetR == 0) then
			AAP.Banners.BannersFrame.FrameFS2:SetText(distance.."y")
			CheckSetR = 1
		else
			AAP.Banners.BannersFrame.B2:SetText("")
			AAP.Banners.Range.P1.B2.X = nil
			AAP.Banners.Range.P1.B2.Y = nil
		end
		BannnerOnlinechk = 1
	else
		AAP.Banners.BannersFrame.B2:SetText("")
	end
	if (AAP.Banners.Range.P1.B3.X and d_y and d_x) then
		local x, y
		x = AAP.Banners.Range.P1.B3.X
		y = AAP.Banners.Range.P1.B3.Y
		local deltaX, deltaY = d_x - x, y - d_y
		local distance = floor((deltaX * deltaX + deltaY * deltaY)^0.5)
		distance = 100-distance
		if (distance > 0 and CheckSetR == 0) then
			AAP.Banners.BannersFrame.FrameFS2:SetText(distance.."y")
			CheckSetR = 1
		else
			AAP.Banners.BannersFrame.B3:SetText("")
			AAP.Banners.Range.P1.B3.X = nil
			AAP.Banners.Range.P1.B3.Y = nil
		end
		BannnerOnlinechk = 1
	else
		AAP.Banners.BannersFrame.B3:SetText("")
	end
	if (CheckSetR == 0) then
		AAP.Banners.BannersFrame.FrameFS2:SetText("")
	end
	if (BannnerOnlinechk == 0) then
		AAP_BannerUpdRangeTimer:Stop()
	end
end
function AAP_BannerCountDown()
	if (IsInInstance() ~= false) then
		return
	end
------------ P1 --------------
	if (AAP.Banners.Range.P1.B1.T) then
		AAP.Banners.Range.P1.B1.T = AAP.Banners.Range.P1.B1.T - 10
		if (AAP.Banners.Range.P1.B1.T < 1) then
			AAP.Banners.Range.P1.B1 = nil
			AAP.Banners.Range.P1.B1 = {}
		end
	end
	if (AAP.Banners.Range.P1.B2.T) then
		AAP.Banners.Range.P1.B2.T = AAP.Banners.Range.P1.B2.T - 10
		if (AAP.Banners.Range.P1.B2.T < 1) then
			AAP.Banners.Range.P1.B2 = nil
			AAP.Banners.Range.P1.B2 = {}
		end
	end
	if (AAP.Banners.Range.P1.B3.T) then
		AAP.Banners.Range.P1.B3.T = AAP.Banners.Range.P1.B3.T - 10
		if (AAP.Banners.Range.P1.B3.T < 1) then
			AAP.Banners.Range.P1.B3 = nil
			AAP.Banners.Range.P1.B3 = {}
		end
	end
------------ P2 --------------
	if (AAP.Banners.Range.P2.B1.T) then
		AAP.Banners.Range.P2.B1.T = AAP.Banners.Range.P2.B1.T - 10
		if (AAP.Banners.Range.P2.B1.T < 1) then
			AAP.Banners.Range.P2.B1 = nil
			AAP.Banners.Range.P2.B1 = {}
		end
	end
	if (AAP.Banners.Range.P2.B2.T) then
		AAP.Banners.Range.P2.B2.T = AAP.Banners.Range.P2.B2.T - 10
		if (AAP.Banners.Range.P2.B2.T < 1) then
			AAP.Banners.Range.P2.B2 = nil
			AAP.Banners.Range.P2.B2 = {}
		end
	end
	if (AAP.Banners.Range.P2.B3.T) then
		AAP.Banners.Range.P2.B3.T = AAP.Banners.Range.P2.B3.T - 10
		if (AAP.Banners.Range.P2.B3.T < 1) then
			AAP.Banners.Range.P2.B3 = nil
			AAP.Banners.Range.P2.B3 = {}
		end
	end
------------ P3 --------------
	if (AAP.Banners.Range.P3.B1.T) then
		AAP.Banners.Range.P3.B1.T = AAP.Banners.Range.P3.B1.T - 10
		if (AAP.Banners.Range.P3.B1.T < 1) then
			AAP.Banners.Range.P3.B1 = nil
			AAP.Banners.Range.P3.B1 = {}
		end
	end
	if (AAP.Banners.Range.P3.B2.T) then
		AAP.Banners.Range.P3.B2.T = AAP.Banners.Range.P3.B2.T - 10
		if (AAP.Banners.Range.P3.B2.T < 1) then
			AAP.Banners.Range.P3.B2 = nil
			AAP.Banners.Range.P3.B2 = {}
		end
	end
	if (AAP.Banners.Range.P3.B3.T) then
		AAP.Banners.Range.P3.B3.T = AAP.Banners.Range.P3.B3.T - 10
		if (AAP.Banners.Range.P3.B3.T < 1) then
			AAP.Banners.Range.P3.B3 = nil
			AAP.Banners.Range.P3.B3 = {}
		end
	end
------------ P4 --------------
	if (AAP.Banners.Range.P4.B1.T) then
		AAP.Banners.Range.P4.B1.T = AAP.Banners.Range.P4.B1.T - 10
		if (AAP.Banners.Range.P4.B1.T < 1) then
			AAP.Banners.Range.P4.B1 = nil
			AAP.Banners.Range.P4.B1 = {}
		end
	end
	if (AAP.Banners.Range.P4.B2.T) then
		AAP.Banners.Range.P4.B2.T = AAP.Banners.Range.P4.B2.T - 10
		if (AAP.Banners.Range.P4.B2.T < 1) then
			AAP.Banners.Range.P4.B2 = nil
			AAP.Banners.Range.P4.B2 = {}
		end
	end
	if (AAP.Banners.Range.P4.B3.T) then
		AAP.Banners.Range.P4.B3.T = AAP.Banners.Range.P4.B3.T - 10
		if (AAP.Banners.Range.P4.B3.T < 1) then
			AAP.Banners.Range.P4.B3 = nil
			AAP.Banners.Range.P4.B3 = {}
		end
	end
------------ P5 --------------
	if (AAP.Banners.Range.P5.B1.T) then
		AAP.Banners.Range.P5.B1.T = AAP.Banners.Range.P5.B1.T - 10
		if (AAP.Banners.Range.P5.B1.T < 1) then
			AAP.Banners.Range.P5.B1 = nil
			AAP.Banners.Range.P5.B1 = {}
		end
	end
	if (AAP.Banners.Range.P5.B2.T) then
		AAP.Banners.Range.P5.B2.T = AAP.Banners.Range.P5.B2.T - 10
		if (AAP.Banners.Range.P5.B2.T < 1) then
			AAP.Banners.Range.P5.B2 = nil
			AAP.Banners.Range.P5.B2 = {}
		end
	end
	if (AAP.Banners.Range.P5.B3.T) then
		AAP.Banners.Range.P5.B3.T = AAP.Banners.Range.P5.B3.T - 10
		if (AAP.Banners.Range.P5.B3.T < 1) then
			AAP.Banners.Range.P5.B3 = nil
			AAP.Banners.Range.P5.B3 = {}
		end
	end
end
function AAP_BannerSetCD()
		local AAPTB1, AAPTB2, AAPTB3
		if (aapfactionz == "Alliance") then
			local startTime1, duration1, enable1 = GetItemCooldown(64399)
			local startTime2, duration2, enable2 = GetItemCooldown(64398)
			local startTime3, duration3, enable3 = GetItemCooldown(63359)
			if (startTime1 > 0 and duration1 > 0) then
				AAPTB1 = (startTime1 + duration1 - GetTime())
			else
				AAPTB1 = 1
			end
			if (startTime2 > 0 and duration2 > 0) then
				AAPTB2 = (startTime2 + duration2 - GetTime())
			else
				AAPTB2 = 1
			end
			if (startTime3 > 0 and duration3 > 0) then
				AAPTB3 = (startTime3 + duration3 - GetTime())
			else
				AAPTB3 = 1
			end
		else
			local startTime1, duration1, enable1 = GetItemCooldown(64402)
			local startTime2, duration2, enable2 = GetItemCooldown(64401)
			local startTime3, duration3, enable3 = GetItemCooldown(64400)
			if (startTime1 > 0 and duration1 > 0) then
				AAPTB1 = (startTime1 + duration1 - GetTime())
			else
				AAPTB1 = 1
			end
			if (startTime2 > 0 and duration2 > 0) then
				AAPTB2 = (startTime2 + duration2 - GetTime())
			else
				AAPTB2 = 1
			end
			if (startTime3 > 0 and duration3 > 0) then
				AAPTB3 = (startTime3 + duration3 - GetTime())
			else
				AAPTB3 = 1
			end
		end
			if (AAPTB1 > 1 or AAPTB2 > 1 or AAPTB3 > 1) then
				AAP.Banners.BannersFrame.B1CD:SetCooldown(GetTime(), AAPTB1)
				AAP.Banners.BannersFrame.B2CD:SetCooldown(GetTime(), AAPTB2)
				AAP.Banners.BannersFrame.B3CD:SetCooldown(GetTime(), AAPTB3)
				if (not InCombatLockdown()) then
					AAP.Banners.BannersFrame:Show()
				end
			end
end
AAP.Banners.BannersEvents = CreateFrame("Frame")
AAP.Banners.BannersEvents:RegisterEvent ("ADDON_LOADED")
AAP.Banners.BannersEvents:RegisterEvent ("UNIT_SPELLCAST_SUCCEEDED")
AAP.Banners.BannersEvents:RegisterEvent ("CHAT_MSG_ADDON")

AAP.Banners.BannersEvents:SetScript("OnEvent", function(self, event, ...)
	if (event=="ADDON_LOADED" and AAP_DisableAddon == 0) then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		if (arg1 == "AAP-Core") then
			AAP_RegisterChatBanner = C_ChatInfo.RegisterAddonMessagePrefix("AAPChatBanner")
			if (not AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"]) then
				AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"] = GetScreenWidth() / 1.6
			end
			if (not AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"]) then
				AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"] = -(GetScreenHeight() / 5)
			end
			AAP.Banners.BannersFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT",AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannersleft"],AAP1[AAP.Realm][AAP.Name]["Settings"]["Bannerstop"])
			AAP_BannerSetCD()
			AAP_BannerCountDTimer = AAP.Banners.BannersEvents:CreateAnimationGroup()
			AAP_BannerCountDTimer.anim = AAP_BannerCountDTimer:CreateAnimation()
			AAP_BannerCountDTimer.anim:SetDuration(10)
			AAP_BannerCountDTimer:SetLooping("REPEAT")
			AAP_BannerCountDTimer:SetScript("OnLoop", function(self, event, ...)
				AAP_BannerCountDown()
			end)
			AAP_BannerCountDTimer:Play()
			AAP_BannerUpdRangeTimer = AAP.Banners.BannersEvents:CreateAnimationGroup()
			AAP_BannerUpdRangeTimer.anim = AAP_BannerUpdRangeTimer:CreateAnimation()
			AAP_BannerUpdRangeTimer.anim:SetDuration(0.1)
			AAP_BannerUpdRangeTimer:SetLooping("REPEAT")
			AAP_BannerUpdRangeTimer:SetScript("OnLoop", function(self, event, ...)
				AAP_BannerRange()
			end)
			AAP_BannerUpdRangeTimer:Play()
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["BannerShow"] == 1) then
				if (not InCombatLockdown()) then
					AAP.Banners.BannersFrame.Frame:Show()
				end
			else
				if (not InCombatLockdown()) then
					AAP.Banners.BannersFrame.Frame:Hide()
				end
			end
		end
	end
	if (event=="CHAT_MSG_ADDON" and AAP_DisableAddon == 0 and AAP1[AAP.Realm][AAP.Name]["Settings"]["BannerShow"] == 1 and IsInInstance() == false) then
		local arg1, arg2, arg3, arg4 = ...;
		if (arg1 == "AAPChatBanner" and AAP.TrimPlayerServer(arg4) ~= AAP.Name) then
			local _, _, DCL_First, DCL_X, DCL_Y = string.find(arg2, "(.*)Z(.*)Z(.*)")
			arg2 = tonumber(DCL_First)
			if (AAP.Banners.Group[arg4]) then
				if (DCL_X and DCL_Y) then
					AAP.Banners.Range["P"..AAP.Banners.Group[arg4]]["X"] = DCL_X
					AAP.Banners.Range["P"..AAP.Banners.Group[arg4]]["Y"] = DCL_Y
				end
				if (AAP.Banners.Group[arg4] == 1) then
					if (tonumber(arg2) == 1) then
						AAP.Banners.Range.P2.B1["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 2) then
						AAP.Banners.Range.P2.B2["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 3) then
						AAP.Banners.Range.P2.B3["Time"] = GetTime() + 600
					end
					AAP.Banners.BannersFrame["B"..(tonumber(arg2)+1).."CD1"]:SetCooldown(GetTime(), 600)


					if (AAP.Banners.Range.P2.B1["Time"]) then
						local tims = AAP.Banners.Range.P2.B1["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B2CD1"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B2CD1"]:SetCooldown(GetTime(), 120)
					end

					if (AAP.Banners.Range.P2.B2["Time"]) then
						local tims = AAP.Banners.Range.P2.B2["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B3CD1"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B3CD1"]:SetCooldown(GetTime(), 120)
					end
					if (AAP.Banners.Range.P2.B3["Time"]) then
						local tims = AAP.Banners.Range.P2.B3["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B4CD1"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B4CD1"]:SetCooldown(GetTime(), 120)
					end

				end
				if (AAP.Banners.Group[arg4] == 2) then
					if (DCL_X and DCL_Y) then
						AAP.Banners.Range["P3"]["X"] = DCL_X
						AAP.Banners.Range["P3"]["Y"] = DCL_Y
					end
					if (tonumber(arg2) == 1) then
						AAP.Banners.Range.P3.B1["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 2) then
						AAP.Banners.Range.P3.B2["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 3) then
						AAP.Banners.Range.P3.B3["Time"] = GetTime() + 600
					end
					AAP.Banners.BannersFrame["B"..(tonumber(arg2)+1).."CD2"]:SetCooldown(GetTime(), 600)


					if (AAP.Banners.Range.P3.B1["Time"]) then
						local tims = AAP.Banners.Range.P3.B1["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B2CD2"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B2CD2"]:SetCooldown(GetTime(), 120)
					end

					if (AAP.Banners.Range.P3.B2["Time"]) then
						local tims = AAP.Banners.Range.P3.B2["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B3CD2"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B3CD2"]:SetCooldown(GetTime(), 120)
					end
					if (AAP.Banners.Range.P3.B3["Time"]) then
						local tims = AAP.Banners.Range.P3.B3["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B4CD2"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B4CD2"]:SetCooldown(GetTime(), 120)
					end

				end
---------------------- P4
				if (AAP.Banners.Group[arg4] == 3) then
					if (DCL_X and DCL_Y) then
						AAP.Banners.Range["P4"]["X"] = DCL_X
						AAP.Banners.Range["P4"]["Y"] = DCL_Y
					end
					if (tonumber(arg2) == 1) then
						AAP.Banners.Range.P4.B1["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 2) then
						AAP.Banners.Range.P4.B2["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 3) then
						AAP.Banners.Range.P4.B3["Time"] = GetTime() + 600
					end
					AAP.Banners.BannersFrame["B"..(tonumber(arg2)+1).."CD3"]:SetCooldown(GetTime(), 600)


					if (AAP.Banners.Range.P4.B1["Time"]) then
						local tims = AAP.Banners.Range.P4.B1["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B2CD3"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B2CD3"]:SetCooldown(GetTime(), 120)
					end

					if (AAP.Banners.Range.P4.B2["Time"]) then
						local tims = AAP.Banners.Range.P4.B2["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B3CD3"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B3CD3"]:SetCooldown(GetTime(), 120)
					end
					if (AAP.Banners.Range.P4.B3["Time"]) then
						local tims = AAP.Banners.Range.P4.B3["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B4CD3"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B4CD3"]:SetCooldown(GetTime(), 120)
					end

				end
---------------------- P5
				if (AAP.Banners.Group[arg4] == 4) then
					if (DCL_X and DCL_Y) then
						AAP.Banners.Range["P5"]["X"] = DCL_X
						AAP.Banners.Range["P5"]["Y"] = DCL_Y
					end
					if (tonumber(arg2) == 1) then
						AAP.Banners.Range.P5.B1["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 2) then
						AAP.Banners.Range.P5.B2["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 3) then
						AAP.Banners.Range.P5.B3["Time"] = GetTime() + 600
					end
					AAP.Banners.BannersFrame["B"..(tonumber(arg2)+1).."CD4"]:SetCooldown(GetTime(), 600)


					if (AAP.Banners.Range.P5.B1["Time"]) then
						local tims = AAP.Banners.Range.P5.B1["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B2CD4"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B2CD4"]:SetCooldown(GetTime(), 120)
					end

					if (AAP.Banners.Range.P5.B2["Time"]) then
						local tims = AAP.Banners.Range.P5.B2["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B3CD4"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B3CD4"]:SetCooldown(GetTime(), 120)
					end
					if (AAP.Banners.Range.P5.B3["Time"]) then
						local tims = AAP.Banners.Range.P5.B3["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B4CD4"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B4CD4"]:SetCooldown(GetTime(), 120)
					end

				end

			else
				AAP.Banners.Group["Nr"] = AAP.Banners.Group["Nr"] + 1
				AAP.Banners.Group[arg4] = AAP.Banners.Group["Nr"]
				AAP.Banners.BannersFrame["FrameFS1"..AAP.Banners.Group["Nr"]]:SetText(strsub(arg4,1,4))
				AAP.Banners.BannersFrame["Frame"..AAP.Banners.Group["Nr"]]:Show()
---------- P2
				if (AAP.Banners.Group[arg4] == 1) then
					if (DCL_X and DCL_Y) then
						AAP.Banners.Range["P2"]["X"] = DCL_X
						AAP.Banners.Range["P2"]["Y"] = DCL_Y
					end
					if (tonumber(arg2) == 1) then
						AAP.Banners.Range.P2.B1["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 2) then
						AAP.Banners.Range.P2.B2["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 3) then
						AAP.Banners.Range.P2.B3["Time"] = GetTime() + 600
					end
					AAP.Banners.BannersFrame["B"..(tonumber(arg2)+1).."CD1"]:SetCooldown(GetTime(), 600)


					if (AAP.Banners.Range.P2.B1["Time"]) then
						local tims = AAP.Banners.Range.P2.B1["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B2CD1"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B2CD1"]:SetCooldown(GetTime(), 120)
					end

					if (AAP.Banners.Range.P2.B2["Time"]) then
						local tims = AAP.Banners.Range.P2.B2["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B3CD1"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B3CD1"]:SetCooldown(GetTime(), 120)
					end
					if (AAP.Banners.Range.P2.B3["Time"]) then
						local tims = AAP.Banners.Range.P2.B3["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B4CD1"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B4CD1"]:SetCooldown(GetTime(), 120)
					end

				end
---------------------- P3
				if (AAP.Banners.Group[arg4] == 2) then
					if (DCL_X and DCL_Y) then
						AAP.Banners.Range["P3"]["X"] = DCL_X
						AAP.Banners.Range["P3"]["Y"] = DCL_Y
					end
					if (tonumber(arg2) == 1) then
						AAP.Banners.Range.P3.B1["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 2) then
						AAP.Banners.Range.P3.B2["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 3) then
						AAP.Banners.Range.P3.B3["Time"] = GetTime() + 600
					end
					AAP.Banners.BannersFrame["B"..(tonumber(arg2)+1).."CD2"]:SetCooldown(GetTime(), 600)


					if (AAP.Banners.Range.P3.B1["Time"]) then
						local tims = AAP.Banners.Range.P3.B1["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B2CD2"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B2CD2"]:SetCooldown(GetTime(), 120)
					end

					if (AAP.Banners.Range.P3.B2["Time"]) then
						local tims = AAP.Banners.Range.P3.B2["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B3CD2"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B3CD2"]:SetCooldown(GetTime(), 120)
					end
					if (AAP.Banners.Range.P3.B3["Time"]) then
						local tims = AAP.Banners.Range.P3.B3["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B4CD2"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B4CD2"]:SetCooldown(GetTime(), 120)
					end

				end
---------------------- P4
				if (AAP.Banners.Group[arg4] == 3) then
					if (DCL_X and DCL_Y) then
						AAP.Banners.Range["P4"]["X"] = DCL_X
						AAP.Banners.Range["P4"]["Y"] = DCL_Y
					end
					if (tonumber(arg2) == 1) then
						AAP.Banners.Range.P4.B1["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 2) then
						AAP.Banners.Range.P4.B2["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 3) then
						AAP.Banners.Range.P4.B3["Time"] = GetTime() + 600
					end
					AAP.Banners.BannersFrame["B"..(tonumber(arg2)+1).."CD3"]:SetCooldown(GetTime(), 600)


					if (AAP.Banners.Range.P4.B1["Time"]) then
						local tims = AAP.Banners.Range.P4.B1["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B2CD3"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B2CD3"]:SetCooldown(GetTime(), 120)
					end

					if (AAP.Banners.Range.P4.B2["Time"]) then
						local tims = AAP.Banners.Range.P4.B2["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B3CD3"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B3CD3"]:SetCooldown(GetTime(), 120)
					end
					if (AAP.Banners.Range.P4.B3["Time"]) then
						local tims = AAP.Banners.Range.P4.B3["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B4CD3"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B4CD3"]:SetCooldown(GetTime(), 120)
					end

				end
---------------------- P5
				if (AAP.Banners.Group[arg4] == 4) then
					if (DCL_X and DCL_Y) then
						AAP.Banners.Range["P5"]["X"] = DCL_X
						AAP.Banners.Range["P5"]["Y"] = DCL_Y
					end
					if (tonumber(arg2) == 1) then
						AAP.Banners.Range.P5.B1["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 2) then
						AAP.Banners.Range.P5.B2["Time"] = GetTime() + 600
					end
					if (tonumber(arg2) == 3) then
						AAP.Banners.Range.P5.B3["Time"] = GetTime() + 600
					end
					AAP.Banners.BannersFrame["B"..(tonumber(arg2)+1).."CD4"]:SetCooldown(GetTime(), 600)


					if (AAP.Banners.Range.P5.B1["Time"]) then
						local tims = AAP.Banners.Range.P5.B1["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B2CD4"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B2CD4"]:SetCooldown(GetTime(), 120)
					end

					if (AAP.Banners.Range.P5.B2["Time"]) then
						local tims = AAP.Banners.Range.P5.B2["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B3CD4"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B3CD4"]:SetCooldown(GetTime(), 120)
					end
					if (AAP.Banners.Range.P5.B3["Time"]) then
						local tims = AAP.Banners.Range.P5.B3["Time"] - GetTime()
						if (tims < 120) then
							AAP.Banners.BannersFrame["B4CD4"]:SetCooldown(GetTime(), 120)
						end
					else
						AAP.Banners.BannersFrame["B4CD4"]:SetCooldown(GetTime(), 120)
					end

				end
				AAP_BannerUpdRangeTimer:Play()
			end
		end
	end
	if (event=="UNIT_SPELLCAST_SUCCEEDED" and AAP_DisableAddon == 0 and IsInInstance() == false) then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		local AAPTB1, AAPTB2, AAPTB3
		local startTime1, duration1, enable1
		local startTime2, duration2, enable2
		local startTime3, duration3, enable3
		if (aapfactionz == "Alliance") then
			startTime1, duration1, enable1 = GetItemCooldown(64399)
			startTime2, duration2, enable2 = GetItemCooldown(64398)
			startTime3, duration3, enable3 = GetItemCooldown(63359)
			if (startTime1 > 0 and duration1 > 0) then
				AAPTB1 = (startTime1 + duration1 - GetTime())
			else
				AAPTB1 = 0
			end
			if (startTime2 > 0 and duration2 > 0) then
				AAPTB2 = (startTime2 + duration2 - GetTime())
			else
				AAPTB2 = 0
			end
			if (startTime3 > 0 and duration3 > 0) then
				AAPTB3 = (startTime3 + duration3 - GetTime())
			else
				AAPTB3 = 0
			end
		else
			startTime1, duration1, enable1 = GetItemCooldown(64402)
			startTime2, duration2, enable2 = GetItemCooldown(64401)
			startTime3, duration3, enable3 = GetItemCooldown(64400)
			if (startTime1 > 0 and duration1 > 0) then
				AAPTB1 = (startTime1 + duration1 - GetTime())
			else
				AAPTB1 = 0
			end
			if (startTime2 > 0 and duration2 > 0) then
				AAPTB2 = (startTime2 + duration2 - GetTime())
			else
				AAPTB2 = 0
			end
			if (startTime3 > 0 and duration3 > 0) then
				AAPTB3 = (startTime3 + duration3 - GetTime())
			else
				AAPTB3 = 0
			end
		end
		-- 15%
		if (arg1 and arg3 and arg1 == "player" and (tonumber(arg3) == 90633 or tonumber(arg3) == 90628)) then
			local d_y, d_x = UnitPosition("player")
			d_y = (floor(d_y*10)/10)
			d_x = (floor(d_x*10)/10)
			AAP.Banners.BannersFrame.B1CD:SetCooldown(GetTime(), 600)
			if (AAPTB2 == 0 or AAPTB2 < 120) then
				AAP.Banners.BannersFrame.B2CD:SetCooldown(GetTime(), 120)
			end
			if (AAPTB3 == 0 or AAPTB3 < 120) then
				AAP.Banners.BannersFrame.B3CD:SetCooldown(GetTime(), 120)
			end
			if (not InCombatLockdown()) then
				AAP.Banners.BannersFrame:Show()
			end
			AAP.Banners.Range.P1.B1.X = d_x
			AAP.Banners.Range.P1.B1.Y = d_y
			AAP.Banners.Range.P1.B1.T = 600
			C_ChatInfo.SendAddonMessage("AAPChatBanner", "1Z"..d_x.."Z"..d_y, "PARTY")
		end
		-- 10%
		if (arg1 and arg3 and arg1 == "player" and (tonumber(arg3) == 90632 or tonumber(arg3) == 90626)) then
			local d_y, d_x = UnitPosition("player")
			d_y = (floor(d_y*10)/10)
			d_x = (floor(d_x*10)/10)
			if (AAPTB1 == 0 or AAPTB1 < 120) then
				AAP.Banners.BannersFrame.B1CD:SetCooldown(GetTime(), 120)
			end
			AAP.Banners.BannersFrame.B2CD:SetCooldown(GetTime(), 600)
			if (AAPTB3 == 0 or AAPTB3 < 120) then
				AAP.Banners.BannersFrame.B3CD:SetCooldown(GetTime(), 120)
			end
			if (not InCombatLockdown()) then
				AAP.Banners.BannersFrame:Show()
			end
			AAP.Banners.Range.P1.B2.X = d_x
			AAP.Banners.Range.P1.B2.Y = d_y
			AAP.Banners.Range.P1.B2.T = 600
			C_ChatInfo.SendAddonMessage("AAPChatBanner", "2Z"..d_x.."Z"..d_y, "PARTY")
		end
		-- 5%
		if (arg1 and arg3 and arg1 == "player" and (tonumber(arg3) == 90631 or tonumber(arg3) == 89479)) then
			local d_y, d_x = UnitPosition("player")
			d_y = (floor(d_y*10)/10)
			d_x = (floor(d_x*10)/10)
			if (AAPTB1 == 0 or AAPTB1 < 120) then
				AAP.Banners.BannersFrame.B1CD:SetCooldown(GetTime(), 120)
			end
			if (AAPTB2 == 0 or AAPTB2 < 120) then
				AAP.Banners.BannersFrame.B2CD:SetCooldown(GetTime(), 120)
			end
			AAP.Banners.BannersFrame.B3CD:SetCooldown(GetTime(), 600)
			if (not InCombatLockdown()) then
				AAP.Banners.BannersFrame:Show()
			end
			AAP.Banners.Range.P1.B3.X = d_x
			AAP.Banners.Range.P1.B3.Y = d_y
			AAP.Banners.Range.P1.B3.T = 600
			C_ChatInfo.SendAddonMessage("AAPChatBanner", "3Z"..d_x.."Z"..d_y, "PARTY")
		end
		AAP_BannerUpdRangeTimer:Play()
	end
end)