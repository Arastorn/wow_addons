local SLE, T, E, L, V, P, G = unpack(select(2, ...))
if T.select(2, GetAddOnInfo('ElvUI_KnightFrame')) and IsAddOnLoaded('ElvUI_KnightFrame') then return end --Don't break korean code :D
local Armory = SLE:GetModule("Armory_Core")
local CA = SLE:NewModule("Armory_Character", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
local LCG = LibStub('LibCustomGlow-1.0')
local M = E:GetModule("Misc")

local _G = _G
local HasAnyUnselectedPowers = C_AzeriteEmpoweredItem.HasAnyUnselectedPowers

--This is for elements we'll need original points for
local DefaultPosition = {
	InsetDefaultPoint = { _G["CharacterFrameInsetRight"]:GetPoint() },
	CharacterMainHandSlot = { _G["CharacterMainHandSlot"]:GetPoint() }
}
local PANEL_DEFAULT_WIDTH = PANEL_DEFAULT_WIDTH

--Adding new stuffs for armory only
function CA:BuildLayout()

	--<< Background >>--
	if not _G["PaperDollFrame"].SLE_Armory_BG then
		_G["PaperDollFrame"].SLE_Armory_BG = _G["PaperDollFrame"]:CreateTexture(nil, 'OVERLAY')
		_G["PaperDollFrame"].SLE_Armory_BG:Point('TOPLEFT', _G["CharacterModelFrame"], -4, 0)
		_G["PaperDollFrame"].SLE_Armory_BG:Point('BOTTOMRIGHT', _G["CharacterModelFrame"], 4, 0)
	end
	_G["PaperDollFrame"].SLE_Armory_BG:Hide()

	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		Slot.ID = T.GetInventorySlotInfo(SlotName)
		-- print(Slot.ID, SlotName)
		-- Slot:HookScript("OnEnter", function(self)
			-- for i = 1, GameTooltip:NumLines() do
				-- CurrentLineText = _G["GameTooltipTextLeft"..i]:GetText()
				-- print(i, CurrentLineText)
			-- end
		-- end)
		
		--<<Create gems>>--
		for t = 1, Armory.Constants.MaxGemSlots do
			if Slot["textureSlot"..t] then
				Slot["SLE_Gem"..t] = CreateFrame("Frame", nil, Slot)
				Slot["SLE_Gem"..t]:SetPoint("TOPLEFT", Slot["textureSlot"..t])
				Slot["SLE_Gem"..t]:SetPoint("BOTTOMRIGHT", Slot["textureSlot"..t])
				Slot["SLE_Gem"..t]:SetScript("OnEnter", Armory.Gem_OnEnter)
				Slot["SLE_Gem"..t]:SetScript("OnLeave", Armory.Tooltip_OnLeave)
				--Variables for use in some stuff
				Slot["SLE_Gem"..t].frame = "character"
			end
		end

		--<<Gradation>>--
		if Slot.iLvlText then
			Slot.SLE_Gradient = Slot:CreateTexture(nil, "BACKGROUND")
			Slot.SLE_Gradient:SetPoint(Slot.Direction, Slot, Slot.Direction, 0, 0)
			Slot.SLE_Gradient:Size(132, 41)
			Slot.SLE_Gradient:SetTexture(Armory.Constants.GradientTexture)
			Slot.SLE_Gradient:SetVertexColor(T.unpack(E.db.sle.armory.character.gradient.color))
			if Slot.Direction == 'LEFT' then
				Slot.SLE_Gradient:SetTexCoord(0, 1, 0, 1)
			else
				Slot.SLE_Gradient:SetTexCoord(1, 0, 0, 1)
			end
			Slot.iLvlText:SetTextColor(1, 1, 1)
			Slot.SLE_Gradient:Hide()
		end

		--<<Durability>>--
		Slot["SLE_Durability"] = Slot:CreateFontString(nil, "OVERLAY")

		--<<Missing Warning>>--
		Slot["SLE_Warning"] = CreateFrame("Frame", nil, Slot)
		if SlotName == "MainHandSlot" or SlotName == "SecondaryHandSlot" then
			Slot["SLE_Warning"]:Size(41, 8)
			Slot["SLE_Warning"]:SetPoint("TOP", Slot, "BOTTOM", 0, 0)
		else
			Slot["SLE_Warning"]:Size(8, 41)
			Slot["SLE_Warning"]:SetPoint(Slot.Direction == "LEFT" and "RIGHT" or "LEFT", Slot, Slot.Direction, 0, 0)
		end
		Slot["SLE_Warning"].frame = "character"

		Slot["SLE_Warning"].texture = Slot["SLE_Warning"]:CreateTexture(nil, "BACKGROUND")
		Slot["SLE_Warning"].texture:SetInside()
		Slot["SLE_Warning"].texture:SetTexture(Armory.Constants.WarningTexture)
		Slot["SLE_Warning"].texture:SetVertexColor(1, 0, 0)
		
		Slot["SLE_Warning"]:SetScript("OnEnter", Armory.Warning_OnEnter)
		Slot["SLE_Warning"]:SetScript("OnLeave", Armory.Tooltip_OnLeave)
		Slot["SLE_Warning"]:Hide()

		--<<Azerite>>--
		hooksecurefunc(_G["Character"..SlotName], "SetAzeriteItem", function(self, itemLocation)
			if not itemLocation then
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
				return
			end
			-- self.AzeriteTexture:Hide()
			if E.db.sle.armory.character.enable then self.AvailableTraitFrame:Hide() end
			local isAzeriteEmpoweredItem = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLocation);
			if isAzeriteEmpoweredItem then
			else
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
			end
		end)

		hooksecurefunc(_G["Character"..SlotName], "DisplayAsAzeriteEmpoweredItem", function(self, itemLocation)
			if E.db.sle.armory.character.enable and HasAnyUnselectedPowers(itemLocation) then
				LCG.PixelGlow_Start(self, Armory.Constants.AzeriteTraitAvailableColor, nil,-0.25,nil, 3, nil,nil,nil, "_AzeriteTraitGlow")
			else
				LCG.PixelGlow_Stop(self, "_AzeriteTraitGlow")
			end
		end)

		--<<Transmog>>--
		if Armory.Constants.CanTransmogrify[SlotName] then
			Slot.TransmogInfo = CreateFrame('Button', SlotName.."_SLE_TransmogInfo", Slot)
			Slot.TransmogInfo:Size(12)
			Slot.TransmogInfo:SetFrameLevel(Slot:GetFrameLevel() + 2)
			Slot.TransmogInfo:Point('BOTTOM'..Slot.Direction, Slot, Slot.Direction == 'LEFT' and -2 or 2, -1)
			Slot.TransmogInfo:SetScript('OnEnter', Armory.Transmog_OnEnter)
			Slot.TransmogInfo:SetScript('OnLeave', Armory.Transmog_OnLeave)
			Slot.TransmogInfo:SetScript('OnClick', Armory.Transmog_OnClick)

			Slot.TransmogInfo.Texture = Slot.TransmogInfo:CreateTexture(nil, 'OVERLAY')
			Slot.TransmogInfo.Texture:SetInside()
			Slot.TransmogInfo.Texture:SetTexture(Armory.Constants.TransmogTexture)
			Slot.TransmogInfo.Texture:SetVertexColor(1, .5, 1)

			if Slot.Direction == 'LEFT' then
				Slot.TransmogInfo.Texture:SetTexCoord(0, 1, 0, 1)
			else
				Slot.TransmogInfo.Texture:SetTexCoord(1, 0, 0, 1)
			end

			Slot.TransmogInfo:Hide()
		end
	end
	
	--<<<Hooking some shit!>>>--
	hooksecurefunc("CharacterFrame_Collapse", function()
		if E.db.sle.armory.character.enable and _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(448) end
	end)
	hooksecurefunc("CharacterFrame_Expand", function()
		if E.db.sle.armory.character.enable and _G["PaperDollFrame"]:IsShown() then _G["CharacterFrame"]:SetWidth(650) end
	end)
	hooksecurefunc("CharacterFrame_ShowSubFrame", function(frameName)
		if frameName == "PaperDollFrame" or frameName == "PetPaperDollFrame" then return end
		if _G["CharacterFrame"]:GetWidth() > PANEL_DEFAULT_WIDTH + 1 then
			_G["CharacterFrame"]:SetWidth(PANEL_DEFAULT_WIDTH)
		end
	end)

	hooksecurefunc('PaperDollFrame_SetLevel', function()
		if E.db.sle.armory.character.enable then 
			_G["CharacterLevelText"]:SetText(_G["CharacterLevelText"]:GetText())

			_G["CharacterFrameTitleText"]:ClearAllPoints()
			_G["CharacterFrameTitleText"]:Point('TOP',  _G["CharacterModelFrame"], 0, 45)
			_G["CharacterFrameTitleText"]:SetParent(_G["CharacterFrame"])
			_G["CharacterLevelText"]:ClearAllPoints()
			_G["CharacterLevelText"]:SetPoint('TOP', _G["CharacterFrameTitleText"], 'BOTTOM', 0, 2)
			_G["CharacterLevelText"]:SetParent(_G["CharacterFrame"])
		end
	end)
	
	if SLE._Compatibility["DejaCharacterStats"] then return end
	--<<Corruption>>--
	_G["CharacterFrame"].SLE_Corruption = CreateFrame("Frame", "SLE_CharacterCorruptionButton", _G["CharacterFrame"])
	_G["CharacterFrame"].SLE_Corruption.ThrottleRating = false
	_G["CharacterFrame"].SLE_Corruption:SetSize(48, 80)
	_G["CharacterFrame"].SLE_Corruption:SetPoint("RIGHT", _G["CharacterStatsPane"].ItemLevelFrame, "RIGHT", Armory.Constants.Corruption.DefaultX, Armory.Constants.Corruption.DefaultY) --Default for blizz corruption
	_G["CharacterFrame"].SLE_Corruption:SetScript("OnEnter", CharacterFrameCorruption_OnEnter)
	_G["CharacterFrame"].SLE_Corruption:SetScript("OnLeave", CharacterFrameCorruption_OnLeave)
	_G["CharacterFrame"].SLE_Corruption:SetScript("OnEvent", function(self, event, ...)
		CharacterFrameCorruption_OnEvent(self, event)
		if (event == "COMBAT_RATING_UPDATE" and not self.ThrottleRating) or event == "PLAYER_ENTERING_WORLD" then
			CA:UpdateCorruptionLevel()
			self.ThrottleRating = true
			E:Delay(1, function() _G["CharacterFrame"].SLE_Corruption.ThrottleRating = false end)
		end
	end)

	--deal with the events
	_G["CharacterFrame"].SLE_Corruption:RegisterEvent("COMBAT_RATING_UPDATE");
	_G["CharacterFrame"].SLE_Corruption:RegisterEvent("PLAYER_ENTERING_WORLD");
	_G["CharacterFrame"].SLE_Corruption:RegisterEvent("SPELL_TEXT_UPDATE");

	_G["CharacterStatsPane"].ItemLevelFrame.Corruption:UnregisterEvent("COMBAT_RATING_UPDATE");
	_G["CharacterStatsPane"].ItemLevelFrame.Corruption:UnregisterEvent("PLAYER_ENTERING_WORLD");
	_G["CharacterStatsPane"].ItemLevelFrame.Corruption:UnregisterEvent("SPELL_TEXT_UPDATE");
	_G["CharacterStatsPane"].ItemLevelFrame.Corruption:SetScript("OnEvent", nil)
	_G["CharacterStatsPane"].ItemLevelFrame.Corruption:Hide()

	_G["CharacterFrame"].SLE_Corruption.Eye = _G["CharacterFrame"].SLE_Corruption:CreateTexture(nil, "OVERLAY")
	_G["CharacterFrame"].SLE_Corruption.Eye:SetInside()
	_G["CharacterFrame"].SLE_Corruption.Eye:SetAtlas("Nzoth-charactersheet-icon")

	_G["CharacterFrame"].SLE_Corruption.Level = _G["CharacterFrame"].SLE_Corruption:CreateFontString(nil, "OVERLAY")
	_G["CharacterFrame"].SLE_Corruption.Level:SetPoint("CENTER", _G["CharacterFrame"].SLE_Corruption, "CENTER", 1 + E.db.sle.armory.character.corruption.xOffset, 8 + E.db.sle.armory.character.corruption.yOffset)
end

function CA:Calculate_Durability(which, Slot)
	if Slot["SLE_Durability"] then
		if E.db.sle.armory.character.enable and E.db.sle.armory.character.durability.display ~= "Hide" then
			local current, maximum = T.GetInventoryItemDurability(Slot.ID)
			if current and maximum and not (E.db.sle.armory.character.durability.display == 'DamagedOnly' and current == maximum) then
				local r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
				Slot["SLE_Durability"]:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
			else
				Slot["SLE_Durability"]:SetText('')
			end
		else
			Slot["SLE_Durability"]:SetText('')
		end
	end
end

--<<<<<Updating settings>>>>>--
function CA:Update_BG()
	if E.db.sle.armory.character.background.selectedBG == 'HIDE' then
		_G["PaperDollFrame"].SLE_Armory_BG:SetTexture(nil)
	elseif E.db.sle.armory.character.background.selectedBG == 'CUSTOM' then
		_G["PaperDollFrame"].SLE_Armory_BG:SetTexture(E.db.sle.armory.character.background.customTexture)
	elseif E.db.sle.armory.character.background.selectedBG == 'CLASS' then
		_G["PaperDollFrame"].SLE_Armory_BG:SetTexture([[Interface\AddOns\ElvUI_SLE\media\textures\armory\]]..E.myclass)
	else
		_G["PaperDollFrame"].SLE_Armory_BG:SetTexture(SLE.ArmoryConfigBackgroundValues.BlizzardBackdropList[E.db.sle.armory.character.background.selectedBG] or [[Interface\AddOns\ElvUI_SLE\media\textures\armory\]]..E.db.sle.armory.character.background.selectedBG)
	end
end

function CA:Update_ItemLevel()
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		
		if Slot.iLvlText then
			Slot.iLvlText:ClearAllPoints()
			Slot.iLvlText:Point("TOP"..Slot.Direction, Slot, "TOP"..(Slot.Direction == "LEFT" and "RIGHT" or "LEFT"), Slot.Direction == "LEFT" and 2+E.db.sle.armory.character.ilvl.xOffset or -2-E.db.sle.armory.character.ilvl.xOffset, -1+E.db.sle.armory.character.ilvl.yOffset)
		end
	end
end

function CA:Update_Enchant()
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		
		if Slot.enchantText then
			Slot.enchantText:ClearAllPoints()
			Slot.enchantText:Point(Slot.Direction, Slot, Slot.Direction == "LEFT" and "RIGHT" or "LEFT", Slot.Direction == "LEFT" and 2+E.db.sle.armory.character.enchant.xOffset or -2-E.db.sle.armory.character.enchant.xOffset, 1+E.db.sle.armory.character.enchant.yOffset)
		end
	end
end

function CA:Update_Gems()
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		
		if Slot.textureSlot1 then
			Slot.textureSlot1:ClearAllPoints()
			Slot.textureSlot1:Point('BOTTOM'..Slot.Direction, Slot, "BOTTOM"..(Slot.Direction == "LEFT" and "RIGHT" or "LEFT"), Slot.Direction == "LEFT" and 2+E.db.sle.armory.character.gem.xOffset or -2-E.db.sle.armory.character.gem.xOffset, 2+E.db.sle.armory.character.gem.yOffset)
			for i = 1, Armory.Constants.MaxGemSlots do
				Slot["textureSlot"..i]:Size(E.db.sle.armory.character.gem.size)
			end
		end
	end
end

function CA:Update_Durability()
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		if Slot.SLE_Durability then
			Slot.SLE_Durability:FontTemplate(E.LSM:Fetch('font', E.db.sle.armory.character.durability.font), E.db.sle.armory.character.durability.fontSize, E.db.sle.armory.character.durability.fontStyle)
			Slot.SLE_Durability:Point("TOP"..Slot.Direction, _G["Character"..SlotName], "TOP"..Slot.Direction, Slot.Direction == "LEFT" and 2 + E.db.sle.armory.character.durability.xOffset or 0 - E.db.sle.armory.character.durability.xOffset, -3 + E.db.sle.armory.character.durability.yOffset)
		end
	end
	CA.DurabilityFontSet = true
end

function CA:ElvOverlayToggle() --Toggle dat Overlay
	if E.db.sle.armory.character.background.overlay then
		_G["CharacterModelFrameBackgroundOverlay"]:Show()
	else
		_G["CharacterModelFrameBackgroundOverlay"]:Hide()
	end
end

function CA:UpdateCorruptionText()
	if SLE._Compatibility["DejaCharacterStats"] then return end
	local fontIlvl, sizeIlvl, outlineIlvl = E.db.sle.armory.character.corruption.font, E.db.sle.armory.character.corruption.fontSize, E.db.sle.armory.character.corruption.fontStyle
	_G["CharacterFrame"].SLE_Corruption.Level:FontTemplate(E.LSM:Fetch('font', fontIlvl), sizeIlvl, outlineIlvl)
	_G["CharacterFrame"].SLE_Corruption.Level:SetPoint("CENTER", _G["CharacterFrame"].SLE_Corruption, "CENTER", 1 + E.db.sle.armory.character.corruption.xOffset, 8 + E.db.sle.armory.character.corruption.yOffset)
end

function CA:UpdateCorruptionLevel()
	if SLE._Compatibility["DejaCharacterStats"] then return end --Shouldn't be required, just in case
	local corruption = GetCorruption();
	local corruptionResistance = GetCorruptionResistance();
	local totalCorruption = math.max(corruption - corruptionResistance, 0);
	local isColor = E.db.sle.armory.character.corruption.valueColor

	if E.db.sle.armory.character.corruption.style == "TOTAL" then
		local CorColor = isColor and (totalCorruption > 0 and "ff0000" or "00ff00") or "ffffff"
		_G["CharacterFrame"].SLE_Corruption.Level:SetText("|cff"..CorColor..totalCorruption.."|r")
	elseif E.db.sle.armory.character.corruption.style == "COR-RES" then
		_G["CharacterFrame"].SLE_Corruption.Level:SetText("|cff"..(isColor and "ff0000" or "ffffff")..corruption.."|r / |cff"..(isColor and "00ff00" or "ffffff")..corruptionResistance.."|r")
	elseif E.db.sle.armory.character.corruption.style == "Hide" then
		_G["CharacterFrame"].SLE_Corruption.Level:SetText("")
	end
end

function CA:Enable()
	-- Setting frame
	_G["CharacterFrame"]:SetHeight(444)

	-- Move right equipment slots
	_G["CharacterHandsSlot"]:SetPoint('TOPRIGHT', _G["CharacterFrameInsetRight"], 'TOPLEFT', -4, -2)

	-- Move bottom equipment slots
	_G["CharacterMainHandSlot"]:SetPoint('BOTTOMLEFT', _G["PaperDollItemsFrame"], 'BOTTOMLEFT', 185, 14)

	--Making model frame big enough
	_G["CharacterModelFrame"]:ClearAllPoints()
	_G["CharacterModelFrame"]:SetPoint('TOPLEFT', _G["CharacterHeadSlot"], 0, 5)
	_G["CharacterModelFrame"]:SetPoint('RIGHT', _G["CharacterHandsSlot"])
	_G["CharacterModelFrame"]:SetPoint('BOTTOM', _G["CharacterMainHandSlot"])

	if _G["PaperDollFrame"]:IsShown() then --Setting up width for the main frame
		_G["CharacterFrame"]:SetWidth(_G["CharacterFrame"].Expanded and 650 or 444)
		_G["CharacterFrameInsetRight"]:SetPoint('TOPLEFT', _G["CharacterFrameInset"], 'TOPRIGHT', 110, 0)
	end
	
	--This will hide default background stuff. I could make it being shown, but not feeling like figuring out how to stretch the damn texture.
	if _G["CharacterModelFrame"] and _G["CharacterModelFrame"].BackgroundTopLeft and _G["CharacterModelFrame"].BackgroundTopLeft:IsShown() then
		_G["CharacterModelFrame"].BackgroundTopLeft:Hide()
		_G["CharacterModelFrame"].BackgroundTopRight:Hide()
		_G["CharacterModelFrame"].BackgroundBotLeft:Hide()
		_G["CharacterModelFrame"].BackgroundBotRight:Hide()
		if _G["CharacterModelFrame"].backdrop then
			_G["CharacterModelFrame"].backdrop:Hide()
		end
	end

	--Overlay resize to match new width
	_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('TOPLEFT', _G["CharacterModelFrame"], -4, 0)
	_G["CharacterModelFrameBackgroundOverlay"]:SetPoint('BOTTOMRIGHT', _G["CharacterModelFrame"], 4, 0)
	
	--Activating background
	_G["PaperDollFrame"].SLE_Armory_BG:Show()
	CA:Update_BG()
	CA:Update_ItemLevel()
	CA:Update_Enchant()
	CA:Update_Gems()
	CA:Update_Durability()

	if E.db.general.itemLevel.displayCharacterInfo then M:UpdatePageInfo(_G["CharacterFrame"], "Character") end
end

function CA:Disable()
	-- Setting frame to default
	_G["CharacterFrame"]:SetHeight(424)
	_G["CharacterFrame"]:SetWidth(_G["PaperDollFrame"]:IsShown() and _G["CharacterFrame"].Expanded and CHARACTERFRAME_EXPANDED_WIDTH or PANEL_DEFAULT_WIDTH)
	_G["CharacterFrameInsetRight"]:SetPoint(T.unpack(DefaultPosition.InsetDefaultPoint))

	-- Move rightside equipment slots to default position
	_G["CharacterHandsSlot"]:SetPoint('TOPRIGHT', _G["CharacterFrameInset"], 'TOPRIGHT', -4, -2)
	
	-- Move bottom equipment slots to default position
	_G["CharacterMainHandSlot"]:SetPoint('BOTTOMLEFT', _G["PaperDollItemsFrame"], 'BOTTOMLEFT', 130, 16)

	-- Model Frame
	_G["CharacterModelFrame"]:ClearAllPoints()
	_G["CharacterModelFrame"]:Size(231, 320)
	_G["CharacterModelFrame"]:SetPoint('TOPLEFT', _G["PaperDollFrame"], 'TOPLEFT', 52, -66)
	_G["CharacterModelFrame"].BackgroundTopLeft:Show()
	_G["CharacterModelFrame"].BackgroundTopRight:Show()
	_G["CharacterModelFrame"].BackgroundBotLeft:Show()
	_G["CharacterModelFrame"].BackgroundBotRight:Show()
	_G["CharacterModelFrame"].backdrop:Show()

	CA:Update_Durability() --Required for elements update
	for i, SlotName in T.pairs(Armory.Constants.GearList) do
		local Slot = _G["Character"..SlotName]
		if Armory.Constants.Character_Defaults[SlotName] then
			for element, points in T.pairs(Armory.Constants.Character_Defaults[SlotName]) do
				Slot[element]:ClearAllPoints()
				Slot[element]:Point(T.unpack(points))
			end
		end
		if Slot.textureSlot1 then
			for i = 1, Armory.Constants.MaxGemSlots do Slot["textureSlot"..i]:Size(14) end
		end
		if Slot.SLE_Warning then Slot.SLE_Warning:Hide() end
		if Slot.SLE_Durability then Slot["SLE_Durability"]:SetText('') end
	end
	
	if _G["PaperDollFrame"].SLE_Armory_BG then _G["PaperDollFrame"].SLE_Armory_BG:Hide() end
end

function CA:ToggleArmory()
	if E.db.sle.armory.character.enable then
		CA:Enable()
	else
		CA:Disable()
	end
	CA:UpdateCorruptionText()
	Armory:HandleCorruption()

	for i, SlotName in T.pairs(Armory.Constants.AzeriteSlot) do PaperDollItemSlotButton_Update(_G["Character"..SlotName]) end
end

function CA:LoadAndSetup()
	CA:BuildLayout()
	CA:ToggleArmory()
	CA:ElvOverlayToggle()
end
