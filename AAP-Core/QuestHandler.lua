local QNumberLocal = 0
local AAP_ArrowUpdateNr = 0
local ETAStep = 0
local AAP_AntiTaxiLoop = 0
local Updateblock = 0
local HBDP = LibStub("HereBeDragons-Pins-2.0")
local HBD = LibStub("HereBeDragons-2.0")
local AAPWhereToGo
local CurMapShown
local Delaytime = 0
AAP.HBDP = HBDP
AAP.HBD = HBD
local AAP_BonusObj = {
---- WoD Nonus Obj ----
	[36473] = 1,
---- Legion Bonus Obj ----
	[36811] = 1,
	[37466] = 1,
	[37779] = 1,
	[37965] = 1,
	[37963] = 1,
	[37495] = 1,
	[39393] = 1,
	[38842] = 1,
	[43241] = 1,
	[38748] = 1,
	[38716] = 1,
	[39274] = 1,
	[39576] = 1,
	[39317] = 1,
	[39371] = 1,
	[42373] = 1,
	[40316] = 1,
	[38442] = 1,
	[38343] = 1,
	[38939] = 1,
	[39998] = 1,
	[38374] = 1,
	[39119] = 1,
	[9785] = 1,
---- Duskwood ----
	[26623] = 1,
---- Hillsbrad Foothills ----
	[28489] = 1,
--- DH Start Area ----
	[39279] = 1,
	[39742] = 1,
---- BFA Bonus Obj ----
	[50005] = 1,
	[50009] = 1,
	[50080] = 1,
	[50448] = 1,
	[50133] = 1,
	[51534] = 1,
	[50779] = 1,
	[49739] = 1,
	[51689] = 1,
	[50497] = 1,
	[48093] = 1,
	[47996] = 1,
	[48934] = 1,
	[49315] = 1,
	[48852] = 1,
	[49406] = 1,
	[48588] = 1,
	[47756] = 1,
	[49529] = 1,
	[49300] = 1,
	[47797] = 1,
	[49315] = 1,
	[50178] = 1,
	[49918] = 1,
	[47527] = 1,
	[47647] = 1,
	[51900] = 1,
	[50805] = 1,
	[48474] = 1,
	[48525] = 1,
	[45972] = 1,
	[47969] = 1,
	[48181] = 1,
	[48680] = 1,
	[50091] = 1,
}
local MapRects = {};
local TempVec2D = CreateVector2D(0,0);
local function GetPlayerMapPos(MapID, dx, dy)
    local R,P,_ = MapRects[MapID],TempVec2D;
    if not R then
        R = {};
        _, R[1] = C_Map.GetWorldPosFromMapPos(MapID,CreateVector2D(0,0));
        _, R[2] = C_Map.GetWorldPosFromMapPos(MapID,CreateVector2D(1,1));
        R[2]:Subtract(R[1]);
        MapRects[MapID] = R;
    end
	if (dx) then
		P.x, P.y = dx, dy
	else
		P.x, P.y = UnitPosition('Player');
	end
    P:Subtract(R[1]);
    return (1/R[2].y)*P.y, (1/R[2].x)*P.x;
end
function AAP.RemoveIcons()
	for CLi = 1, 20 do
		if (AAP["Icons"][CLi].A == 1) then
			AAP["Icons"][CLi].A = 0
			AAP["Icons"][CLi].P = 0
			AAP["Icons"][CLi].D = 0
			AAP.HBDP:RemoveMinimapIcon("AAP", AAP["Icons"][CLi])
		end
	end
end
function AAP.RemoveMapIcons()
	for CLi = 1, 20 do
		if (AAP["MapIcons"][CLi].A == 1) then
			AAP["MapIcons"][CLi].A = 0
			AAP["MapIcons"][CLi].P = 0
			AAP["MapIcons"][CLi].D = 0
			AAP.HBDP:RemoveWorldMapIcon("AAPMap", AAP["MapIcons"][CLi])
		end
	end
end
function AAP:MoveIcons()
	if (IsInInstance() or AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowBlobs"] == 0) then
		AAP.RemoveIcons()
		return
	end
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	local ix, iy
	if (AAP.SettingsOpen == 1) then
		ix, iy = GetPlayerMapPos(C_Map.GetBestMapForUnit('player'), AAP.ArrowActive_Y, AAP.ArrowActive_X)
	elseif (CurStep and AAP.ActiveMap and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
		local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		if (steps and steps["TT"]) then
			ix, iy = GetPlayerMapPos(C_Map.GetBestMapForUnit('player'), steps["TT"]["y"],steps["TT"]["x"])
		else
			return
		end
	else
		return
	end
	local steps
	if (AAP.SettingsOpen == 1) then
		steps = {}
		steps["TT"] = {}
		steps["TT"]["y"] = AAP.ArrowActive_Y
		steps["TT"]["x"] = AAP.ArrowActive_X
	else
		steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
	end
	if (steps["CRange"]) then
		local CLi
		local totalCR = 1
		if (AAP.QuestStepList[AAP.ActiveMap][CurStep+1] and AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["CRange"]) then
			totalCR = 3
		end
		local px, py = GetPlayerMapPos(C_Map.GetBestMapForUnit('player'))
		local CLi, CLi2
		for CLi = 1, 20 do
			local px2, py2
			px2 = px - ix
			py2 = py - iy
			if (AAP["Icons"][CLi]["A"] == 1 and (AAP["Icons"][CLi]["D"] == 0 or AAP["Icons"][CLi]["D"] == 1)) then
				AAP["Icons"][CLi]["P"] = AAP["Icons"][CLi]["P"] + 0.02
				local test = 0.2
				if (AAP["Icons"][CLi]["P"] > 0.399 and AAP["Icons"][CLi]["P"] < 0.409) then
					local set = 0
					for CLi2 = 1, 20 do
						if (set == 0 and AAP["Icons"][CLi2]["A"] == 0) then
							AAP["Icons"][CLi2]["A"] = 1
							AAP["Icons"][CLi2]["D"] = 1
							set = 1
						end
					end
				end
				if (AAP["Icons"][CLi].P < 1) then
					px2 = px - px2 * AAP["Icons"][CLi]["P"]
					py2 = py - py2 * AAP["Icons"][CLi]["P"]
					AAP["Icons"][CLi]["D"] = 1
					AAP.HBDP:AddMinimapIconMap("AAP", AAP["Icons"][CLi], C_Map.GetBestMapForUnit('player'), px2, py2, true, true)
				else
					AAP["Icons"][CLi]["A"] = 1
					AAP["Icons"][CLi]["P"] = 0
					AAP["Icons"][CLi]["D"] = 2
					AAP.HBDP:RemoveMinimapIcon("AAP", AAP["Icons"][CLi])
				end
			end
		end
		local px, py = GetPlayerMapPos(C_Map.GetBestMapForUnit('player'), AAP.QuestStepList[AAP.ActiveMap][CurStep]["TT"]["y"],AAP.QuestStepList[AAP.ActiveMap][CurStep]["TT"]["x"])
		local CLi, CLi2
		local ix, iy = GetPlayerMapPos(C_Map.GetBestMapForUnit('player'), AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["TT"]["y"],AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["TT"]["x"])
		for CLi = 1, 20 do
			local px2, py2
			px2 = px - ix
			py2 = py - iy
			if (AAP["Icons"][CLi]["A"] == 1 and (AAP["Icons"][CLi]["D"] == 0 or AAP["Icons"][CLi]["D"] == 2)) then
				AAP["Icons"][CLi]["P"] = AAP["Icons"][CLi]["P"] + 0.02
				local test = 0.2

				if (AAP["Icons"][CLi].P < 1) then
					px2 = px - px2 * AAP["Icons"][CLi]["P"]
					py2 = py - py2 * AAP["Icons"][CLi]["P"]
					AAP["Icons"][CLi]["D"] = 2
					AAP.HBDP:AddMinimapIconMap("AAP", AAP["Icons"][CLi], C_Map.GetBestMapForUnit('player'), px2, py2, true, true)
				else
					AAP["Icons"][CLi]["A"] = 0
					AAP["Icons"][CLi]["P"] = 0
					if (totalCR == 3) then
						AAP["Icons"][CLi]["A"] = 1
						AAP["Icons"][CLi]["D"] = 3
					elseif (totalCR == 2) then
						AAP["Icons"][CLi]["D"] = 1
					elseif (totalCR == 1) then
						AAP["Icons"][CLi]["D"] = 1
					end
					AAP.HBDP:RemoveMinimapIcon("AAP", AAP["Icons"][CLi])
				end
			end
		end
		if (totalCR == 3) then
			local px, py = GetPlayerMapPos(C_Map.GetBestMapForUnit('player'), AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["TT"]["y"],AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["TT"]["x"])
			local CLi, CLi2
			local ix, iy = GetPlayerMapPos(C_Map.GetBestMapForUnit('player'), AAP.QuestStepList[AAP.ActiveMap][CurStep+2]["TT"]["y"],AAP.QuestStepList[AAP.ActiveMap][CurStep+2]["TT"]["x"])
			for CLi = 1, 20 do
				local px2, py2
				px2 = px - ix
				py2 = py - iy
				if (AAP["Icons"][CLi]["A"] == 1 and (AAP["Icons"][CLi]["D"] == 0 or AAP["Icons"][CLi]["D"] == 3)) then
					AAP["Icons"][CLi]["P"] = AAP["Icons"][CLi]["P"] + 0.02
					local test = 0.2

					if (AAP["Icons"][CLi].P < 1) then
						px2 = px - px2 * AAP["Icons"][CLi]["P"]
						py2 = py - py2 * AAP["Icons"][CLi]["P"]
						AAP["Icons"][CLi]["D"] = 3
						AAP.HBDP:AddMinimapIconMap("AAP", AAP["Icons"][CLi], C_Map.GetBestMapForUnit('player'), px2, py2, true, true)
					else
						AAP["Icons"][CLi]["A"] = 0
						AAP["Icons"][CLi]["P"] = 0
						AAP["Icons"][CLi]["D"] = 0
						AAP.HBDP:RemoveMinimapIcon("AAP", AAP["Icons"][CLi])
					end
				end
			end
		end
	else
		local px, py = GetPlayerMapPos(C_Map.GetBestMapForUnit('player'))
		local CLi, CLi2
		for CLi = 1, 20 do
			local px2, py2
			px2 = px - ix
			py2 = py - iy
			if (AAP["Icons"][CLi]["A"] == 1) then
				AAP["Icons"][CLi]["P"] = AAP["Icons"][CLi]["P"] + 0.02
				local test = 0.2
				if (AAP["Icons"][CLi]["P"] > 0.39 and AAP["Icons"][CLi]["P"] < 0.41) then
					local set = 0
					for CLi2 = 1, 20 do
						if (set == 0 and AAP["Icons"][CLi2]["A"] == 0) then
							AAP["Icons"][CLi2]["A"] = 1
							set = 1
						end
					end
				end
				if (AAP["Icons"][CLi].P < 1) then
					px2 = px - px2 * AAP["Icons"][CLi]["P"]
					py2 = py - py2 * AAP["Icons"][CLi]["P"]
					AAP.HBDP:AddMinimapIconMap("AAP", AAP["Icons"][CLi], C_Map.GetBestMapForUnit('player'), px2, py2, true, true)
				else
					AAP["Icons"][CLi]["A"] = 0
					AAP["Icons"][CLi]["P"] = 0
					AAP.HBDP:RemoveMinimapIcon("AAP", AAP["Icons"][CLi])
				end
			end
		end
	end
end
local function AAP_MapDelay()
	Delaytime = 0
end
function AAP:MoveMapIcons()
	if (IsInInstance() or AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowMapBlobs"] == 0) then
		return
	end
	if (Delaytime == 1) then
		return
	end
	if (WorldMapFrame:GetMapID() and WorldMapFrame:GetMapID() == 946) then
		return
	end
	if (CurMapShown ~= WorldMapFrame:GetMapID()) then
		CurMapShown = WorldMapFrame:GetMapID()
		Delaytime = 1
		C_Timer.After(0.1, AAP_MapDelay)
		return
	end
	local SetMapIDs = WorldMapFrame:GetMapID()
	if (SetMapIDs == nil) then
		SetMapIDs = C_Map.GetBestMapForUnit("player")
	end
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	local ix, iy
	if (AAP.SettingsOpen == 1) then
		return
	elseif (CurStep and AAP.ActiveMap and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
		local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		if (steps and steps["TT"]) then
			ix, iy = GetPlayerMapPos(SetMapIDs, steps["TT"]["y"],steps["TT"]["x"])
		else
			return
		end
	else
		return
	end
	local steps
	if (AAP.SettingsOpen == 1) then
		return
	else
		steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
	end
	if (steps["CRange"]) then
		local CLi
		local totalCR = 1
		if (AAP.QuestStepList[AAP.ActiveMap][CurStep+1] and AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["CRange"]) then
			totalCR = 3
		end
		local px, py = GetPlayerMapPos(SetMapIDs)
		local CLi, CLi2
		for CLi = 1, 20 do
			local px2, py2
			px2 = px - ix
			py2 = py - iy
			if (AAP["MapIcons"][CLi]["A"] == 1 and (AAP["MapIcons"][CLi]["D"] == 0 or AAP["MapIcons"][CLi]["D"] == 1)) then
				AAP["MapIcons"][CLi]["P"] = AAP["MapIcons"][CLi]["P"] + 0.02
				local test = 0.2
				if (AAP["MapIcons"][CLi]["P"] > 0.399 and AAP["MapIcons"][CLi]["P"] < 0.409) then
					local set = 0
					for CLi2 = 1, 20 do
						if (set == 0 and AAP["MapIcons"][CLi2]["A"] == 0) then
							AAP["MapIcons"][CLi2]["A"] = 1
							AAP["MapIcons"][CLi2]["D"] = 1
							set = 1
						end
					end
				end
				if (AAP["MapIcons"][CLi].P < 1) then
					px2 = px - px2 * AAP["MapIcons"][CLi]["P"]
					py2 = py - py2 * AAP["MapIcons"][CLi]["P"]
					AAP["MapIcons"][CLi]["D"] = 1
					AAP.HBDP:AddWorldMapIconMap("AAPMap", AAP["MapIcons"][CLi], SetMapIDs, px2, py2, HBD_PINS_WORLDMAP_SHOW_PARENT)
				else
					AAP["MapIcons"][CLi]["A"] = 1
					AAP["MapIcons"][CLi]["P"] = 0
					AAP["MapIcons"][CLi]["D"] = 2
					AAP.HBDP:RemoveWorldMapIcon("AAPMap", AAP["MapIcons"][CLi])
				end
			end
		end
		local px, py = GetPlayerMapPos(SetMapIDs, AAP.QuestStepList[AAP.ActiveMap][CurStep]["TT"]["y"],AAP.QuestStepList[AAP.ActiveMap][CurStep]["TT"]["x"])
		local CLi, CLi2
		local ix, iy = GetPlayerMapPos(SetMapIDs, AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["TT"]["y"],AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["TT"]["x"])
		for CLi = 1, 20 do
			local px2, py2
			px2 = px - ix
			py2 = py - iy
			if (AAP["MapIcons"][CLi]["A"] == 1 and (AAP["MapIcons"][CLi]["D"] == 0 or AAP["MapIcons"][CLi]["D"] == 2)) then
				AAP["MapIcons"][CLi]["P"] = AAP["MapIcons"][CLi]["P"] + 0.02
				local test = 0.2

				if (AAP["MapIcons"][CLi].P < 1) then
					px2 = px - px2 * AAP["MapIcons"][CLi]["P"]
					py2 = py - py2 * AAP["MapIcons"][CLi]["P"]
					AAP["MapIcons"][CLi]["D"] = 2
					AAP.HBDP:AddWorldMapIconMap("AAPMap", AAP["MapIcons"][CLi], SetMapIDs, px2, py2, HBD_PINS_WORLDMAP_SHOW_PARENT)
				else
					AAP["MapIcons"][CLi]["A"] = 0
					AAP["MapIcons"][CLi]["P"] = 0
					if (totalCR == 3) then
						AAP["MapIcons"][CLi]["A"] = 1
						AAP["MapIcons"][CLi]["D"] = 3
					elseif (totalCR == 2) then
						AAP["MapIcons"][CLi]["D"] = 1
					elseif (totalCR == 1) then
						AAP["MapIcons"][CLi]["D"] = 1
					end
					AAP.HBDP:RemoveWorldMapIcon("AAPMap", AAP["MapIcons"][CLi])
				end
			end
		end
		if (totalCR == 3) then
			local px, py = GetPlayerMapPos(SetMapIDs, AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["TT"]["y"],AAP.QuestStepList[AAP.ActiveMap][CurStep+1]["TT"]["x"])
			local CLi, CLi2
			local ix, iy = GetPlayerMapPos(SetMapIDs, AAP.QuestStepList[AAP.ActiveMap][CurStep+2]["TT"]["y"],AAP.QuestStepList[AAP.ActiveMap][CurStep+2]["TT"]["x"])
			for CLi = 1, 20 do
				local px2, py2
				px2 = px - ix
				py2 = py - iy
				if (AAP["MapIcons"][CLi]["A"] == 1 and (AAP["MapIcons"][CLi]["D"] == 0 or AAP["MapIcons"][CLi]["D"] == 3)) then
					AAP["MapIcons"][CLi]["P"] = AAP["MapIcons"][CLi]["P"] + 0.02
					local test = 0.2

					if (AAP["MapIcons"][CLi].P < 1) then
						px2 = px - px2 * AAP["MapIcons"][CLi]["P"]
						py2 = py - py2 * AAP["MapIcons"][CLi]["P"]
						AAP["MapIcons"][CLi]["D"] = 3
						AAP.HBDP:AddWorldMapIconMap("AAPMap", AAP["MapIcons"][CLi], SetMapIDs, px2, py2, HBD_PINS_WORLDMAP_SHOW_PARENT)
					else
						AAP["MapIcons"][CLi]["A"] = 0
						AAP["MapIcons"][CLi]["P"] = 0
						AAP["MapIcons"][CLi]["D"] = 0
						AAP.HBDP:RemoveWorldMapIcon("AAPMap", AAP["MapIcons"][CLi])
					end
				end
			end
		end
	else
		local px, py = GetPlayerMapPos(SetMapIDs)
		local CLi, CLi2
		for CLi = 1, 20 do
			local px2, py2
			px2 = px - ix
			py2 = py - iy
			if (AAP["MapIcons"][CLi]["A"] == 1) then
				AAP["MapIcons"][CLi]["P"] = AAP["MapIcons"][CLi]["P"] + 0.02
				local test = 0.2
				if (AAP["MapIcons"][CLi]["P"] > 0.39 and AAP["MapIcons"][CLi]["P"] < 0.41) then
					local set = 0
					for CLi2 = 1, 20 do
						if (set == 0 and AAP["MapIcons"][CLi2]["A"] == 0) then
							AAP["MapIcons"][CLi2]["A"] = 1
							set = 1
						end
					end
				end
				if (AAP["MapIcons"][CLi].P < 1) then
					px2 = px - px2 * AAP["MapIcons"][CLi]["P"]
					py2 = py - py2 * AAP["MapIcons"][CLi]["P"]
					AAP.HBDP:AddWorldMapIconMap("AAPMap", AAP["MapIcons"][CLi], SetMapIDs, px2, py2, HBD_PINS_WORLDMAP_SHOW_PARENT)
				else
					AAP["MapIcons"][CLi]["A"] = 0
					AAP["MapIcons"][CLi]["P"] = 0
					AAP.HBDP:RemoveWorldMapIcon("AAPMap", AAP["MapIcons"][CLi])
				end
			end
		end
	end
end

AAP.DubbleMacro = {}
AAP.ButtonList = {}
AAP.BreadCrumSkips = {}
AAP.SetButtonVar = nil
AAP.ButtonVisual = nil
local function AAP_SettingsButtons()
	local CLi
	for CLi = 1, 3 do
		local CL_Items, clt2, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(6948)
		AAP.QuestList2["BF"..CLi]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
		AAP.QuestList2["BF"..CLi]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
		AAP.QuestList2["BF"..CLi]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
		AAP.QuestList2["BF"..CLi]["AAP_Button"]:SetText("")
		local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
		local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
		AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
		AAP.QuestList2["BF"..CLi]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((CLi * 38)+CLi))
		AAP.QuestList2["BF"..CLi]:Show()
	end
end
function AAP.ChkBreadcrums(qids)
	if (qids and AAP.Breadcrums and AAP.Breadcrums[qids]) then
		for AAP_index,AAP_value in pairs(AAP.Breadcrums[qids]) do
			if ((AAP.ActiveQuests[AAP_value] or IsQuestFlaggedCompleted(AAP_value) == true) and (not AAP.ActiveQuests[qids])) then
				AAP.BreadCrumSkips[qids] = qids
			end
		end
	end
end
local function AAP_SendGroup()
	if (IsInGroup(LE_PARTY_CATEGORY_HOME) and AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] and (AAP.LastSent ~= AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]) and (IsInInstance() == false)) then
	
		C_ChatInfo.SendAddonMessage("AAPChat", AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap], "PARTY");
		AAP.LastSent = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	end
end
local function AAP_CheckZoneSteps()
	if (AAP.ActiveMap and AAP1 and AAP1[AAP.Realm] and AAP1[AAP.Realm][AAP.Name] and AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and IsInInstance() == false) then
		if (not AAP1[AAP.Realm][AAP.Name]["CountedZoneSteps"]) then
			AAP1[AAP.Realm][AAP.Name]["CountedZoneSteps"] = {}
		end
		if (not AAP1[AAP.Realm][AAP.Name]["CountedZoneSteps"][AAP.ActiveMap]) then
			local count = 0
			for AAP_index,AAP_value in pairs(AAP.QuestStepList[AAP.ActiveMap]) do
				count = count + 1
			end
			AAP1[AAP.Realm][AAP.Name]["CountedZoneSteps"][AAP.ActiveMap] = count
		end
		if (AAP1[AAP.Realm][AAP.Name]["CountedZoneSteps"][AAP.ActiveMap] and AAP1[AAP.Realm][AAP.Name]["CountedZoneSteps"][AAP.ActiveMap] > 1 and AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
			AAP.QuestList.QuestFrames["MyProgressFS"]:SetText(AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap].."/"..AAP1[AAP.Realm][AAP.Name]["CountedZoneSteps"][AAP.ActiveMap])
			local aapwidth = AAP.QuestList.QuestFrames["MyProgressFS"]:GetStringWidth()
			AAP.QuestList.QuestFrames["MyProgress"]:SetWidth(aapwidth+10)
			AAP.QuestList.QuestFrames["MyProgressFS"]:SetWidth(aapwidth+10)
			AAP.QuestList.QuestFrames["MyProgress"]:Show()
		else
			for CLi = 1, 5 do
				AAP.PartyList.PartyFrames[CLi]:Hide()
				AAP.PartyList.PartyFrames2[CLi]:Hide()
			end
			AAP.QuestList.QuestFrames["MyProgress"]:Hide()
		end
	else
		AAP.QuestList.QuestFrames["MyProgress"]:Hide()
	end
end
local function AAP_LeaveQuest(QuestIDs)
	local tempa = 0
	for j=1, GetNumQuestLogEntries() do
		local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(j)
		if (QuestIDs == questID and not isHeader) then
			SelectQuestLogEntry(j)
			SetAbandonQuest()
			tempa = 1
		end
	end
	if (tempa == 1) then
		AbandonQuest()
	end
end
local function AAP_ExitVhicle()
	VehicleExit()
end
local function AAP_TaxiSearchFunc(AAPMrX, AAPMrY)
	AAPMrX = floor(AAPMrX + 0.5)
	AAPMrY = floor(AAPMrY + 0.5)
	local CLi
	for CLi = 1, NumTaxiNodes() do
		if (TaxiNodeGetType(CLi) == "REACHABLE") then
			local aapx,aapy = TaxiNodePosition(CLi)
			aapx = floor((floor(aapx * 1000)/10)+0.5)
			aapy = floor((floor(aapy * 1000)/10)+0.5)
			if (tonumber(AAPMrX) == tonumber(aapx) and tonumber(AAPMrY) == tonumber(aapy)) then
				return CLi
			end
		end
	end

end
local function AAP_UseTaxiFunc()
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	local steps
	if (CurStep and AAP.ActiveMap and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
		steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
	end
	if (steps["ETA"]) then
		AAP.AFK_Timer(steps["ETA"])
	end
	local AllyBoatOrNot = "Flight"
	if (AAP.Faction == "Alliance") then
		local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",UnitGUID("target"))
		if (npc_id and AAP.AllyBoatNpcs[tonumber(npc_id)]) then
			AllyBoatOrNot = "Boat"
		end
	end
	if (GetLocale() == "enUS") then
		local CLi
		for CLi = 1, NumTaxiNodes() do
			local aapx,aapy = TaxiNodePosition(CLi)
			aapx = (floor(aapx * 1000)/10)
			aapy = (floor(aapy * 1000)/10)
			if (TaxiNodeGetType(CLi) == "REACHABLE") then
				if (not AAP.FPs) then
					AAP.FPs = {}
				end
				if (not AAP.FPs[AAP.Faction]) then
					AAP.FPs[AAP.Faction] = {}
				end
				if (not AAP.FPs[AAP.Faction][AAP.getContinent()]) then
					AAP.FPs[AAP.Faction][AAP.getContinent()] = {}
				end
				if (AAP.Faction == "Alliance" and 876 == AAP.getContinent()) then
					if (not AAP.FPs[AAP.Faction][AAP.getContinent()][AllyBoatOrNot]) then
						AAP.FPs[AAP.Faction][AAP.getContinent()][AllyBoatOrNot] = {}
					end
					if (not AAP.FPs[AAP.Faction][AAP.getContinent()][AllyBoatOrNot][TaxiNodeName(CLi)]) then
						AAP.FPs[AAP.Faction][AAP.getContinent()][AllyBoatOrNot][TaxiNodeName(CLi)] = {}
					end
					AAP.FPs[AAP.Faction][AAP.getContinent()][AllyBoatOrNot][TaxiNodeName(CLi)]["x"] = aapx
					AAP.FPs[AAP.Faction][AAP.getContinent()][AllyBoatOrNot][TaxiNodeName(CLi)]["y"] = aapy
				else
					if (not AAP.FPs[AAP.Faction][AAP.getContinent()][TaxiNodeName(CLi)]) then
						AAP.FPs[AAP.Faction][AAP.getContinent()][TaxiNodeName(CLi)] = {}
					end
					AAP.FPs[AAP.Faction][AAP.getContinent()][TaxiNodeName(CLi)]["x"] = aapx
					AAP.FPs[AAP.Faction][AAP.getContinent()][TaxiNodeName(CLi)]["y"] = aapy
				end
			end
		end
	end
	if (AAP.Faction == "Alliance" and 876 == AAP.getContinent()) then
		local TName = steps["Name"]
		local TContonent = AAP.getContinent()
		local TX = AAP.FPs[AAP.Faction][TContonent][AllyBoatOrNot][TName]["x"]
		local TY = AAP.FPs[AAP.Faction][TContonent][AllyBoatOrNot][TName]["y"]
		local Nodetotake = AAP_TaxiSearchFunc(TX, TY)
--	TaxiNodeOnButtonEnter(getglobal("TaxiButton"..Nodetotake))
		TakeTaxiNode(Nodetotake)
		AAP.BookingList["TestTaxiFunc"] = Nodetotake
	else
		local TName = steps["Name"]
		local TContonent = AAP.getContinent()
		local TX = AAP.FPs[AAP.Faction][TContonent][TName]["x"]
		local TY = AAP.FPs[AAP.Faction][TContonent][TName]["y"]
		local Nodetotake = AAP_TaxiSearchFunc(TX, TY)
--	TaxiNodeOnButtonEnter(getglobal("TaxiButton"..Nodetotake))
		TakeTaxiNode(Nodetotake)
		AAP.BookingList["TestTaxiFunc"] = Nodetotake
	end
end
local function AAP_QAskPopWanted()
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	local steps
	if (CurStep and AAP.ActiveMap and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
		steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
	end
	local Qid = steps["QaskPopup"]
	if (IsQuestFlaggedCompleted(Qid) == true) then
		AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
		AAP.BookingList["PrintQStep"] = 1
		AAP.QuestList.SugQuestFrame:Hide()
	elseif (steps["QuestLineSkip"] and AAP1[AAP.Realm][AAP.Name]["QlineSkip"][steps["QuestLineSkip"]] and AAP1[AAP.Realm][AAP.Name]["QlineSkip"][steps["QuestLineSkip"]] == 0) then
		AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
		AAP.BookingList["PrintQStep"] = 1
	else
		local SugGroupNr = steps["Group"]
		AAP.QuestList.SugQuestFrameFS1:SetText(AAP_Locals["Optional"])
		AAP.QuestList.SugQuestFrameFS2:SetText(AAP_Locals["Suggested Players"]..": "..SugGroupNr)
		AAP.QuestList.SugQuestFrame:Show()
	end
end
function AAP.QAskPopWantedAsk(AAP_answer)
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	local steps
	if (CurStep and AAP.ActiveMap and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
		steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
	end
	if (AAP_answer == "yes") then
		AAP1[AAP.Realm][AAP.Name]["WantedQuestList"][steps["QaskPopup"]] = 1
		AAP.QuestList.SugQuestFrame:Hide()
		AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
		AAP.BookingList["PrintQStep"] = 1
	else
		AAP.QuestList.SugQuestFrame:Hide()
		AAP1[AAP.Realm][AAP.Name]["WantedQuestList"][steps["QaskPopup"]] = 0
		AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
		AAP.BookingList["PrintQStep"] = 1
	end
end
local function AAP_PrintQStep()
	if (AAP.InCombat == 1) then
		AAP.BookUpdAfterCombat = 1
	end
	AAP_CheckZoneSteps()
	local CLi
	for CLi = 1, 10 do
		if (AAP.QuestList.QuestFrames[CLi]:IsShown()) then
			AAP.QuestList.QuestFrames[CLi]:Hide()
		end
		if (not InCombatLockdown()) then
			if (AAP.QuestList.QuestFrames["FS"..CLi]["Button"]:IsShown()) then
				AAP.QuestList.QuestFrames["FS"..CLi]["Button"]:Hide()
			end
			if (AAP.QuestList2["BF"..CLi]:IsShown() and AAP.SettingsOpen ~= 1) then
				AAP.QuestList2["BF"..CLi]:Hide()
			end
		end
	end
	if (IsInInstance() and not AAP.ActiveQuests[26320]) then
		AAP.ZoneQuestOrder:Hide()
		return
	elseif (AAP1[AAP.Realm][AAP.Name]["Settings"] and AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQuestListOrder"] and AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQuestListOrder"] == 1) then
		AAP.ZoneQuestOrder:Show()
	end
	local LineNr = 0
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	-- Extra liners here
	local MissingQs = {}
	if (AAP.Level ~= UnitLevel("player")) then
		AAP.BookingList["Heirloomscheck"] = 1
		AAP.BookingList["UpdateMapId"] = 1
		AAP.BookingList["PrintQStep"] = 1
		AAP.Level = UnitLevel("player")
	end
	if (AAP1["Debug"]) then
		print("AAP_PrintQStep() Step:".. CurStep)
	end
	AAP_SendGroup()
	if (AAP.SettingsOpen == 1) then
		if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 0) then
			return
		end
		LineNr = LineNr + 1
		AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Test Quest number 1")
		AAP.QuestList.QuestFrames[LineNr]:Show()
		AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
		local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
		if (aapwidth and aapwidth > 400) then
			AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
		else
			AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
		end
		LineNr = LineNr + 1
		AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Test Quest number 2")
		AAP.QuestList.QuestFrames[LineNr]:Show()
		AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
		local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
		if (aapwidth and aapwidth > 400) then
			AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
		else
			AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
		end
		LineNr = LineNr + 1
		AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Test Quest number 3")
		AAP.QuestList.QuestFrames[LineNr]:Show()
		AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
		local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
		if (aapwidth and aapwidth > 400) then
			AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
		else
			AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
		end
		return
	end
	if (AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
		local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		local StepP, IdList
		if (steps and steps["LoaPick"] and steps["LoaPick"] == 123 and ((AAP.ActiveQuests[47440] or IsQuestFlaggedCompleted(47440)) or (AAP.ActiveQuests[47439] or IsQuestFlaggedCompleted(47439)))) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["PrintQStep"] = 1
			return
		elseif (steps["PickedLoa"] and steps["PickedLoa"] == 2 and (AAP.ActiveQuests[47440] or IsQuestFlaggedCompleted(47440))) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["PrintQStep"] = 1
			if (AAP1["Debug"]) then
				print("PickedLoa Skip 2 step:".. CurStep)
			end
			return
		elseif (steps["PickedLoa"] and steps["PickedLoa"] == 1 and (AAP.ActiveQuests[47439] or IsQuestFlaggedCompleted(47439))) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["PrintQStep"] = 1
			if (AAP1["Debug"]) then
				print("PickedLoa Skip 1 step:".. CurStep)
			end
			return
		elseif (steps["PickUp"]) then
			StepP = "PickUp"
		elseif (steps["WarMode"]) then
			StepP = "WarMode"
		elseif (steps["DalaranToOgri"]) then
			StepP = "DalaranToOgri"
		elseif (steps["Qpart"]) then
			StepP = "Qpart"
		elseif (steps["Done"]) then
			StepP = "Done"
		elseif (steps["CRange"]) then
			StepP = "CRange"
		elseif (steps["ZonePick"]) then
			StepP = "ZonePick"
		elseif (steps["QpartPart"]) then
			StepP = "QpartPart"
		elseif (steps["DropQuest"]) then
			StepP = "DropQuest"
		elseif (steps["SetHS"]) then
			StepP = "SetHS"
		elseif (steps["UseHS"]) then
			StepP = "UseHS"
		elseif (steps["GetFP"]) then
			StepP = "GetFP"
		elseif (steps["UseFlightPath"]) then
			StepP = "UseFlightPath"
		elseif (steps["QaskPopup"]) then
			StepP = "QaskPopup"
		elseif (steps["Treasure"]) then
			StepP = "Treasure"
		elseif (steps["UseDalaHS"]) then
			StepP = "UseDalaHS"
		elseif (steps["UseGarrisonHS"]) then
			StepP = "UseGarrisonHS"
		elseif (steps["ZoneDone"]) then
			StepP = "ZoneDone"
		end
		if (steps["BreadCrum"]) then
			AAP.ChkBreadcrums(steps["BreadCrum"])
		end
		if (IsQuestFlaggedCompleted(47440) == true) then
			AAP1[AAP.Realm][AAP.Name]["LoaPick"] = 1
		elseif (IsQuestFlaggedCompleted(47439) == true) then
			AAP1[AAP.Realm][AAP.Name]["LoaPick"] = 2
		end
		if (steps["LeaveQuest"]) then
			AAP_LeaveQuest(steps["LeaveQuest"])
		end
		if (steps["LeaveQuests"]) then
			for AAP_index,AAP_value in pairs(steps["LeaveQuests"]) do
				AAP_LeaveQuest(AAP_value)
			end
		end
		if (AAP1["Debug"]) then
			print(StepP)
		end
		if (steps["SpecialLeaveVehicle"]) then
			C_Timer.After(1, AAP_ExitVhicle)
			C_Timer.After(3, AAP_ExitVhicle)
			C_Timer.After(5, AAP_ExitVhicle)
			C_Timer.After(10, AAP_ExitVhicle)
		end
		if (steps["VehicleExit"]) then
			VehicleExit()
		end
		if (AAP.Heirlooms < 5 and AAP.Level < 110 and AAP1[AAP.Realm][AAP.Name]["Settings"]["DisableHeirloomWarning"] == 0) then
			LineNr = LineNr + 1
			AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** You only got "..AAP.Heirlooms.." xp gaining Heirlooms Equiped!")
			AAP.QuestList.QuestFrames[LineNr]:Show()
			AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
			local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
			if (aapwidth and aapwidth > 400) then
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
			else
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
			end
		end
		if (AAP.Dinged60 == 1) then
			LineNr = LineNr + 1
			AAP.Dinged60nr = LineNr
			AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Time for Northrend! (hearthstone)")
			AAP.QuestList.QuestFrames[LineNr]:Show()
			AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
			local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
			if (aapwidth and aapwidth > 400) then
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
			else
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
			end
		end
		if (AAP.Dinged80 == 1) then
			LineNr = LineNr + 1
			AAP.Dinged80nr = LineNr
			AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Time for Hyjal! (hearthstone)")
			AAP.QuestList.QuestFrames[LineNr]:Show()
			AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
			local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
			if (aapwidth and aapwidth > 400) then
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
			else
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
			end
		end
		if (AAP.Dinged90 == 1) then
			LineNr = LineNr + 1
			AAP.Dinged90nr = LineNr
			AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Time for Draenor! (hearthstone)")
			AAP.QuestList.QuestFrames[LineNr]:Show()
			AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
			local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
			if (aapwidth and aapwidth > 400) then
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
			else
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
			end
		end
		if (AAP.Dinged100 == 1) then
			LineNr = LineNr + 1
			AAP.Dinged100nr = LineNr
			AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Time for Legion! (hearthstone)")
			AAP.QuestList.QuestFrames[LineNr]:Show()
			AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
			local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
			if (aapwidth and aapwidth > 400) then
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
			else
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
			end
		end
		if (AAP.Dinged110 == 1) then
			LineNr = LineNr + 1
			AAP.Dinged100nr = LineNr
			AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Time for BFA! (Dalaran Hearthstone) and go to your Main City")
			AAP.QuestList.QuestFrames[LineNr]:Show()
			AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
			local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
			if (aapwidth and aapwidth > 400) then
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
			else
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
			end
		end
		if (steps["SpecialFlight"] and IsQuestFlaggedCompleted(steps["SpecialFlight"])) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["PrintQStep"] = 1
		end
		if (steps["GroupTask"] and AAP1[AAP.Realm][AAP.Name]["WantedQuestList"][steps["GroupTask"]] and AAP1[AAP.Realm][AAP.Name]["WantedQuestList"][steps["GroupTask"]] == 0) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["PrintQStep"] = 1
			return
		end
		if (steps["ETA"] and not steps["UseFlightPath"]) then
			if (ETAStep ~= CurStep) then
				AAP.AFK_Timer(steps["ETA"])
				ETAStep = CurStep
			end
		end
		if (steps["UseGlider"]) then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
				LineNr = LineNr + 1
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Use Item"]..": "..AAP.GliderFunc())
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
			end
		end
		if (steps["Bloodlust"]) then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
				LineNr = LineNr + 1
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** "..AAP_Locals["Bloodlust"].." **")
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
			end
		end
		if (steps["InVehicle"] and not UnitInVehicle("player")) then
			LineNr = LineNr + 1
			AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Mount a Horse and scare Spiders")
			AAP.QuestList.QuestFrames[LineNr]:Show()
			AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
			local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
			if (aapwidth and aapwidth > 400) then
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
			else
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
			end
		elseif (steps["InVehicle"] and steps["InVehicle"] == 2 and UnitInVehicle("player")) then
			LineNr = LineNr + 1
			AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Scare Spiders into the Lumbermill")
			AAP.QuestList.QuestFrames[LineNr]:Show()
			AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
			local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
			if (aapwidth and aapwidth > 400) then
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
			else
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
			end
		end
		if (steps["ExtraActionB"]) then
			local isFound, macroSlot = AAP.MacroFinder()
			if isFound and macroSlot then
				AAP.MacroUpdater(macroSlot, 123123123)
			end
		end
		if (steps["DalaranToOgri"]) then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
				LineNr = LineNr + 1
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["DalaranToOgri"])
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
			end
		end
		if ((steps["ExtraLine"] or steps["ExtraLineText"]) and AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
			LineNr = LineNr + 1
			local AAPExtralk = steps["ExtraLine"]
			if (steps["ExtraLineText"]) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** "..steps["ExtraLineText"])
			end
			if (AAPExtralk == 1) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** "..AAP_Locals["HeFlying"].." **")
			end
			if (AAPExtralk == 2) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["ClickShrine"])
			end
			if (AAPExtralk == 3) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Talk to NPC to ride boat"])
			end
			if (AAPExtralk == 4) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Takes little dmg at start1"])
			end
			if (AAPExtralk == 5) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Click 1 Dirt Pile"])
			end
			if (AAPExtralk == 6) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Go Up Elevator"])
			end
			if (AAPExtralk == 7) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Jump off Bridge"])
			end
			if (AAPExtralk == 8) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Jump off"])
			end
			if (AAPExtralk == 9) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["ClickAltar"])
			end
			if (AAPExtralk == 10) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["ClickTotem"])
			end
			if (AAPExtralk == 11) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Kajamite"])
			end
			if (AAPExtralk == 12) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Spices"])
			end
			if (AAPExtralk == 13) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["SeaUrchineBrine"])
			end
			if (AAPExtralk == 14) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["JolPoweder"])
			end
			if (AAPExtralk == 15) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["JolStir"])
			end
			if (AAPExtralk == 16) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["JolNotes"])
			end
			if (AAPExtralk == 17) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["JolHandin"])
			end
			if (AAPExtralk == 18) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["TopOfBoat"])
			end
			if (AAPExtralk == 19) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Dontwaitrun"])
			end
			if (AAPExtralk == 20) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Doesntmatterwep"])
			end
			if (AAPExtralk == 21) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Extracaravans"])
			end
			if (AAPExtralk == 22) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["dotsexpire"])
			end
			if (AAPExtralk == 23) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Banneronstuff"])
			end
			if (AAPExtralk == 24) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["GetSaurolistBuff"])
			end
			if (AAPExtralk == 25) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Get Flight Point"])
			end
			if (AAPExtralk == 26) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Fixed Quest"])
			end
			if (AAPExtralk == 27) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Talk to Princess Talanji"])
			end
			if (AAPExtralk == 28) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Zone Complete"])
			end
			if (AAPExtralk == 29) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Missing quest"])
			end
			if (AAPExtralk == 30) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** "..AAP_Locals["waitforportal"].." **")
			end
			if (AAPExtralk == 31) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** "..AAP_Locals["WaitforsetHS"].." **")
			end
			if (AAPExtralk == 32) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["BeneathHandin"])
			end
			if (AAPExtralk == 33) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** "..AAP_Locals["Totemdmg"].." **")
			end
			if (AAPExtralk == 34) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** "..AAP_Locals["WarModeOff"].." **")
			end
			if (AAPExtralk == 35) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** "..AAP_Locals["LoaInfo1"])
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
			end
			if (AAPExtralk == 35) then
				LineNr = LineNr + 1
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** "..AAP_Locals["LoaInfo2"])
			end
			if (AAPExtralk == 36) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Dontglide"])
			end
			if (AAPExtralk == 37) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Use Orb on a Canyon Ettin, then save Oslow")
			end
			if (AAPExtralk == 38) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Get Key in cave")
			end
			if (AAPExtralk == 39) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Talk to FlightMaster")
			end
			if (AAPExtralk == 40) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Talk to War-Mage Erallier to teleport")
			end
			if (AAPExtralk == 41) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Leveling Starts in Redridge Mountains")
			end
			if (AAPExtralk == 42) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("NPC is ontop of the tower")
			end
			if (AAPExtralk == 43) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("*** Open the Cannary's Cache Bag to continue!")
			end
			if (AAPExtralk == 44) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("*** disguise yourself as a plant close by the murlocs")
			end
			if (AAPExtralk == 45) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("*** Use Pheromones Close by Mosshide Representative")
			end
			if (AAPExtralk == 46) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Command Board")
			end
			if (AAPExtralk == 47) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Portal To Undercity on top of the tower")
			end
			if (AAPExtralk == 48) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Don't skip video")
			end
			if (AAPExtralk == 49) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Dalaran Crater Portal")
			end
			if (AAPExtralk == 50) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Portal Back")
			end
			if (AAPExtralk == 51) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Portal")
			end
			if (AAPExtralk == 52) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Zepelin to Stranglethorn Vale")
			end
			if (AAPExtralk == 53) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Learn Journeyman Riding and then type /aap skip or click skip waypoint")
			end
			if (AAPExtralk == 54) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Loot: Pamela's Doll's Head, Left and Right Side and combine them.")
			end
			if (AAPExtralk == 55) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Use Disguise.")
			end
			if (AAPExtralk == 56) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Place Lightwells around the corpsebeasts")
			end
			if (AAPExtralk == 57) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Take Portal to Stranglethorn Vale")
			end
			if (AAPExtralk == 58) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Get Cozzle's Key")
			end
			if (AAPExtralk == 59) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Portal to Orgrimmar")
			end
			if (AAPExtralk == 60) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Train Flying")
			end
			if (AAPExtralk == 61) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Go to Borean Tundra on Zepelin")
			end
			if (AAPExtralk == 62) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Handin is on roof")
			end
			if (AAPExtralk == 63) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Beryl Hounds drops Cores to release Kaskala")
			end
			if (AAPExtralk == 64) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Beryl Reclaimers drop bombs")
			end
			if (AAPExtralk == 65) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Beryl Mage Hunters drops the key for the Arcane Prison")
			end
			if (AAPExtralk == 66) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Hand in far up, on a flying rock")
			end
			if (AAPExtralk == 67) then
				local CL_Items, itemLink, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(35586)
				if (itemLink and GetItemCount(itemLink)) then
					AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Kill Coldarra Wyrmkin and loot 5 Frozen Axes (".. GetItemCount(itemLink) .."/5)")
					if (GetItemCount(itemLink) > 4) then
						AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
						AAP.BookingList["UpdateQuest"] = 1
						AAP.BookingList["PrintQStep"] = 1
					end
				else
					AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Kill Coldarra Wyrmkin and loot 5 Frozen Axes (0/5)")
				end
			end
			if (AAPExtralk == 68) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Use item on a dead Mechagnome to capture")
			end
			if (AAPExtralk == 69) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("*** Click Valve")
			end
			if (AAPExtralk == 70) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Loot Dead Mage Hunters for the plans")
			end
			if (AAPExtralk == 71) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Use Unholy gem on Duke Vallenhal below 35%hp")
			end
			if (AAPExtralk == 72) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Talk to Rokhan to make Sarathstra land")
			end
			if (AAPExtralk == 73) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Woodlands Walkers drop bark for Lothalor Ancients")
			end
			if (AAPExtralk == 74) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Lieutenant Ta'zinni drops Ley Line Focus")
			end
			if (AAPExtralk == 75) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Talk to Budd")
			end
			if (AAPExtralk == 76) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Use Budds stun on a troll and then cage it")
			end
			if (AAPExtralk == 77) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Use Dull Carving Knife (by the tree stump), then talk to him")
			end
			if (AAPExtralk == 78) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Buy a Crystal Vial from Ameenah")
			end
			if (AAPExtralk == 79) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Loot a mummy")
			end
			if (AAPExtralk == 80) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Kill Trolls for 5 Frozen Mojo")
			end
			if (AAPExtralk == 81) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Kill Warlord Zim 'bo for his Mojo")
			end
			if (AAPExtralk == 82) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Kill Trolls for 5 Desperate Mojo")
			end
			if (AAPExtralk == 83) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Drakuru mobs drop Lock Openers")
			end
			if (AAPExtralk == 84) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Talk to Thrallmar Mage to go to Dark Portal")
			end
			if (AAPExtralk == 85) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Portal to Hyjal")
			end
			if (AAPExtralk == 86) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Loot Juniper Berries and use them on Faerie Dragons")
			end
			if (AAPExtralk == 87) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Kill Explosive Hatreds to disable shield")
			end
			if (AAPExtralk == 88) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use boat to go to Northrend")
			end
			if (AAPExtralk == 89) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Loot bombs")
			end
			if (AAPExtralk == 90) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Dismiss pets and pick up a miner (don't mount), and run and deliver miner")
			end
			if (AAPExtralk == 91) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Portal to Blasted Lands")
			end
			if (AAPExtralk == 92) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Talk to Flamebringer")
			end
			if (AAPExtralk == 93) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Take Portal to Hellfire Peninsula")
			end
			if (AAPExtralk == 94) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Start Questing in Zangarmarsh")
			end
			if (AAPExtralk == 95) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Portal to Hyjal")
			end
			if (AAPExtralk == 96) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Talk to Dread-Rider Cullen")
			end
			if (AAPExtralk == 97) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Talk to Recruiter Lee to skip to Dalaran")
			end
			if (AAPExtralk == 98) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Talk to Ensign Ward")
			end
			if (AAPExtralk == 99) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** talk to Bilgewater Rocket-jockey")
			end
			if (AAPExtralk == 100) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Loot Cages and deliver back to Subject Nine (Don't mount)")
			end
			if (AAPExtralk == 101) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Pull Handle and Follow Core (put out fires on Labgoblin)")
			end
			if (AAPExtralk == 102) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Go to Azshara")
			end
			if (AAPExtralk == 103) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Go to Tirisfal Glades")
			end
			if (AAPExtralk == 104) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Go to Silverpine Forest")
			end
			if (AAPExtralk == 105) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Dodge Mines")
			end
			if (AAPExtralk == 106) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Talk to Assistant Greely to get shrinked")
			end
			if (AAPExtralk == 107) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Mount a Rocketway Rat")
			end
			if (AAPExtralk == 108) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Talk to Friz for a free flight")
			end
			if (AAPExtralk == 109) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use rocket to fly to Shattered Strand")
			end
			if (AAPExtralk == 110) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Military Gyrocopter to return to Bilgewater Harbor")
			end
			if (AAPExtralk == 111) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Kill a troll then use the quest item to collect")
			end
			if (AAPExtralk == 112) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Disguise and Buy Bitter Plasma")
			end
			if (AAPExtralk == 113) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Loot the big Sack")
			end
			if (AAPExtralk == 114) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** both are on 2nd shelf, on the right side")
			end
			if (AAPExtralk == 115) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Bottom shelf, left side")
			end
			if (AAPExtralk == 116) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Do Class Hall and pick zone and go there")
			end
			if (AAPExtralk == 117) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Use Cart")
			end
			if (AAPExtralk == 118) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Treasure is ontop of the tower")
			end
			if (AAPExtralk == 119) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Treasure is up on the tree")
			end
			if (AAPExtralk == 120) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Killing a Bloodfang Stalker spawns a quest")
			end
			if (AAPExtralk == 121) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("If your mounted Npcs might not spawn.")
			end
			if (AAPExtralk == 122) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Only one can do the quest at a time so you might have to wait for npc to respawn")
			end
			if (AAPExtralk == 123) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Talk to Orkus after RP and then loot Plans")
			end
			if (AAPExtralk == 124) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Use Pet ability (Call to Arms) to Enlist Troops")
			end
			if (AAPExtralk == 125) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Click on the the npc (Zen'Kiki) so he pulls Hawks")
			end
			if (AAPExtralk == 126) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** Upstairs")
			end
			if (AAPExtralk == 127) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Use Insense Burner quest item.")
			end
			if (AAPExtralk == 128) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Exit Dungeon.")
			end
			if (AAPExtralk == 129) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Enter Dungeon.")
			end
			if (AAPExtralk == 130) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Chop down trees to spawn snipers")
			end
			if (AAPExtralk == 131) then
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Talk to Sassy Hardwrench for a ride")
			end
			AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
			AAP.QuestList.QuestFrames[LineNr]:Show()
			local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
			if (aapwidth and aapwidth > 400) then
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
			else
				AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
			end

		end
		if (StepP == "Qpart") then
			IdList = steps["Qpart"]
			local Flagged = 0
			local Total = 0
			for AAP_index,AAP_value in pairs(IdList) do
				for AAP_index2,AAP_value2 in pairs(AAP_value) do
					Total = Total + 1
					local qid = AAP_index.."-"..AAP_index2
					if (IsQuestFlaggedCompleted(AAP_index) or ((UnitLevel("player") == 120) and AAP_BonusObj[AAP_index]) or AAP1[AAP.Realm][AAP.Name]["BonusSkips"][AAP_index] or AAP.BreadCrumSkips[AAP_index]) then
						Flagged = Flagged + 1
					elseif (AAP.ActiveQuests[qid] and AAP.ActiveQuests[qid] == "C") then
						Flagged = Flagged + 1
					elseif (AAP.ActiveQuests[qid]) then
						if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
							LineNr = LineNr + 1
							AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("["..LineNr.."] "..AAP.ActiveQuests[qid])
							AAP.QuestList.QuestFrames[LineNr]:Show()
							AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
							local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
							if (aapwidth and aapwidth > 400) then
								AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
							else
								AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
							end
							if (steps["Button"] and steps["Button"][qid]) then
								if (not AAP.SetButtonVar) then
									AAP.SetButtonVar = {}
								end
								AAP.SetButtonVar[qid] = LineNr
							end
							if (AAP_BonusObj[AAP_index]) then
								AAP.QuestList.QuestFrames[LineNr]["BQid"] = AAP_index
								AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Show()
							else
								AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
							end
						end
					elseif (not AAP.ActiveQuests[AAP_index] and not MissingQs[AAP_index]) then
						if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
							if (AAP_BonusObj[AAP_index]) then
								LineNr = LineNr + 1
								AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Do Bonus Objective: "..AAP_index)
								AAP.QuestList.QuestFrames[LineNr]:Show()
								AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
								local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
								if (aapwidth and aapwidth > 400) then
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
								else
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
								end
								MissingQs[AAP_index] = 1
								if (AAP_BonusObj[AAP_index]) then
									AAP.QuestList.QuestFrames[LineNr]["BQid"] = AAP_index
									AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Show()
								else
									AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
								end
							else
								LineNr = LineNr + 1
								AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Error - Missing Quest: "..AAP_index)
								AAP.QuestList.QuestFrames[LineNr]:Show()
								AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
								local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
								if (aapwidth and aapwidth > 400) then
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
								else
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
								end
								MissingQs[AAP_index] = 1
								if (AAP_BonusObj[AAP_index]) then
									AAP.QuestList.QuestFrames[LineNr]["BQid"] = AAP_index
									AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Show()
								else
									AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
								end
							end
						end
					end
				end
			end
			if (Flagged == Total and Flagged > 0) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
--			elseif (LineNr == 0) then
--				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
--				AAP.BookingList["PrintQStep"] = 1
			end
		elseif (StepP == "PickUp") then
			IdList = steps["PickUp"]
			local NrLeft = 0
			local Flagged = 0
			local Total = 0
			local NrLeft2 = 0
			local Flagged2 = 0
			local Total2 = 0
			for h=1, getn(IdList) do
				local theqid = IdList[h]
				Total = Total + 1
				if (not AAP.ActiveQuests[theqid] and IsQuestFlaggedCompleted(theqid) == false) then
					NrLeft = NrLeft + 1
				end
				if (IsQuestFlaggedCompleted(theqid) or AAP.ActiveQuests[theqid] or AAP.BreadCrumSkips[theqid]) then
					Flagged = Flagged + 1
				end
			end
			if (steps["PickUp2"]) then
				IdList2 = steps["PickUp2"]
				for h=1, getn(IdList2) do
					local theqid = IdList2[h]
					Total2 = Total2 + 1
					if (not AAP.ActiveQuests[theqid]) then
						NrLeft2 = NrLeft2 + 1
					end
					if (IsQuestFlaggedCompleted(theqid) or AAP.ActiveQuests[theqid] or AAP.BreadCrumSkips[theqid]) then
						Flagged2 = Flagged2 + 1
					end
				end
			end
			if (Total == Flagged) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				if (AAP1["Debug"]) then
					print("AAP.PrintQStep:PickUp:Plus:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
				end
				AAP.BookingList["UpdateQuest"] = 1
				AAP.BookingList["PrintQStep"] = 1
			elseif (steps["PickUp2"] and Total2 == Flagged2) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				if (AAP1["Debug"]) then
					print("AAP.PrintQStep:PickUp:Plus2:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
				end
				AAP.BookingList["UpdateQuest"] = 1
				AAP.BookingList["PrintQStep"] = 1
			else
				if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
					LineNr = LineNr + 1
					AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Pick Up Quests"]..": "..NrLeft)
					AAP.QuestList.QuestFrames[LineNr]:Show()
					AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
					local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
					if (aapwidth and aapwidth > 400) then
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
					else
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
					end
				end
			end
		elseif (StepP == "CRange") then
			IdList = steps["CRange"]
			if (IsQuestFlaggedCompleted(IdList) or AAP.BreadCrumSkips[IdList]) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				if (AAP1["Debug"]) then
					print("AAP.PrintQStep:CRange:Plus:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
				end
				AAP.BookingList["UpdateQuest"] = 1
				AAP.BookingList["PrintQStep"] = 1
			else
				if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
					LineNr = LineNr + 1
					AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP.CheckCRangeText())
					AAP.QuestList.QuestFrames[LineNr]:Show()
					AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
					local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
					if (aapwidth and aapwidth > 400) then
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
					else
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
					end
				end
			end
		elseif (StepP == "Treasure") then
			IdList = steps["Treasure"]
			if (IsQuestFlaggedCompleted(IdList)) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				if (AAP1["Debug"]) then
					print("AAP.PrintQStep:Treasure:Plus:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
				end
				AAP.BookingList["UpdateQuest"] = 1
				AAP.BookingList["PrintQStep"] = 1
			else
				if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
					LineNr = LineNr + 1
					AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Get the Treasure")
					AAP.QuestList.QuestFrames[LineNr]:Show()
					AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
					local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
					if (aapwidth and aapwidth > 400) then
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
					else
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
					end
				end
			end
		elseif (StepP == "DropQuest") then
			IdList = steps["DropQuest"]
			if (IsQuestFlaggedCompleted(IdList) or AAP.ActiveQuests[IdList]) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				if (AAP1["Debug"]) then
					print("AAP.PrintQStep:DropQuest:Plus:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
				end
				AAP.BookingList["UpdateQuest"] = 1
				AAP.BookingList["PrintQStep"] = 1
			end
		elseif (StepP == "Done") then
			IdList = steps["Done"]
			local NrLeft = 0
			local Flagged = 0
			local Total = 0
			for h=1, getn(IdList) do
				Total = Total + 1
				local theqid = IdList[h]
				if (AAP.ActiveQuests[theqid]) then
					NrLeft = NrLeft + 1
				end
				if (IsQuestFlaggedCompleted(theqid) or AAP.BreadCrumSkips[theqid]) then
					Flagged = Flagged + 1
				end
				if (steps["Button"] and steps["Button"][tostring(theqid)]) then
					if (not AAP.SetButtonVar) then
						AAP.SetButtonVar = {}
					end
					AAP.SetButtonVar[tostring(theqid)] = LineNr+1
				end
			end
			if (Total == Flagged) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			else
				if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
					LineNr = LineNr + 1
					AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Turn in Quest"]..": "..NrLeft)
					AAP.QuestList.QuestFrames[LineNr]:Show()
					AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
					local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
					if (aapwidth and aapwidth > 400) then
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
					else
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
					end
				end
			end
		elseif (StepP == "WarMode") then
			if (IsQuestFlaggedCompleted(steps["WarMode"]) or C_PvP.IsWarModeDesired() == true) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			else
				if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
					LineNr = LineNr + 1
					AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("*** Turn on WARMODE ***")
					AAP.QuestList.QuestFrames[LineNr]:Show()
					AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
					local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
					if (aapwidth and aapwidth > 400) then
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
					else
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
					end
				end
				if (C_PvP.IsWarModeDesired() == false and C_PvP.CanToggleWarMode("toggle") == true) then
					C_PvP.ToggleWarMode()
					AAP.BookingList["PrintQStep"] = 1
				end
			end
		elseif (StepP == "UseDalaHS") then
			if (IsQuestFlaggedCompleted(steps["UseDalaHS"])) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			else
				if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
					LineNr = LineNr + 1
					if (steps["Button"] and steps["Button"]["12112552-1"]) then
						if (not AAP.SetButtonVar) then
							AAP.SetButtonVar = {}
						end
						AAP.SetButtonVar["12112552-1"] = LineNr
					end
					AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["UseDalaHS"])
					AAP.QuestList.QuestFrames[LineNr]:Show()
					AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
					local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
					if (aapwidth and aapwidth > 400) then
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
					else
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
					end
					AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Show()
				end
			end
		elseif (StepP == "UseGarrisonHS") then
			if (IsQuestFlaggedCompleted(steps["UseGarrisonHS"])) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			else
				if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
					LineNr = LineNr + 1
					AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["UseGarrisonHS"])
					AAP.QuestList.QuestFrames[LineNr]:Show()
					AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
					if (steps["Button"] and steps["Button"][tostring(steps["UseGarrisonHS"])]) then
						if (not AAP.SetButtonVar) then
							AAP.SetButtonVar = {}
						end
						AAP.SetButtonVar[tostring(steps["UseGarrisonHS"])] = LineNr
					end
					local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
					if (aapwidth and aapwidth > 400) then
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
					else
						AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
					end
					AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Show()
				end
			end
		elseif (StepP == "ZonePick") then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
				LineNr = LineNr + 1
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Pick Zone"])
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
			end
		elseif (StepP == "SetHS") then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
				LineNr = LineNr + 1
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Set Hearthstone"])
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
			end
			if (IsQuestFlaggedCompleted(steps["SetHS"])) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			end
		elseif (StepP == "UseHS") then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
				LineNr = LineNr + 1
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Use Hearthstone"])
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
				if (not AAP.SetButtonVar) then
					AAP.SetButtonVar = {}
				end
				AAP.SetButtonVar[steps["UseHS"]] = LineNr
			end
			if (IsQuestFlaggedCompleted(steps["UseHS"])) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			end
		elseif (StepP == "GetFP") then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
				LineNr = LineNr + 1
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Get Flight Point"])
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
			end
			if (IsQuestFlaggedCompleted(steps["GetFP"])) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			end
		elseif (StepP == "UseFlightPath") then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
				LineNr = LineNr + 1
				if (steps["Boat"]) then
					if (steps["Name"]) then
						AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Boat to"]..": "..steps["Name"])
					else
						AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Boat to"])
					end
					
				else
					if (steps["Name"]) then
						AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Fly to"]..": "..steps["Name"])
					else
						AAP.QuestList.QuestFrames["FS"..LineNr]:SetText(AAP_Locals["Fly to"])
					end
				end
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
			end
			if (steps["SkipIfOnTaxi"] and UnitOnTaxi("player")) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			end
			if (IsQuestFlaggedCompleted(steps["UseFlightPath"])) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			end
		elseif (StepP == "QaskPopup") then
			if (IsQuestFlaggedCompleted(steps["QaskPopup"])) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			else
				AAP_QAskPopWanted()
			end
		elseif (StepP == "QpartPart") then
			IdList = steps["QpartPart"]
			local Flagged = 0
			local Total = 0
			for AAP_index,AAP_value in pairs(IdList) do
				for AAP_index2,AAP_value2 in pairs(AAP_value) do
					Total = Total + 1
					if (IsQuestFlaggedCompleted(AAP_index)) then
						Flagged = Flagged + 1
					end
					local qid = AAP_index.."-"..AAP_index2
					if (AAP.ActiveQuests[qid] and AAP.ActiveQuests[qid] == "C") then
						Flagged = Flagged + 1
					elseif (AAP.ActiveQuests[qid]) then
						if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
							LineNr = LineNr + 1
							AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("["..LineNr.."] "..AAP.ActiveQuests[qid])
							AAP.QuestList.QuestFrames[LineNr]:Show()
							AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
							local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
							if (aapwidth and aapwidth > 400) then
								AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
							else
								AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
							end
						end
					elseif (not AAP.ActiveQuests[AAP_index] and not MissingQs[AAP_index]) then
						if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
							if (AAP_BonusObj[AAP_index]) then
								LineNr = LineNr + 1
								AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Do Bonus Objective: "..AAP_index)
								AAP.QuestList.QuestFrames[LineNr]:Show()
								AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
								local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
								if (aapwidth and aapwidth > 400) then
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
								else
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
								end
								MissingQs[AAP_index] = 1
								if (AAP_BonusObj[AAP_index]) then
									AAP.QuestList.QuestFrames[LineNr]["BQid"] = AAP_index
									AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Show()
								else
									AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
								end
							else
								LineNr = LineNr + 1
								AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("Error - Missing Quest: "..AAP_index)
								AAP.QuestList.QuestFrames[LineNr]:Show()
								AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
								local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
								if (aapwidth and aapwidth > 400) then
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
								else
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
								end
							end
						end
						MissingQs[AAP_index] = 1
					end
				end
			end
			if (Flagged == Total) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			elseif (LineNr == 0) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			elseif (steps and steps["TrigText"]) then
				for AAP_index,AAP_value in pairs(steps["QpartPart"]) do
					for AAP_index2,AAP_value2 in pairs(AAP_value) do
						if (AAP.ActiveQuests[AAP_index.."-"..tonumber(AAP_index2)]) then
							if (string.find(AAP.ActiveQuests[AAP_index.."-"..tonumber(AAP_index2)], steps["TrigText"])) then
								AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
								AAP.BookingList["PrintQStep"] = 1
							end
						end
					end
				end
			end
		end
		if (steps["DroppableQuest"] and not IsQuestFlaggedCompleted(steps["DroppableQuest"]["Qid"]) and not AAP.ActiveQuests[steps["DroppableQuest"]["Qid"]]) then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
				LineNr = LineNr + 1
				local MobName = steps["DroppableQuest"]["Text"]
				if (AAP.NPCList[steps["DroppableQuest"]["MobId"]]) then
					MobName = AAP.NPCList[steps["DroppableQuest"]["MobId"]]
				end
				AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("[".. LineNr .."] "..MobName.." drops quest")
				AAP.QuestList.QuestFrames[LineNr]:Show()
				AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
				local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
				if (aapwidth and aapwidth > 400) then
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
				else
					AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
				end
			end
		end
		if (steps["Fillers"] and AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
			IdList = steps["Fillers"]
			for AAP_index,AAP_value in pairs(IdList) do
				for AAP_index2,AAP_value2 in pairs(AAP_value) do
					if (IsQuestFlaggedCompleted(AAP_index) == false and not AAP1[AAP.Realm][AAP.Name]["BonusSkips"][AAP_index]) then
						if ((UnitLevel("player") ~= 120) or (UnitLevel("player") == 120 and not AAP_BonusObj[AAP_index])) then
							local qid = AAP_index.."-"..AAP_index2
							if (AAP.ActiveQuests[qid] and AAP.ActiveQuests[qid] == "C") then
							elseif (AAP.ActiveQuests[qid]) then
								LineNr = LineNr + 1
								AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("["..LineNr.."] "..AAP.ActiveQuests[qid])
								AAP.QuestList.QuestFrames[LineNr]:Show()
								AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
								local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
								if (aapwidth and aapwidth > 400) then
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
								else
									AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
								end
								if (steps["Button"] and steps["Button"][qid]) then
									if (not AAP.SetButtonVar) then
										AAP.SetButtonVar = {}
									end
									AAP.SetButtonVar[qid] = LineNr
								end
								if (AAP_BonusObj[AAP_index]) then
									AAP.QuestList.QuestFrames[LineNr]["BQid"] = AAP_index
									AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Show()
								else
									AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
								end
							end
						end
					end
				end
			end
		end
		if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
			AAP.SetButton()
		end
		if (AAP.QuestListShown ~= LineNr) then
			if (AAP.QuestListShown > LineNr) then
				local FrameHideNr = AAP.QuestListShown - LineNr
				local NewLine = LineNr
				local CLi
				for CLi = 1, FrameHideNr do
					NewLine = NewLine + CLi
					AAP.QuestList.QuestFrames[NewLine]:Hide()
					if (not InCombatLockdown()) then
						AAP.QuestList.QuestFrames["FS"..NewLine]["Button"]:Hide()
						AAP.QuestList2["BF"..NewLine]:Hide()
					end
					if (AAP1["Debug"]) then
						print("Hide:"..NewLine)
					end
				end
			end
		end
		if (StepP == "ZoneDone" or (AAP.ActiveMap == 862 and AAP1[AAP.Realm][AAP.Name]["HordeD"] and AAP1[AAP.Realm][AAP.Name]["HordeD"] == 1)) then
			local CLi
			for CLi = 1, 10 do
				AAP.QuestList.QuestFrames[CLi]:Hide()
				AAP.QuestList.QuestFrames["FS"..CLi]["Button"]:Hide()
				if (not InCombatLockdown()) then
					AAP.QuestList2["BF"..CLi]:Hide()
				end
				if (AAP1["Debug"]) then
					print("Hide:"..CLi)
				end
			end
			AAP.ArrowActive = 0
		end
		AAP.QuestListShown = LineNr
		AAP.BookingList["SetQPTT"] = 1
		if (AAP.ZoneQuestOrder:IsShown() == true) then
			AAP.UpdateZoneQuestOrderList("LoadIn")
		end
	elseif (AAPWhereToGo and AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowQList"] == 1) then
		LineNr = LineNr + 1
		AAP.QuestList.QuestFrames["FS"..LineNr]:SetText("** AAP: GoTo ".. AAPWhereToGo)
		AAP.QuestList.QuestFrames[LineNr]:Show()
		AAP.QuestList.QuestFrames["FS"..LineNr]["Button"]:Hide()
		local aapwidth = AAP.QuestList.QuestFrames["FS"..LineNr]:GetStringWidth()
		if (aapwidth and aapwidth > 400) then
			AAP.QuestList.QuestFrames[LineNr]:SetWidth(aapwidth+10)
		else
			AAP.QuestList.QuestFrames[LineNr]:SetWidth(410)
		end
	end
end
function AAP.TrimPlayerServer(CLPName)
	if (string.find(CLPName, "(.*)-(.*)")) then
		local _, _, CL_First, CL_Rest = string.find(CLPName, "(.*)-(.*)")
		return CL_First
	else
		return CLPName
	end
end
function AAP.SetButton()
	if (AAP.SettingsOpen == 1) then
		local CLi
		for CLi = 1, 3 do
			local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
			local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
			AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
			AAP.QuestList2["BF"..CLi]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((CLi * 38)+CLi))
		end
		return
	end
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	local steps
	if (CurStep and AAP.ActiveMap and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
		steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
	end
	if (steps and steps["Button"] or (AAP.Dinged60 == 1 and AAP.Dinged60nr > 0) or (AAP.Dinged80 == 1 and AAP.Dinged80nr > 0) or (AAP.Dinged90 == 1 and AAP.Dinged90nr > 0) or (AAP.Dinged100 == 1 and AAP.Dinged100nr > 0)) then
		if (not InCombatLockdown()) then
			if (AAP.SetButtonVar) then
				if (AAP1["Debug"]) then
					print("SetButton")
				end
				AAP.ButtonList = nil
				AAP.ButtonList = {}
				local HideVar = {}
				for AAP_index2,AAP_value2 in pairs(AAP.SetButtonVar) do
					for AAP_index,AAP_value in pairs(steps["Button"]) do
						if (AAP1["Debug"]) then
							print(AAP_index)
						end
						if (AAP_index2 == AAP_index or steps["UseHS"] or steps["UseGarrisonHS"]) then
							local CL_Items, itemLink, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(AAP_value)
							if (CL_Items and string.sub(CL_Items, 1, 1) and CL_ItemTex) then
								HideVar[AAP_value2] = AAP_value2
								AAP.ButtonList[AAP_index] = AAP_value2
								AAP.QuestList2["BF"..AAP_value2]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
								AAP.QuestList2["BF"..AAP_value2]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
								AAP.QuestList2["BF"..AAP_value2]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
								AAP.QuestList2["BF"..AAP_value2]["AAP_Button"]:SetText("")
								AAP.QuestList2["BF"..AAP_value2]["AAP_Button"]:SetAttribute("type", "item");
								AAP.QuestList2["BF"..AAP_value2]["AAP_Button"]:SetAttribute("item", "item:"..AAP_value);
								AAP.QuestList2["BF"..AAP_value2]["AAP_Button"]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetItemByID(AAP_value); GameTooltip:Show() end)
								AAP.QuestList2["BF"..AAP_value2]["AAP_Button"]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
								if (GetItemCount(itemLink) and GetItemCount(itemLink) > 0) then
									AAP.QuestList2["BF"..AAP_value2]:Show()
								else
									AAP.QuestList2["BF"..AAP_value2]:Hide()
								end
								local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
								local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
								AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
								AAP.QuestList2["BF"..AAP_value2]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((AAP_value2 * 38)+AAP_value2))
								if (not AAP.ButtonVisual) then
									AAP.ButtonVisual = {}
								end
								local _, Spellidz = GetItemSpell(AAP_value)
								if (Spellidz) then
									AAP.QuestStepList[AAP.ActiveMap][CurStep]["ButtonSpellId"] = { [Spellidz] = AAP_index }
								end
								AAP.ButtonVisual[AAP_value2] = AAP_value2
								local isFound, macroSlot = AAP.MacroFinder()
								if isFound and macroSlot then
									if (steps and steps["SpecialDubbleMacro"]) then
										if (not AAP.DubbleMacro[1]) then
											AAP.DubbleMacro[1] = CL_Items
										elseif (AAP.DubbleMacro and AAP.DubbleMacro[1] and not AAP.DubbleMacro[2]) then
											AAP.DubbleMacro[2] = CL_Items
										end
									else
										AAP.DubbleMacro = nil
										AAP.DubbleMacro = {}
									end
									AAP.MacroUpdater(macroSlot, CL_Items)
								end
							end
						end
					end
				end
				for i=1, 10 do
					if (not HideVar[i] and AAP.SettingsOpen ~= 1) then
						AAP.QuestList2["BF"..i]:Hide()
					end
				end
				if (AAP.Dinged60 == 1 and AAP.Dinged60nr > 0) then
					local CL_Items, clt2, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(6948)
					if (CL_Items and string.sub(CL_Items, 1, 1) and CL_ItemTex) then
						HideVar[AAP.Dinged60nr] = AAP.Dinged60nr
						AAP.ButtonList[123451234] = AAP.Dinged60nr
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetText("")
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetAttribute("type", "item");
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetAttribute("item", "item:6948");
						AAP.QuestList2["BF"..AAP.Dinged60nr]:Show()
							AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetItemByID(6948); GameTooltip:Show() end)
							AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
						local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
						local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
						AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
						AAP.QuestList2["BF"..AAP.Dinged60nr]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((AAP.Dinged60nr * 38)+AAP.Dinged60nr))
						if (not AAP.ButtonVisual) then
							AAP.ButtonVisual = {}
						end
						AAP.ButtonVisual[AAP.Dinged60nr] = AAP.Dinged60nr
						local isFound, macroSlot = AAP.MacroFinder()
						if isFound and macroSlot then
							if (steps and steps["SpecialDubbleMacro"]) then
								if (not AAP.DubbleMacro[1]) then
									AAP.DubbleMacro[1] = CL_Items
								elseif (AAP.DubbleMacro and AAP.DubbleMacro[1] and not AAP.DubbleMacro[2]) then
									AAP.DubbleMacro[2] = CL_Items
								end
							else
								AAP.DubbleMacro = nil
								AAP.DubbleMacro = {}
							end
							AAP.MacroUpdater(macroSlot, CL_Items)
						end
					end
				end
				if (AAP.Dinged80 == 1 and AAP.Dinged80nr > 0) then
					local CL_Items, clt2, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(6948)
					if (CL_Items and string.sub(CL_Items, 1, 1) and CL_ItemTex) then
						HideVar[AAP.Dinged80nr] = AAP.Dinged80nr
						AAP.ButtonList[123451234] = AAP.Dinged80nr
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetText("")
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetAttribute("type", "item");
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetAttribute("item", "item:6948");
						AAP.QuestList2["BF"..AAP.Dinged80nr]:Show()
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetItemByID(6948); GameTooltip:Show() end)
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
						local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
						local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
						AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
						AAP.QuestList2["BF"..AAP.Dinged80nr]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((AAP.Dinged80nr * 38)+AAP.Dinged80nr))
						if (not AAP.ButtonVisual) then
							AAP.ButtonVisual = {}
						end
						AAP.ButtonVisual[AAP.Dinged80nr] = AAP.Dinged80nr
						local isFound, macroSlot = AAP.MacroFinder()
						if isFound and macroSlot then
							if (steps and steps["SpecialDubbleMacro"]) then
								if (not AAP.DubbleMacro[1]) then
									AAP.DubbleMacro[1] = CL_Items
								elseif (AAP.DubbleMacro and AAP.DubbleMacro[1] and not AAP.DubbleMacro[2]) then
									AAP.DubbleMacro[2] = CL_Items
								end
							else
								AAP.DubbleMacro = nil
								AAP.DubbleMacro = {}
							end
							AAP.MacroUpdater(macroSlot, CL_Items)
						end
					end
				end
				if (AAP.Dinged90 == 1 and AAP.Dinged90nr > 0) then
					local CL_Items, clt2, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(6948)
					if (CL_Items and string.sub(CL_Items, 1, 1) and CL_ItemTex) then
						HideVar[AAP.Dinged90nr] = AAP.Dinged90nr
						AAP.ButtonList[123451234] = AAP.Dinged90nr
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetText("")
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetAttribute("type", "item");
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetAttribute("item", "item:6948");
						AAP.QuestList2["BF"..AAP.Dinged90nr]:Show()
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetItemByID(6948); GameTooltip:Show() end)
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
						local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
						local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
						AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
						AAP.QuestList2["BF"..AAP.Dinged90nr]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((AAP.Dinged90nr * 38)+AAP.Dinged90nr))
						if (not AAP.ButtonVisual) then
							AAP.ButtonVisual = {}
						end
						AAP.ButtonVisual[AAP.Dinged90nr] = AAP.Dinged90nr
						local isFound, macroSlot = AAP.MacroFinder()
						if isFound and macroSlot then
							if (steps and steps["SpecialDubbleMacro"]) then
								if (not AAP.DubbleMacro[1]) then
									AAP.DubbleMacro[1] = CL_Items
								elseif (AAP.DubbleMacro and AAP.DubbleMacro[1] and not AAP.DubbleMacro[2]) then
									AAP.DubbleMacro[2] = CL_Items
								end
							else
								AAP.DubbleMacro = nil
								AAP.DubbleMacro = {}
							end
							AAP.MacroUpdater(macroSlot, CL_Items)
						end
					end
				end
				if (AAP.Dinged100 == 1 and AAP.Dinged100nr > 0) then
					local CL_Items, clt2, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(6948)
					if (CL_Items and string.sub(CL_Items, 1, 1) and CL_ItemTex) then
						HideVar[AAP.Dinged100nr] = AAP.Dinged100nr
						AAP.ButtonList[123451234] = AAP.Dinged100nr
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetText("")
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetAttribute("type", "item");
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetAttribute("item", "item:6948");
						AAP.QuestList2["BF"..AAP.Dinged100nr]:Show()
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetItemByID(6948); GameTooltip:Show() end)
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
						local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
						local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
						AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
						AAP.QuestList2["BF"..AAP.Dinged100nr]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((AAP.Dinged100nr * 38)+AAP.Dinged100nr))
						if (not AAP.ButtonVisual) then
							AAP.ButtonVisual = {}
						end
						AAP.ButtonVisual[AAP.Dinged100nr] = AAP.Dinged100nr
						local isFound, macroSlot = AAP.MacroFinder()
						if isFound and macroSlot then
							if (steps and steps["SpecialDubbleMacro"]) then
								if (not AAP.DubbleMacro[1]) then
									AAP.DubbleMacro[1] = CL_Items
								elseif (AAP.DubbleMacro and AAP.DubbleMacro[1] and not AAP.DubbleMacro[2]) then
									AAP.DubbleMacro[2] = CL_Items
								end
							else
								AAP.DubbleMacro = nil
								AAP.DubbleMacro = {}
							end
							AAP.MacroUpdater(macroSlot, CL_Items)
						end
					end
				end
			else
				if (steps and not steps["Button"] and AAP.SettingsOpen ~= 1) then
					for i=1, 10 do
						AAP.QuestList2["BF"..i]:Hide()
					end
				end
				if (AAP.Dinged60 == 1 and AAP.Dinged60nr > 0) then
					local CL_Items, clt2, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(6948)
					if (CL_Items and string.sub(CL_Items, 1, 1) and CL_ItemTex) then
						AAP.ButtonList[123451234] = AAP.Dinged60nr
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetText("")
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetAttribute("type", "item");
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetAttribute("item", "item:6948");
						AAP.QuestList2["BF"..AAP.Dinged60nr]:Show()
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetItemByID(6948); GameTooltip:Show() end)
						AAP.QuestList2["BF"..AAP.Dinged60nr]["AAP_Button"]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
						local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
						local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
						AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
						AAP.QuestList2["BF"..AAP.Dinged60nr]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((AAP.Dinged60nr * 38)+AAP.Dinged60nr))
						if (not AAP.ButtonVisual) then
							AAP.ButtonVisual = {}
						end
						AAP.ButtonVisual[AAP.Dinged60nr] = AAP.Dinged60nr
						local isFound, macroSlot = AAP.MacroFinder()
						if isFound and macroSlot then
							AAP.DubbleMacro = nil
							AAP.DubbleMacro = {}
							AAP.MacroUpdater(macroSlot, CL_Items)
						end
					end
				end
				if (AAP.Dinged80 == 1 and AAP.Dinged80nr > 0) then
					local CL_Items, clt2, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(6948)
					if (CL_Items and string.sub(CL_Items, 1, 1) and CL_ItemTex) then
						AAP.ButtonList[123451234] = AAP.Dinged80nr
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetText("")
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetAttribute("type", "item");
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetAttribute("item", "item:6948");
						AAP.QuestList2["BF"..AAP.Dinged80nr]:Show()
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetItemByID(6948); GameTooltip:Show() end)
						AAP.QuestList2["BF"..AAP.Dinged80nr]["AAP_Button"]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
						local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
						local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
						AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
						AAP.QuestList2["BF"..AAP.Dinged80nr]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((AAP.Dinged80nr * 38)+AAP.Dinged80nr))
						if (not AAP.ButtonVisual) then
							AAP.ButtonVisual = {}
						end
						AAP.ButtonVisual[AAP.Dinged80nr] = AAP.Dinged80nr
						local isFound, macroSlot = AAP.MacroFinder()
						if isFound and macroSlot then
							AAP.DubbleMacro = nil
							AAP.DubbleMacro = {}
							AAP.MacroUpdater(macroSlot, CL_Items)
						end
					end
				end
				if (AAP.Dinged90 == 1 and AAP.Dinged90nr > 0) then
					local CL_Items, clt2, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(6948)
					if (CL_Items and string.sub(CL_Items, 1, 1) and CL_ItemTex) then
						AAP.ButtonList[123451234] = AAP.Dinged90nr
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetText("")
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetAttribute("type", "item");
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetAttribute("item", "item:6948");
						AAP.QuestList2["BF"..AAP.Dinged90nr]:Show()
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetItemByID(6948); GameTooltip:Show() end)
						AAP.QuestList2["BF"..AAP.Dinged90nr]["AAP_Button"]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
						local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
						local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
						AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
						AAP.QuestList2["BF"..AAP.Dinged90nr]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((AAP.Dinged90nr * 38)+AAP.Dinged90nr))
						if (not AAP.ButtonVisual) then
							AAP.ButtonVisual = {}
						end
						AAP.ButtonVisual[AAP.Dinged90nr] = AAP.Dinged90nr
						local isFound, macroSlot = AAP.MacroFinder()
						if isFound and macroSlot then
							AAP.DubbleMacro = nil
							AAP.DubbleMacro = {}
							AAP.MacroUpdater(macroSlot, CL_Items)
						end
					end
				end
				if (AAP.Dinged100 == 1 and AAP.Dinged100nr > 0) then
					local CL_Items, clt2, clt3, clt4, clt5, clt6, clt7, clt8, clt9, CL_ItemTex = GetItemInfo(6948)
					if (CL_Items and string.sub(CL_Items, 1, 1) and CL_ItemTex) then
						AAP.ButtonList[123451234] = AAP.Dinged100nr
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Buttonptex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Buttonntex"]:SetTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetNormalTexture(CL_ItemTex)
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetText("")
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetAttribute("type", "item");
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetAttribute("item", "item:6948");
						AAP.QuestList2["BF"..AAP.Dinged100nr]:Show()
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:SetItemByID(6948); GameTooltip:Show() end)
						AAP.QuestList2["BF"..AAP.Dinged100nr]["AAP_Button"]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
						local Topz = AAP1[AAP.Realm][AAP.Name]["Settings"]["left"]
						local Topz2 = AAP1[AAP.Realm][AAP.Name]["Settings"]["top"]
						AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Topz, Topz2)
						AAP.QuestList2["BF"..AAP.Dinged100nr]:SetPoint("BOTTOMLEFT", AAP.QuestList21, "BOTTOMLEFT",0,-((AAP.Dinged100nr * 38)+AAP.Dinged100nr))
						if (not AAP.ButtonVisual) then
							AAP.ButtonVisual = {}
						end
						AAP.ButtonVisual[AAP.Dinged100nr] = AAP.Dinged100nr
						local isFound, macroSlot = AAP.MacroFinder()
						if isFound and macroSlot then
							AAP.DubbleMacro = nil
							AAP.DubbleMacro = {}
							AAP.MacroUpdater(macroSlot, CL_Items)
						end
					end
				end
			end
			AAP.QuestList20:SetPoint("TOPLEFT", UIParent, "TOPLEFT", AAP1[AAP.Realm][AAP.Name]["Settings"]["left"], AAP1[AAP.Realm][AAP.Name]["Settings"]["top"])
			AAP.SetButtonVar = nil
		end
	elseif (AAP.ButtonVisual and not InCombatLockdown() and AAP.SettingsOpen ~= 1) then
		for AAP_index,AAP_value in pairs(AAP.ButtonVisual) do
			AAP.QuestList2["BF"..AAP_index]:Hide()
		end
		AAP.ButtonVisual = nil
	end
end
function AAP.CheckCRangeText()
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
	local i = 1
	while i  <= 15 do
		CurStep = CurStep + 1
		steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		if (steps and steps["FlightPath"]) then
			local Derp2 = AAP_Locals["Get Flight Point"]
			return Derp2
		elseif (steps and steps["UseFlightPath"]) then
			if (steps["Boat"]) then
				local Derp2 = AAP_Locals["Boat to"]
				return Derp2
			else
				local Derp2 = AAP_Locals["Fly to"]
				return Derp2
			end
		elseif (steps and steps["PickUp"]) then
			local Derp2 = AAP_Locals["Accept Quest"]
			return Derp2
		elseif (steps and steps["Done"]) then
			local Derp2 = AAP_Locals["Turn in Quest"]
			return Derp2
		elseif (steps and steps["Qpart"]) then
			local Derp2 = AAP_Locals["Complete Quest"]
			return Derp2
		elseif (steps and steps["SetHS"]) then
			local Derp2 = AAP_Locals["Set Hearthstone"]
			return Derp2
		elseif (steps and steps["QpartPart"]) then
			local Derp2 = AAP_Locals["Complete Quest"]
			return Derp2
		end

		i = i + 1
	end
	local Derp2 = AAP_Locals["Travel to"]
	return Derp2
end
local function AAP_UpdateQuest()
	local i = 1
	local UpdateQpart = 0
	if (not AAPQuestNames) then
		AAPQuestNames = {}
	end
	while GetQuestLogTitle(i) do
		local questTitle, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(i)
		if (questID > 0) then
			if (not isHeader) then
				AAPQuestNames[questID] = questTitle
				local numObjectives = GetNumQuestLeaderBoards(SelectQuestLogEntry(i))
				if (not AAP.ActiveQuests[questID]) then
					if (AAP1["Debug"]) then
						print("New Q:"..questID)
					end
				end
				if (not isComplete) then
					isComplete = 0
					AAP.ActiveQuests[questID] = "P"
				else
					isComplete = 1
					AAP.ActiveQuests[questID] = "C"
				end
				if (numObjectives == 0) then
					if (isComplete == 1) then
						AAP.ActiveQuests[questID.."-".."1"] = "C"
					else
						AAP.ActiveQuests[questID.."-".."1"] = questTitle
					end
				else
					for h=1, numObjectives do
						local text = 0
						local text, type, finished = GetQuestLogLeaderBoard(h, SelectQuestLogEntry(i))
						if (finished == true) then
							finished = 1
						else
							finished = 0
						end
						if (finished == 1) then
							if (AAP.ActiveQuests[questID.."-"..h] and AAP.ActiveQuests[questID.."-"..h] ~= "C") then
								if (AAP1["Debug"]) then
									print("Update:".."C")
								end
								Update = 1
							end
							AAP.ActiveQuests[questID.."-"..h] = "C"
						elseif ((select(2,GetQuestObjectiveInfo(questID, 1, false)) == "progressbar") and text) then
							local AAP_Mathstuff = tonumber(GetQuestProgressBarPercent(questID))
							AAP_Mathstuff = floor((AAP_Mathstuff + 0.5))
							text = "["..AAP_Mathstuff.."%] " .. text
							if (not AAP.ActiveQuests[questID.."-"..h]) then
								if (AAP1["Debug"]) then
									print("New1:"..text)
								end
							end
							if (AAP.ActiveQuests[questID.."-"..h] and AAP.ActiveQuests[questID.."-"..h] ~= text) then
								if (AAP1["Debug"]) then
									print("Update:"..text)
								end
								Update = 1
								AAP.ActiveQuests[questID.."-"..h] = text
							else
								AAP.ActiveQuests[questID.."-"..h] = text
							end
						else
							if (not AAP.ActiveQuests[questID.."-"..h]) then
								--print("New2:"..text)
							end
							if (AAP.ActiveQuests[questID.."-"..h] and AAP.ActiveQuests[questID.."-"..h] ~= text) then
								if (AAP1["Debug"]) then
									print("Update:"..text)
								end
								Update = 1
								AAP.ActiveQuests[questID.."-"..h] = text
							else
								AAP.ActiveQuests[questID.."-"..h] = text
							end
						end
					end
				end
			end
		end
	i = i + 1
	end
	if (Update == 1) then
		AAP.BookingList["PrintQStep"] = 1
	end
end
function AAP.MacroFinder()
	local found = false
	local global, character = GetNumMacros()
	for i=1, global do
		local name = GetMacroInfo(i)
		if name == "AAP_MACRO" then
			found = true
			return true, i
		end
	end
	if not found then
		return false, nil
	end
end
function AAP.CreateMacro()
	if InCombatLockdown() then
		return
	end
	if (AAP1["Debug"]) then
		print("AAP.CreateMacro()")
	end
	local global, character = GetNumMacros()
	local isFound, macroSlot = AAP.MacroFinder()
	local aap_hasSpace = global < MAX_ACCOUNT_MACROS
	if aap_hasSpace then 
		if not isFound and not InCombatLockdown() then
			CreateMacro("AAP_MACRO","INV_MISC_QUESTIONMARK","/script print('no button yet')",nil,nil)
		end
	else
		print("AAP: No global macro space. Please delete a macro to create space.")
	end
end
function AAP.MacroUpdater(macroSlot,itemName,aapextra)
	if (itemName) then
		if (itemName == 123123123) then
			EditMacro(macroSlot, "AAP_MACRO","INV_MISC_QUESTIONMARK","#showtooltip\n/click ExtraActionButton1",nil,nil)
		elseif (aapextra == 65274) then
			EditMacro(macroSlot, "AAP_MACRO","INV_MISC_QUESTIONMARK","#showtooltip\n/script AAP.SaveOldSlot()\n/use "..itemName,nil,nil)
		else
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			if (AAP.DubbleMacro and AAP.DubbleMacro[1] and AAP.DubbleMacro[2] and steps and steps["SpecialDubbleMacro"]) then
				EditMacro(macroSlot, "AAP_MACRO","INV_MISC_QUESTIONMARK","#showtooltip\n/use "..AAP.DubbleMacro[1].."\n/use "..AAP.DubbleMacro[2],nil,nil)
			elseif (steps and steps["SpecialMacro"]) then
				EditMacro(macroSlot, "AAP_MACRO","INV_MISC_QUESTIONMARK","#showtooltip\n/target Serrik\n/use "..itemName,nil,nil)
			elseif (steps and steps["SpecialMacro2"]) then
				EditMacro(macroSlot, "AAP_MACRO","INV_MISC_QUESTIONMARK","#showtooltip\n/target Hrillik's\n/use "..itemName,nil,nil)
			else
				EditMacro(macroSlot, "AAP_MACRO","INV_MISC_QUESTIONMARK","#showtooltip\n/use "..itemName,nil,nil)
			end
		end
	else
		EditMacro(macroSlot, "AAP_MACRO","INV_MISC_QUESTIONMARK","/script print('no button yet')",nil,nil)
	end
end
function AAP.GliderFunc()
	if (AAP1["GliderName"]) then
		return AAP1["GliderName"]
	else
		local bag, slot, itemLink, itemName, count
		local DerpGot = 0
		for bag = 0,4 do
			for slot = 1,GetContainerNumSlots(bag) do
				local itemID = GetContainerItemID(bag, slot)
				if (itemID and itemID == 109076) then
					DerpGot = 1
					itemLink = GetContainerItemLink(bag,slot)
					itemName = GetItemInfo(itemLink)
					count = GetItemCount(itemLink)
				end
			end
		end
		if (DerpGot == 1) then
			AAP1["GliderName"] = itemName
			return itemName
		else
			return "Goblin Glider Kit"
		end
	end
end
local function AAP_QuestStepIds()
	if (AAP.QuestStepList[AAP.ActiveMap]) then
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		if (CurStep and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
			local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			if (steps["PickUp"]) then
				return steps["PickUp"], "PickUp"
			elseif (steps["Qpart"]) then
				return steps["Qpart"], "Qpart"
			elseif (steps["Done"]) then
				return steps["Done"], "Done"
			else
				return
			end
		else
			return
		end
	else
		return
	end
end
local function AAP_RemoveQuest(questID)
	AAP.ActiveQuests[questID] = nil
	for AAP_index,AAP_value in pairs(AAP.ActiveQuests) do
		if (string.find(AAP_index, "(.*)-(.*)")) then
			local _, _, AAP_First, AAP_Rest = string.find(AAP_index, "(.*)-(.*)")
			if (tonumber(AAP_First) == questID) then
				AAP.ActiveQuests[AAP_index] = nil
			end
		end
	end
	local IdList, StepP = AAP_QuestStepIds()
	if (StepP == "Done") then
		local NrLeft = 0
		for AAP_index,AAP_value in pairs(IdList) do
			if (IsQuestFlaggedCompleted(AAP_value) or questID == AAP_value) then
			else
				NrLeft = NrLeft + 1
			end
		end
		if (NrLeft == 0) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			if (AAP1["Debug"]) then
				print("AAP.RemoveQuest:Plus"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
			end
			AAP.BookingList["UpdateQuest"] = 1
		end
	end
	AAP.BookingList["PrintQStep"] = 1
end
local function AAP_AddQuest(questID)
	AAP.ActiveQuests[questID] = "P"
	local IdList, StepP = AAP_QuestStepIds()
	if (StepP == "PickUp") then
		local NrLeft = 0
		for AAP_index,AAP_value in pairs(IdList) do
			if (not AAPQuestNames[AAP_value]) then
				AAPQuestNames[AAP_value] = 1
			end
			if (not AAP.ActiveQuests[AAP_value]) then
				NrLeft = NrLeft + 1
			end
		end
		if (NrLeft == 0) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			if (AAP1["Debug"]) then
				print("AAP.AddQuest:Plus"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
			end
			AAP.BookingList["UpdateQuest"] = 1
		end
	end
	AAP.BookingList["PrintQStep"] = 1
end
local function AAP_UpdateMapId()
	local OldMap = AAP.ActiveMap
	local levelcheck = 0
	local levelcheck80 = 0
	local levelcheck90 = 0
	local levelcheck100 = 0
	local levelcheck110 = 0
	AAP.Level = UnitLevel("player")
	AAP.ActiveMap = C_Map.GetBestMapForUnit("player")
	local currentMapId, TOP_MOST = C_Map.GetBestMapForUnit('player'), true
	if (Enum and Enum.UIMapType and Enum.UIMapType.Continent and currentMapId) then
		AAP.ActiveMap = MapUtil.GetMapParentInfo(currentMapId, Enum.UIMapType.Continent+1, TOP_MOST)
	end
	if (AAP.ActiveMap and AAP.ActiveMap["mapID"]) then
		AAP.ActiveMap = AAP.ActiveMap["mapID"]
	else
		AAP.ActiveMap = C_Map.GetBestMapForUnit("player")
	end
	if (OldMap and OldMap ~= AAP.ActiveMap) then
		AAP.BookingList["PrintQStep"] = 1
	end
	if (AAP.ActiveMap == nil) then
		AAP.ActiveMap = "NoZone"
	end

	if (AAP.Faction == "Alliance") then
		AAP.ActiveMap = "A"..AAP.ActiveMap
	end
	if (AAP.ActiveMap == 194 and AAP.Gender == 2) then
		AAP.ActiveMap = "194-male"
	end
	if (AAP.ActiveMap == 194 and AAP.Gender == 3) then
		AAP.ActiveMap = "194-female"
	end
	if (AAP.ActiveMap == 23 and AAP.Class[3] == 6 and IsQuestFlaggedCompleted(13189) == false) then
		AAP.ActiveMap = "DK23-H"
	end
	if (AAP.ActiveMap == "A23" and AAP.Class[3] == 6 and IsQuestFlaggedCompleted(13188) == false) then
		AAP.ActiveMap = "DK23-A"
	end

	if (not AAP1[AAP.Realm][AAP.Name]["SavedVer"]) then
		if (AAP1[AAP.Realm][AAP.Name]["A895-110-120-3"]) then
			AAP1[AAP.Realm][AAP.Name]["A895-110-120-3"] = 1
		end
		if (AAP1[AAP.Realm][AAP.Name]["A942-110-120"]) then
			AAP1[AAP.Realm][AAP.Name]["A942-110-120"] = 1
		end
		AAP1[AAP.Realm][AAP.Name]["SavedVer"] = AAP.Version
	end

	local AAPZoneActiveCheck = 0
--------------------------------
---- DH Start Area - Alliance ----
	if (("A630" == AAP.ActiveMap or "A673" == AAP.ActiveMap or "A672" == AAP.ActiveMap) and AAP.Class and AAP.Class[3] and AAP.Class[3] == 12 and IsQuestFlaggedCompleted(39689) == false) then
		AAP.ActiveMap = "A672-DH-Start"
	end
---- DH Start Area - Horde ----
	if ((630 == AAP.ActiveMap or 673 == AAP.ActiveMap or 672 == AAP.ActiveMap) and AAP.Class and AAP.Class[3] and AAP.Class[3] == 12 and IsQuestFlaggedCompleted(39689) == false) then
		AAP.ActiveMap = "A672-DH-Start"
	end
---- Vanilla - Horde -----------
	if (AAP.Faction == "Horde" and AAP.Level == 20) then
		if (AAP.ActiveMap == 85 and AAP.Race == "MagharOrc") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "1-MagharOrc"
		elseif (AAP.ActiveMap == 85 and AAP.Race == "HighmountainTauren") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "1-HighmountainTauren"
		elseif (AAP.ActiveMap == 85 and AAP.Race == "Nightborne") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "1-Nightborne"
		end
	end
	if (AAP.Faction == "Horde" and AAP.Level > 19 and AAP.Level < 60) then
		if (AAP.ActiveMap == 85) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			if (IsQuestFlaggedCompleted(26965) == false) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "1-20-60"
				if (IsQuestFlaggedCompleted(14258)) then
					AAP.ActiveMap = "1-20-60-1"
				end
			end
		end
		if (AAP.ActiveMap == 76) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "76-20-60"
		end
		if (AAP.ActiveMap == 90) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			if (IsQuestFlaggedCompleted(26965) == false and IsQuestFlaggedCompleted(14258)) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "90-20Silverpine"
			end
		end
		if (AAP.ActiveMap == 18) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			if (IsQuestFlaggedCompleted(26965) == false and IsQuestFlaggedCompleted(14258)) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "18-20Silverpine"
			end
			if (IsQuestFlaggedCompleted(28616) and IsQuestFlaggedCompleted(14258) and IsQuestFlaggedCompleted(26979) == false) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "18-20-1"
			end
			if (IsQuestFlaggedCompleted(27530) and IsQuestFlaggedCompleted(26278) == false) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "18-20-1-STV"
			end
		end
	end
	if (AAP.Faction == "Horde" and AAP.Level > 19 and AAP.Level < 63) then
		if (AAP.ActiveMap == 22) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			if (IsQuestFlaggedCompleted(28605) and not (IsQuestFlaggedCompleted(26955) and IsQuestFlaggedCompleted(27367))) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "22-20-63"
			end
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == 23) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			if (AAP.ActiveQuests[26955]) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "23-20-63"
			elseif (IsQuestFlaggedCompleted(26955)) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "23-20-63-1"
			end
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == 217) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "217-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == 21) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			if (IsQuestFlaggedCompleted(14258)) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "21-20-63"
			end
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == 25) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			if (AAP.ActiveQuests[27483]) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "25-20-63"
			end
			if (IsQuestFlaggedCompleted(27483)) then
				AAPZoneActiveCheck = 1
				AAP.ActiveMap = "25-20-63-1"
			end
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == 224) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "224-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
	end
	if (AAPZoneActiveCheck == 0 and IsInInstance() == false and AAP.Faction == "Horde" and AAP.Level > 19 and AAP.Level < 60) then
		if (IsQuestFlaggedCompleted(14258) == false) then
			AAPWhereToGo = "Azshara"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(27290) == true and IsQuestFlaggedCompleted(27438) == false) then
			AAPWhereToGo = "Ruins of Gilneas"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(27548) == false) then
			AAPWhereToGo = "Silverpine Forest"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(28616) == false) then
			AAPWhereToGo = "Hillsbrad Foothills"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(26955) == false) then
			AAPWhereToGo = "Western Plaguelands"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(27527) == false) then
			AAPWhereToGo = "Eastern Plaguelands"
			AAP.BookingList["PrintQStep"] = 1
		else
			AAPWhereToGo = nil
		end
	elseif (AAPZoneActiveCheck == 1) then
		AAPWhereToGo = nil
	end
--------------------------------
---- Vanilla - Alliance --------
	if (AAP.Faction == "Alliance" and AAP.Level == 20) then
		if (AAP.ActiveMap == "A830" and AAP.Race == "LightforgedDraenei") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A830-20"
		end
	end
	if (AAP.Faction == "Alliance" and AAP.Level > 19 and AAP.Level < 60) then
		if (AAP.ActiveMap == "A84" and (IsQuestFlaggedCompleted(26504) == false) and (IsQuestFlaggedCompleted(26726) == false)) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A84-LF-20"
		end
		if (AAP.ActiveMap == "A37" and (IsQuestFlaggedCompleted(26504) == false) and (IsQuestFlaggedCompleted(26726) == false)) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A37-20"
		end
	end
	if (AAP.Faction == "Alliance" and AAP.Level > 19 and AAP.Level < 63) then
		if (AAP.ActiveMap == "A49") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A49-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == "A47") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A47-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == "A224") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A224-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == "A22") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A22-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == "A23") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A23-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == "A48") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A48-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == "A56") then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A56-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
		if (AAP.ActiveMap == "A14" and (AAP.ActiveQuests[26139] or IsQuestFlaggedCompleted(26139) == true)) then
			if (IsAddOnLoaded("AAP-Vanilla") == false) then
				local loaded, reason = LoadAddOn("AAP-Vanilla")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Vanilla is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A14-20-63"
			if (AAP.Level >	59) then
				levelcheck = 1
			end
		end
	end
	if (AAPZoneActiveCheck == 0 and IsInInstance() == false and AAP.Faction == "Alliance" and AAP.Level > 19 and AAP.Level < 60) then
		if (IsQuestFlaggedCompleted(26504) == false) then
			AAPWhereToGo = "Stormwind"
		elseif (IsQuestFlaggedCompleted(26726) == false) then
			AAPWhereToGo = "Redridge Mountains"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(26727) == false) then
			AAPWhereToGo = "Duskwood"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(28749) == false) then
			AAPWhereToGo = "Northern Stranglethorn"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(26955) == false) then
			AAPWhereToGo = "Western Plaguelands"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(26137) == false) then
			AAPWhereToGo = "Loch Modan"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(26139) == false) then
			AAPWhereToGo = "Wetlands"
			AAP.BookingList["PrintQStep"] = 1
		else
			AAPWhereToGo = nil
		end
	elseif (AAPZoneActiveCheck == 1) then
		AAPWhereToGo = nil
	end
--------------------------------
---- TBC - WotLK - Horde -------
	if (AAP.Faction == "Horde" and AAP.Level > 59 and AAP.Level < 80) then
		if (AAP.ActiveMap == 85 and IsQuestFlaggedCompleted(11585) == false) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "1-60to80"
		end
		if (AAP.ActiveMap == 85 and IsQuestFlaggedCompleted(12792)) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "1-60to80-2"
		end
		if (AAP.ActiveMap == 18) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "18-60-80"
		end
		if (AAP.ActiveMap == 17) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "17-60-80"
		end
		
	end
	if (AAP.Faction == "Horde" and AAP.Level > 59 and AAP.Level < 83) then
		if (AAP.ActiveMap == 114) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "114-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == 127) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "127-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == 115) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "115-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == 116) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "116-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == 121) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "121-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == 100) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "100-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == 102) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "102-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == 108) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "108-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == 107) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "107-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
	end
	if (AAPZoneActiveCheck == 0 and IsInInstance() == false and AAP.Faction == "Horde" and AAP.Level > 59 and AAP.Level < 80) then
		if (IsQuestFlaggedCompleted(11585) == false) then
			AAPWhereToGo = "Orgrimmar"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(12859) == true and IsQuestFlaggedCompleted(9785) == false) then
			AAPWhereToGo = "Orgrimmar"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(11907) == false) then
			AAPWhereToGo = "Borean Tundra"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(11991) == false) then
			AAPWhereToGo = "Dragonblight"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(12802) == false) then
			AAPWhereToGo = "Gryzzly Hills"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(12859) == false) then
			AAPWhereToGo = "Zul'Drak"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(10096) == false) then
			AAPWhereToGo = "Zangarmarsh"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(9888) == true and IsQuestFlaggedCompleted(9890) == false) then
			AAPWhereToGo = "Terokkar Forest"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(9852) == false) then
			AAPWhereToGo = "Nagrand"
			AAP.BookingList["PrintQStep"] = 1
		else
			AAPWhereToGo = nil
		end
	elseif (AAPZoneActiveCheck == 1) then
		AAPWhereToGo = nil
	end
--------------------------------
---- TBC - WotLK - Alliance ----
	if (AAP.Faction == "Alliance" and AAP.Level > 59 and AAP.Level < 80) then
		if (AAP.ActiveMap == "A84" and IsQuestFlaggedCompleted(12792)) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A84-Hellfire"
		end
		if (AAP.ActiveMap == "A84" and IsQuestFlaggedCompleted(11672) == false) then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A84-Flight-Northrend"
		end
		if (AAP.ActiveMap == "A17") then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A17-60-80"
		end
	end
	if (AAP.Faction == "Alliance" and AAP.Level > 59 and AAP.Level < 83) then
		if (AAP.ActiveMap == "A114") then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A114-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == "A115") then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A115-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == "A127") then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A127-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == "A116") then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A116-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == "A121") then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A121-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == "A100") then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A100-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
		if (AAP.ActiveMap == "A102") then
			if (IsAddOnLoaded("AAP-TBC-WotLK") == false) then
				local loaded, reason = LoadAddOn("AAP-TBC-WotLK")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-TBC-WotLK is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A102-60-83"
			if (AAP.Level >	79) then
				levelcheck80 = 1
			end
		end
	end
	if (AAPZoneActiveCheck == 0 and IsInInstance() == false and AAP.Faction == "Alliance" and AAP.Level > 59 and AAP.Level < 80) then
		if (IsQuestFlaggedCompleted(11672) == false) then
			AAPWhereToGo = "Stormwind"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(11672) == true and IsQuestFlaggedCompleted(9747) == false) then
			AAPWhereToGo = "Stormwind"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(12157) == false) then
			AAPWhereToGo = "Borean Tundra"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(12511) == false) then
			AAPWhereToGo = "Dragonblight"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(12802) == false) then
			AAPWhereToGo = "Grizzly Hills"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(12859) == false) then
			AAPWhereToGo = "Zul'Drak"
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(9780) == false) then
			AAPWhereToGo = "Zangarmarsh"
			AAP.BookingList["PrintQStep"] = 1
		else
			AAPWhereToGo = nil
		end
	elseif (AAPZoneActiveCheck == 1) then
		AAPWhereToGo = nil
	end
--------------------------------
---- Cata - MoP - Horde --------
	if (AAP.Faction == "Horde" and AAP.Level > 79 and AAP.Level < 90) then
		if (AAP.ActiveMap == 85) then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "1-80to90"
		end
		if (AAP.ActiveMap == 18) then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "18-80-90"
		end
		if (AAP.ActiveMap == 12) then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "12-80-90"
		end
	end
	if (AAP.Faction == "Horde" and AAP.Level > 79 and AAP.Level < 93) then
		if (AAP.ActiveMap == 198) then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "198-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
		if (AAP.ActiveMap == 371) then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "371-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
		if (AAP.ActiveMap == 433) then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "433-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
		if (AAP.ActiveMap == 379) then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "379-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
	end
	if (AAPZoneActiveCheck == 0 and IsInInstance() == false and AAP.Faction == "Horde" and AAP.Level > 79 and AAP.Level < 90) then
		if (IsQuestFlaggedCompleted(25460) == false) then
			AAPWhereToGo = "Orgrimmar"
		elseif (IsQuestFlaggedCompleted(25928) == true and IsQuestFlaggedCompleted(31853) == false) then
			AAPWhereToGo = "Orgrimmar"
		elseif (IsQuestFlaggedCompleted(25928) == false) then
			AAPWhereToGo = "Mount Hyjal"
		elseif (IsQuestFlaggedCompleted(29971) == false) then
			AAPWhereToGo = "The Jade Forest"
		elseif (IsQuestFlaggedCompleted(30692) == false) then
			AAPWhereToGo = "Kun-Lai Summit"
		else
			AAPWhereToGo = nil
		end
	elseif (AAPZoneActiveCheck == 1) then
		AAPWhereToGo = nil
	end
--------------------------------
---- Cata - MoP - Alliance -----
	if (AAP.Faction == "Alliance" and AAP.Level > 79 and AAP.Level < 90) then
		if (AAP.ActiveMap == "A84") then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A84-80-90"
		end
	end
	if (AAP.Faction == "Alliance" and AAP.Level > 79 and AAP.Level < 93) then
		if (AAP.ActiveMap == "A198") then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A198-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
		if (AAP.ActiveMap == "A13") then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A13-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
		if (AAP.ActiveMap == "A371") then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A371-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
		if (AAP.ActiveMap == "A433") then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A433-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
		if (AAP.ActiveMap == "A379") then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A379-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
		if (AAP.ActiveMap == "A388") then
			if (IsAddOnLoaded("AAP-Cata-MoP") == false) then
				local loaded, reason = LoadAddOn("AAP-Cata-MoP")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Cata-MoP is Disabled in your Addon-List!")
					end
				end
			end
			AAPZoneActiveCheck = 1
			AAP.ActiveMap = "A388-80-93"
			if (AAP.Level >	89) then
				levelcheck90 = 1
			end
		end
	end
	if (AAPZoneActiveCheck == 0 and IsInInstance() == false and AAP.Faction == "Alliance" and AAP.Level > 79 and AAP.Level < 90) then
		if (IsQuestFlaggedCompleted(25370) == false) then
			AAPWhereToGo = "Stormwind"
		elseif (IsQuestFlaggedCompleted(25928) == true and IsQuestFlaggedCompleted(29548) == false) then
			AAPWhereToGo = "Stormwind"
		elseif (IsQuestFlaggedCompleted(25928) == false) then
			AAPWhereToGo = "Mount Hyjal"
		elseif (IsQuestFlaggedCompleted(29587) == false) then
			AAPWhereToGo = "The Jade Forest"
		elseif (IsQuestFlaggedCompleted(31695) == false) then
			AAPWhereToGo = "Kun-Lai Summit"
		elseif (IsQuestFlaggedCompleted(30891) == false) then
			AAPWhereToGo = "Townlong Steppes"
		else
			AAPWhereToGo = nil
		end
	elseif (AAPZoneActiveCheck == 1) then
		AAPWhereToGo = nil
	end
--------------------------------
---- WoD - Horde ---------------
	if (AAP.Faction == "Horde" and AAP.Level > 89 and AAP.Level < 100) then
		if (AAP.ActiveMap == 18) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "18-90-100"
		end
		if (AAP.ActiveMap == 85) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "1-90to100"
		end
		if (AAP.ActiveMap == 17) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "17-90-100"
		end
	end
	if (AAP.Faction == "Horde" and AAP.Level > 89 and AAP.Level < 103) then
		if (AAP.ActiveMap == 578) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "578-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == 577) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "577-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == 525) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "525-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == 543) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "543-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == 535) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "535-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == 582) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "582-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == 539) then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "539-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
	end
--------------------------------
---- WoD - Alliance ------------
	if (AAP.Faction == "Alliance" and AAP.Level > 89 and AAP.Level < 100) then
		if (AAP.ActiveMap == "A84") then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A84-90-100"
		end
	end
	if (AAP.Level > 89 and AAP.Level < 103) then
		if (AAP.ActiveMap == "A17") then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A17-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == "A578") then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A578-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == "A577") then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A577-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == "A539") then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A539-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == "A543") then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A543-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
		if (AAP.ActiveMap == "A535") then
			if (IsAddOnLoaded("AAP-WoD") == false) then
				local loaded, reason = LoadAddOn("AAP-WoD")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-WoD is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A535-90-100"
			if (AAP.Level >	99) then
				levelcheck100 = 1
			end
		end
	end
--------------------------------
---- Legion - Horde ------------
	if ((AAP.Faction == "Horde" and AAP.Level > 99 and AAP.Level < 110) or (AAP1[AAP.Realm][AAP.Name]["Settings"]["Legion"] == 1 and AAP.Faction == "Horde")) then
		if (AAP.ActiveMap == 18) then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "18-100-110"
		end
		if (AAP.ActiveMap == 85) then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "1-100to110"
		end
		if (AAP.ActiveMap == 627) then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "627-100-110"
		end
	end
	if ((AAP.Faction == "Horde" and AAP.Level > 97 and AAP.Level < 113) or (AAP1[AAP.Realm][AAP.Name]["Settings"]["Legion"] == 1 and AAP.Faction == "Horde")) then
		if (AAP.ActiveMap == 634) then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "634-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
		if (AAP.ActiveMap == 630) then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "630-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
		if (AAP.ActiveMap == 641) then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "641-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
		if (AAP.ActiveMap == 76) then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "76-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
		if (AAP.ActiveMap == 650) then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "650-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
	end
--------------------------------
---- Legion - Alliance ---------
	if ((AAP.Faction == "Alliance" and AAP.Level > 99 and AAP.Level < 110) or (AAP1[AAP.Realm][AAP.Name]["Settings"]["Legion"] == 1 and AAP.Faction == "Alliance")) then
		if (AAP.ActiveMap == "A84") then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			if (AAP.ActiveQuests[40519] or AAP.ActiveQuests[42782]) then
				AAP.ActiveMap = "A84-100-110"
			end
		end
		if (AAP.ActiveMap == "A627") then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A627-100-110"
		end
	end
	if ((AAP.Faction == "Alliance" and AAP.Level > 97 and AAP.Level < 113) or (AAP1[AAP.Realm][AAP.Name]["Settings"]["Legion"] == 1 and AAP.Faction == "Alliance")) then
		if (AAP.ActiveMap == "A634") then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A634-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
		if (AAP.ActiveMap == "A630") then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A630-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
		if (AAP.ActiveMap == "A641") then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A641-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
		if (AAP.ActiveMap == "A76") then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A76-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
		if (AAP.ActiveMap == "A650") then
			if (IsAddOnLoaded("AAP-Legion") == false) then
				local loaded, reason = LoadAddOn("AAP-Legion")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-Legion is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "A650-100-110"
			if (AAP.Level >	109) then
				levelcheck110 = 1
			end
		end
	end
--------------------------------
---- BFA - Horde ---------------
	if (AAP.Faction == "Horde" and AAP.Level > 109 and AAP.Level < 120) then
		if (AAP.ActiveMap == 627) then
			if (IsAddOnLoaded("AAP-BfA") == false) then
				local loaded, reason = LoadAddOn("AAP-BfA")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-BfA is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "627-110"
		end
		if (AAP.ActiveMap == 81) then
			if (IsAddOnLoaded("AAP-BfA") == false) then
				local loaded, reason = LoadAddOn("AAP-BfA")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-BfA is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "81-110"
		end
		if (AAP.ActiveMap == 249) then
			if (IsAddOnLoaded("AAP-BfA") == false) then
				local loaded, reason = LoadAddOn("AAP-BfA")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-BfA is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "249-110"
		end
		if (AAP.ActiveMap == 85 and (AAP.ActiveQuests[53372] or IsQuestFlaggedCompleted(53372) == true)) then
			if (IsAddOnLoaded("AAP-BfA") == false) then
				local loaded, reason = LoadAddOn("AAP-BfA")
				if (not loaded) then
					if (reason == "DISABLED") then
						print("AAP: AAP-BfA is Disabled in your Addon-List!")
					end
				end
			end
			AAP.ActiveMap = "1-110"
		end
	end
	if (AAP.Faction == "Horde" and AAP.Level > 109 and AAP.Level < 123) then
		if (AAP.ActiveMap == 862) then
			if ((AAP.ActiveQuests[47514] or IsQuestFlaggedCompleted(47514) == true) and IsQuestFlaggedCompleted(50963) == false) then
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "862-110-120-3"
			elseif ((AAP.ActiveQuests[47513] or IsQuestFlaggedCompleted(47513) == true) and IsQuestFlaggedCompleted(47315) == false) then
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "862-110-120-1"
			elseif ((AAP.ActiveQuests[47512] or IsQuestFlaggedCompleted(47512) == true) and IsQuestFlaggedCompleted(47105) == false) then
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "862-110-120-2"
			elseif (IsQuestFlaggedCompleted(47105) == true and IsQuestFlaggedCompleted(47315) == true and IsQuestFlaggedCompleted(50963) == true) then
				AAP1[AAP.Realm][AAP.Name]["HordeD"] = 1
				AAP.ActiveMap = "862-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "862-110-120"
			end
		end
		if (AAP.ActiveMap == 863) then
			if (IsQuestFlaggedCompleted(50808)) then
				AAP.ActiveMap = "863-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "863-110-120"
			end
		end
		if (AAP.ActiveMap == 864) then
			if (IsQuestFlaggedCompleted(50703)) then
				AAP.ActiveMap = "864-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "864-110-120"
			end
		end
		if (AAP.ActiveMap == 895) then
			if (IsQuestFlaggedCompleted(51984)) then
				AAP.ActiveMap = "895-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "895-110-120"
			end
		end
		if (AAP.ActiveMap == 896) then
			if (IsQuestFlaggedCompleted(51985)) then
				AAP.ActiveMap = "896-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "896-110-120"
			end
		end
		if (AAP.ActiveMap == 942) then
			if (IsQuestFlaggedCompleted(51986)) then
				AAP.ActiveMap = "942-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "942-110-120"
			end
		end
	end
--------------------------------
---- BFA - Alliance ------------
	if (AAP.Faction == "Alliance" and AAP.Level > 109 and AAP.Level < 120) then
		if (AAP.ActiveMap == "A84") then
			if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
			end
			AAP.ActiveMap = "A84-110-120"
		end
		if (AAP.ActiveMap == "A249") then
			if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
			end
			AAP.ActiveMap = "A249-110-120"
		end
		if (AAP.ActiveMap == "A81") then
			if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
			end
			AAP.ActiveMap = "A81-110-120"
		end
	end
	if (AAP.Faction == "Alliance" and AAP.Level > 109 and AAP.Level < 123) then
		if (AAP.ActiveMap == "A895") then
			if ((AAP.ActiveQuests[47961] or IsQuestFlaggedCompleted(47961) == true) and not IsQuestFlaggedCompleted(48622)) then
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "A895-110-120-1"
			elseif ((AAP.ActiveQuests[47962] or IsQuestFlaggedCompleted(47962) == true) and not IsQuestFlaggedCompleted(51490)) then
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "A895-110-120-2"
			elseif ((AAP.ActiveQuests[47960] or IsQuestFlaggedCompleted(47960) == true) and not IsQuestFlaggedCompleted(50972)) then
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "A895-110-120-3"
			else
				if (IsQuestFlaggedCompleted(48622) and IsQuestFlaggedCompleted(51490) and IsQuestFlaggedCompleted(50972)) then
					AAP.ActiveMap = "A895-99"
				else
					if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
					end
					AAP.ActiveMap = "A895-110-120"
				end
			end
		end
		if (AAP.ActiveMap == "A942") then
			if (IsQuestFlaggedCompleted(49908)) then
				AAP.ActiveMap = "A942-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "A942-110-120"
			end
		end
		if (AAP.ActiveMap == "A876") then
			if (IsQuestFlaggedCompleted(47098)) then
				AAP.ActiveMap = "A876-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "A876-110-120"
			end
		end
		if (AAP.ActiveMap == "A863") then
			if (IsQuestFlaggedCompleted(51967)) then
				AAP.ActiveMap = "A863-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "A863-110-120"
			end
		end
		if (AAP.ActiveMap == "A862") then
			if (IsQuestFlaggedCompleted(51968)) then
				AAP.ActiveMap = "A862-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "A862-110-120"
			end
		end
		if (AAP.ActiveMap == "A864") then
			if (IsQuestFlaggedCompleted(51969)) then
				AAP.ActiveMap = "A864-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "A864-110-120"
			end
		end
		if (AAP.ActiveMap == "A896") then
			if (IsQuestFlaggedCompleted(50639)) then
				AAP.ActiveMap = "A896-99"
			else
				if (IsAddOnLoaded("AAP-BfA") == false) then
					local loaded, reason = LoadAddOn("AAP-BfA")
					if (not loaded) then
						if (reason == "DISABLED") then
							print("AAP: AAP-BfA is Disabled in your Addon-List!")
						end
					end
				end
				AAP.ActiveMap = "A896-110-120"
			end
		end
	end
--------------------------------
	if (AAP.Faction == "Horde" and AAP.Level == 120 and AAP1[AAP.Realm][AAP.Name]["Settings"]["WQs"] == 1) then
		AAP.WQFunc()
	end
	
	--levelcheck = 1
	if (levelcheck == 1) then
		AAP.Dinged60 = 1
	else
		AAP.Dinged60 = 0
	end
	if (levelcheck80 == 1) then
		AAP.Dinged80 = 1
	else
		AAP.Dinged80 = 0
	end
	if (levelcheck90 == 1) then
		AAP.Dinged90 = 1
	else
		AAP.Dinged90 = 0
	end
	if (levelcheck100 == 1) then
		AAP.Dinged100 = 1
	else
		AAP.Dinged100 = 0
	end
	if (levelcheck110 == 1) then
		AAP.Dinged110 = 1
	else
		AAP.Dinged110 = 0
	end
	if (AAP.ActiveQuests and AAP.ActiveQuests[26320] and (C_Map.GetBestMapForUnit("player") == 291 or C_Map.GetBestMapForUnit("player") == 292)) then
		AAP.ActiveMap = "ADeadmines"
	end
	if (not AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]) then
		AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = 1
	end
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
	else
		AAP.BookingList["ClosedSettings"] = 1
	end
	if (AAP.ZoneQuestOrder:IsShown() == true) then
		AAP.UpdateZoneQuestOrderList("LoadIn")
	end
	AAP_CheckZoneSteps()
end
local function AAP_CheckZonePick()
	if (AAP.ActiveMap == 862) then
		if (IsQuestFlaggedCompleted(50963) == false and (AAP.ActiveQuests[47514] or IsQuestFlaggedCompleted(47514) == true)) then
			AAP.BookingList["UpdateMapId"] = 1
			AAP.BookingList["PrintQStep"] = 1
		elseif ((AAP.ActiveQuests[47513] or IsQuestFlaggedCompleted(47513) == true) and IsQuestFlaggedCompleted(47315) == false) then
			AAP.BookingList["UpdateMapId"] = 1
			AAP.BookingList["PrintQStep"] = 1
		elseif ((AAP.ActiveQuests[47512] or IsQuestFlaggedCompleted(47512) == true) and IsQuestFlaggedCompleted(47105) == false) then
			AAP.BookingList["UpdateMapId"] = 1
			AAP.BookingList["PrintQStep"] = 1
		elseif (IsQuestFlaggedCompleted(47105) == true and IsQuestFlaggedCompleted(47315) == true and IsQuestFlaggedCompleted(50963) == true) then
			AAP.BookingList["UpdateMapId"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end
	end
end
local function AAP_AcceptQuester()
	AcceptQuest()
end
local function AAP_CheckDistance()
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	if (CurStep and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
		if (AAP.QuestStepList[AAP.ActiveMap][CurStep]["CRange"]) then
			AAP.ArrowFrame.Button:Show()
			local plusnr = CurStep
			local Distancenr = 0
			local testad = true
			if (AAP.QuestStepList[AAP.ActiveMap][CurStep]["NoExtraRange"]) then
				testad = false
			end
			while testad do
				local oldx = AAP.QuestStepList[AAP.ActiveMap][plusnr]["TT"]["x"]
				local oldy = AAP.QuestStepList[AAP.ActiveMap][plusnr]["TT"]["y"]
				plusnr = plusnr + 1
				if (AAP.QuestStepList[AAP.ActiveMap][plusnr] and AAP.QuestStepList[AAP.ActiveMap][plusnr]["CRange"]) then
					local newx = AAP.QuestStepList[AAP.ActiveMap][plusnr]["TT"]["x"]
					local newy = AAP.QuestStepList[AAP.ActiveMap][plusnr]["TT"]["y"]
					local deltaX, deltaY = oldx - newx, newy - oldy
					local distance = (deltaX * deltaX + deltaY * deltaY)^0.5
					Distancenr = Distancenr + distance
				else
					if (AAP.QuestStepList[AAP.ActiveMap][plusnr] and AAP.QuestStepList[AAP.ActiveMap][plusnr]["TT"]) then
						local newx = AAP.QuestStepList[AAP.ActiveMap][plusnr]["TT"]["x"]
						local newy = AAP.QuestStepList[AAP.ActiveMap][plusnr]["TT"]["y"]
						local deltaX, deltaY = oldx - newx, newy - oldy
						local distance = (deltaX * deltaX + deltaY * deltaY)^0.5
						Distancenr = Distancenr + distance
					end
					return floor(Distancenr + 0.5)
				end
			end
		end
	end
	return 0
end
local function AAP_SetQPTT()
	if (AAP.SettingsOpen == 1) then
		return
	end
	local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
	if (QNumberLocal ~= CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep] and AAP.QuestStepList[AAP.ActiveMap][CurStep]["TT"]) then
		AAP.ArrowActive = 1
		AAP.ArrowActive_X = AAP.QuestStepList[AAP.ActiveMap][CurStep]["TT"]["x"]
		AAP.ArrowActive_Y = AAP.QuestStepList[AAP.ActiveMap][CurStep]["TT"]["y"]
		QNumberLocal = CurStep
		AAP["Icons"][1].A = 1
		AAP["MapIcons"][1].A = 1
	end
end
local function AAP_Heirloomscheck()
	AAP.Heirlooms = 0
	for slots2 = 0,18 do
		if (slots2 == 1 or slots2 == 3 or slots2 == 5 or slots2 == 7 or slots2 == 11 or slots2 == 12 or slots2 == 15) then
			local itemLink = GetInventoryItemLink("player", slots2)
			if (itemLink) then
				local _, _, quality, _, _, _, _, _, SpotName = GetItemInfo(itemLink)
				if (quality and quality == 7) then
					AAP.Heirlooms = AAP.Heirlooms + 1
				end
			end
		end
	end
	AAP.BookingList["PrintQStep"] = 1
end
local function AAP_PosTest()
	if (AAP1 and AAP1[AAP.Realm][AAP.Name] and AAP1[AAP.Realm][AAP.Name]["Settings"] and AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowArrow"] == 0) then
		AAP.ArrowActive = 0
		AAP.ArrowFrame:Hide()
		
		AAP.RemoveIcons()
	else
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		if (AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep] and AAP.QuestStepList[AAP.ActiveMap][CurStep]["AreaTriggerZ"]) then
			local d_y, d_x = UnitPosition("player")
			x = AAP.QuestStepList[AAP.ActiveMap][CurStep]["AreaTriggerZ"]["x"]
			y = AAP.QuestStepList[AAP.ActiveMap][CurStep]["AreaTriggerZ"]["y"]
			local deltaX, deltaY = d_x - x, y - d_y
			local distance = (deltaX * deltaX + deltaY * deltaY)^0.5
			if (AAP.QuestStepList[AAP.ActiveMap][CurStep]["AreaTriggerZ"]["R"] > distance) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				QNumberLocal = 0
				AAP.BookingList["UpdateQuest"] = 1
				AAP.BookingList["PrintQStep"] = 1
			end
		end
		if ((AAP.ArrowActive == 0) or (AAP.ArrowActive_X == 0) or (IsInInstance()) or not AAP.QuestStepList) then
			AAP.ArrowActive = 0
			AAP.ArrowFrame:Hide()
			AAP.RemoveIcons()
		else
			AAP.ArrowFrame:Show()
			AAP.ArrowFrame.Button:Hide()
			local d_y, d_x = UnitPosition("player")
			if (d_x and d_y) then
				x = AAP.ArrowActive_X
				y = AAP.ArrowActive_Y
				local AAP_ArrowActive_TrigDistance
				local PI2 = math.pi * 2
				local atan2 = math.atan2
				local twopi = math.pi * 2
				local deltaX, deltaY = d_x - x, y - d_y
				local distance = (deltaX * deltaX + deltaY * deltaY)^0.5
				local angle = atan2(-deltaX, deltaY)
				local player = GetPlayerFacing()
				angle = angle - player
				local perc = math.abs((math.pi - math.abs(angle)) / math.pi)
				if perc > 0.98 then
					AAP.ArrowFrame.arrow:SetVertexColor(0,1,0)
				elseif perc > 0.49 then
					AAP.ArrowFrame.arrow:SetVertexColor((1-perc)*2,1,0)
				else
					AAP.ArrowFrame.arrow:SetVertexColor(1,perc*2,0)
				end
				local cell = floor(angle / twopi * 108 + 0.5) % 108
				local col = cell % 9
				local row = floor(cell / 9)
				AAP.ArrowFrame.arrow:SetTexCoord((col * 56) / 512,((col + 1) * 56) / 512,(row * 42) / 512,((row + 1) * 42) / 512)
				AAP.ArrowFrame.distance:SetText(floor(distance + AAP_CheckDistance()) .. " "..AAP_Locals["Yards"])
				local AAP_ArrowActive_Distance = 0
				if (CurStep and AAP.ActiveMap and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
					if (AAP.QuestStepList[AAP.ActiveMap][CurStep]["Trigger"]) then
						local d_y, d_x = UnitPosition("player")
						local AAP_ArrowActive_Trigger_X = AAP.QuestStepList[AAP.ActiveMap][CurStep]["Trigger"]["x"]
						local AAP_ArrowActive_Trigger_Y = AAP.QuestStepList[AAP.ActiveMap][CurStep]["Trigger"]["y"]
						local deltaX, deltaY = d_x - AAP_ArrowActive_Trigger_X, AAP_ArrowActive_Trigger_Y - d_y
						AAP_ArrowActive_Distance = (deltaX * deltaX + deltaY * deltaY)^0.5
						AAP_ArrowActive_TrigDistance = AAP.QuestStepList[AAP.ActiveMap][CurStep]["Range"]
						if (AAP.QuestStepList[AAP.ActiveMap][CurStep]["HIDEME"]) then
							AAP.ArrowActive = 0
						end
					end
				end
				if (distance < 5 and AAP_ArrowActive_Distance == 0) then
					AAP.ArrowActive_X = 0
				elseif (AAP_ArrowActive_Distance and AAP_ArrowActive_TrigDistance and AAP_ArrowActive_Distance < AAP_ArrowActive_TrigDistance) then
					AAP.ArrowActive_X = 0
					if (CurStep and AAP.ActiveMap and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
						if (AAP.QuestStepList[AAP.ActiveMap][CurStep]["CRange"]) then
							AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
							QNumberLocal = 0
							AAP.BookingList["UpdateQuest"] = 1
							AAP.BookingList["PrintQStep"] = 1
						end
					end
				end
			end
		end
	end
end
local function AAP_LoopBookingFunc()
	local TestaAAP = 0
	if (AAP.BookingList["OpenedSettings"]) then
		AAP.BookingList["OpenedSettings"] = nil
		AAP.ArrowActive = 1
		AAP.ArrowActive_Y, AAP.ArrowActive_X = UnitPosition("player")
		QNumberLocal = 0
		AAP_SettingsButtons()
		AAP.ArrowActive_Y = AAP.ArrowActive_Y + 150
		AAP.ArrowActive_X = AAP.ArrowActive_X + 150
		AAP["Icons"][1].A = 1
		AAP.BookingList["PrintQStep"] = 1
		TestaAAP = "OpenedSettings"
	elseif (AAP.BookingList["ClosedSettings"]) then
		if (not InCombatLockdown()) then
			AAP.BookingList["ClosedSettings"] = nil
			QNumberLocal = 0
			AAP.ArrowActive = 0
			AAP.RemoveIcons()
			local CLi
			for CLi = 1, 10 do
				AAP.QuestList.QuestFrames[CLi]:Hide()
				AAP.QuestList.QuestFrames["FS"..CLi]["Button"]:Hide()
				AAP.QuestList2["BF"..CLi]:Hide()
			end
			AAP.BookingList["UpdateQuest"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end
		TestaAAP = "ClosedSettings"
	elseif (AAP.BookingList["UpdateMapId"]) then
		AAP.BookingList["UpdateMapId"] = nil
		AAP_UpdateMapId()
		if (AAP1["Debug"]) then
			print("LoopBookingFunc:UpdateMapId:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
		end
		TestaAAP = "UpdateMapId"
	elseif (AAP.BookingList["AcceptQuest"]) then
		AAP.BookingList["AcceptQuest"] = nil
		C_Timer.After(0.2, AAP_AcceptQuester)
		TestaAAP = "AcceptQuest"
	elseif (AAP.BookingList["CompleteQuest"]) then
		AAP.BookingList["CompleteQuest"] = nil
		CompleteQuest()
		TestaAAP = "CompleteQuest"
	elseif (AAP.BookingList["CreateMacro"]) then
		AAP.BookingList["CreateMacro"] = nil
		AAP_CreateMacro()
		TestaAAP = "CreateMacro"
	elseif (AAP.BookingList["AddQuest"]) then
		if (AAP1["Debug"]) then
			print("LoopBookingFunc:AddQuest:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
		end
		AAP_AddQuest(AAP.BookingList["AddQuest"])
		AAP.BookingList["AddQuest"] = nil
		TestaAAP = "AddQuest"
	elseif (AAP.BookingList["RemoveQuest"]) then
		if (AAP1["Debug"]) then
			print("LoopBookingFunc:RemoveQuest:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
		end
		AAP_RemoveQuest(AAP.BookingList["RemoveQuest"])
		AAP.BookingList["RemoveQuest"] = nil
		AAP.BookingList["UpdateMapId"] = 1
		AAP.BookingList["PrintQStep"] = 1
		TestaAAP = "RemoveQuest"
	elseif (AAP.BookingList["UpdateQuest"]) then
		if (AAP1["Debug"]) then
			print("LoopBookingFunc:UpdateQuest:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
		end
		AAP.BookingList["UpdateQuest"] = nil
		AAP_UpdateQuest()
		TestaAAP = "UpdateQuest"
	elseif (AAP.BookingList["PrintQStep"]) then
		if (AAP1["Debug"]) then
			print("LoopBookingFunc:PrintQStep:"..AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap])
		end
		AAP.BookingList["PrintQStep"] = nil
		AAP_PrintQStep()
		TestaAAP = "PrintQStep"
	elseif (AAP.BookingList["UpdateILVLGear"]) then
		AAP.BookingList["UpdateILVLGear"] = nil
		AAP_UpdateILVLGear()
		TestaAAP = "UpdateILVLGear"
	elseif (AAP.BookingList["CheckSaveOldSlot"]) then
		AAP.BookingList["CheckSaveOldSlot"] = nil
		AAP_CheckSaveOldSlot()
		TestaAAP = "CheckSaveOldSlot"
	elseif (AAP.BookingList["CheckZonePick"]) then
		AAP.BookingList["CheckZonePick"] = nil
		AAP_CheckZonePick()
		TestaAAP = "CheckZonePick"
	elseif (AAP.BookingList["SetQPTT"]) then
		AAP.BookingList["SetQPTT"] = nil
		AAP_SetQPTT()
		TestaAAP = "SetQPTT"
	elseif (AAP.BookingList["UseTaxiFunc"]) then
		AAP.BookingList["UseTaxiFunc"] = nil
		AAP_UseTaxiFunc()
		TestaAAP = "UseTaxiFunc"
	elseif (AAP.BookingList["TestTaxiFunc"]) then
		AAP_AntiTaxiLoop = AAP_AntiTaxiLoop + 1
		if (UnitOnTaxi("player")) then
			AAP.BookingList["TestTaxiFunc"] = nil
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["PrintQStep"] = 1
			AAP_AntiTaxiLoop = 0
		elseif (AAP_AntiTaxiLoop == 50 or AAP_AntiTaxiLoop == 100 or AAP_AntiTaxiLoop == 150) then
			--TaxiNodeOnButtonEnter(getglobal("TaxiButton"..AAP.BookingList["TestTaxiFunc"]))
			TakeTaxiNode(AAP.BookingList["TestTaxiFunc"])
		end
		if (AAP_AntiTaxiLoop > 200) then
			print ("AAP: Error - AntiTaxiLoop")
			AAP.BookingList["TestTaxiFunc"] = nil
			AAP_AntiTaxiLoop = 0
		end
		TestaAAP = "TestTaxiFunc"
	elseif (AAP.BookingList["SkipCutscene"]) then
		AAP.BookingList["SkipCutscene"] = nil
		CinematicFrame_CancelCinematic()
		C_Timer.After(1, CinematicFrame_CancelCinematic)
		C_Timer.After(3, CinematicFrame_CancelCinematic)
		TestaAAP = "SkipCutscene"
	elseif (AAP.BookingList["ButtonSpellidchk"]) then
		for AAP_index,AAP_value in pairs(AAP.BookingList["ButtonSpellidchk"]) do
			if (AAP_value) then
				local _, duration = GetItemCooldown(AAP_value)
				if (duration and duration > 0 and AAP_index and AAP.QuestList2 and AAP.QuestList2["BF"..AAP_index] and AAP.QuestList2["BF"..AAP_index]["AAP_ButtonCD"]) then
					AAP.QuestList2["BF"..AAP_index]["AAP_ButtonCD"]:SetCooldown(GetTime(), duration)
				end
			end
		end
		AAP.BookingList["ButtonSpellidchk"] = nil
		TestaAAP = "ButtonSpellidchk"
	elseif (AAP.BookingList["Heirloomscheck"]) then
		AAP.BookingList["Heirloomscheck"] = nil
		AAP_Heirloomscheck()
		TestaAAP = "Heirloomscheck"
	end
	if (AAP1 and AAP1[AAP.Realm][AAP.Name] and AAP1[AAP.Realm][AAP.Name]["Settings"] and AAP1[AAP.Realm][AAP.Name]["Settings"]["ArrowFPS"] and AAP_ArrowUpdateNr >= AAP1[AAP.Realm][AAP.Name]["Settings"]["ArrowFPS"]) then
		AAP_PosTest()
		AAP_ArrowUpdateNr = 0
	else
		AAP_ArrowUpdateNr = AAP_ArrowUpdateNr + 1
	end
	--if (TestaAAP ~= 0) then
	--	print("** "..TestaAAP)
	--end
end
local function AAP_BuyMerchFunc()
	local i
	for i=1,GetMerchantNumItems() do
		local link = GetMerchantItemLink(i)
		if (link) then
			local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(link, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
			if (tonumber(Id) == 160499) then
				BuyMerchantItem(i)
				MerchantFrame:Hide()
				return 1
			end
		end
	end
	return 0
end
local function AAP_PopupFunc()
	if (GetNumAutoQuestPopUps() > 0) then
		local questID, popUpType = GetAutoQuestPopUp(1)
		if(popUpType == "OFFER") then
			ShowQuestOffer(GetQuestLogIndexByID(questID))
		else
			ShowQuestComplete(GetQuestLogIndexByID(questID))
		end
	else
		C_Timer.After(1, AAP_PopupFunc)
	end
end
function AAP_BookQStep()
	AAP.BookingList["UpdateQuest"] = 1
	AAP.BookingList["PrintQStep"] = 1
	if (AAP1["Debug"]) then
		print("Extra BookQStep")
	end
end
function AAP_UpdQuestThing()
	AAP.BookingList["UpdateQuest"] = 1
	Updateblock = 0
	if (AAP1["Debug"]) then
		print("Extra UpdQuestThing")
	end
end
function AAP_UpdatezeMapId()
	AAP.BookingList["UpdateMapId"] = 1
end
local function AAP_ZoneResetQnumb()
	QNumberLocal = 0
	AAP_SetQPTT()
end
local function AAP_InstanceTest()
	local inInstance, instanceType = IsInInstance()
	if (inInstance) then
		local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()
		if (instanceMapId == 1760) then
			return 0
		elseif (instanceMapId == 1904) then
			return 0
		else
			return 1
		end
	else
		return 0
	end
end
function AAP.GroupListingFunc(AAP_StepStuffs, AAP_GListName)
	if (not AAP.GroupListSteps[1]) then
		AAP.GroupListSteps[1] = {}
		AAP.GroupListStepsNr = 1
	end
	AAP.GroupListSteps[1]["Step"] = AAP_StepStuffs
	AAP.GroupListSteps[1]["Name"] = AAP.Name
	if (AAP_GListName ~= AAP.Name) then
		local AAPNews = 0
		for AAP_index,AAP_value in pairs(AAP.GroupListSteps) do
			if (AAP.GroupListSteps[AAP_index]["Name"] == AAP_GListName) then
				AAP.GroupListSteps[AAP_index]["Step"] = AAP_StepStuffs
				AAPNews = 1
			end
		end
		if (AAPNews == 0) then
			AAP.GroupListStepsNr = AAP.GroupListStepsNr + 1
			AAP.GroupListSteps[AAP.GroupListStepsNr] = {}
			AAP.GroupListSteps[AAP.GroupListStepsNr]["Name"] = AAP_GListName
			AAP.GroupListSteps[AAP.GroupListStepsNr]["Step"] = AAP_StepStuffs
		end
	end
	AAP.RepaintGroups()
end
function AAP.RepaintGroups()
	if (IsInInstance()) then
		local CLi
		for CLi = 1, 5 do
			AAP.PartyList.PartyFrames[CLi]:Hide()
			AAP.PartyList.PartyFrames2[CLi]:Hide()
		end
	else
		if (not AAP.GroupListSteps[1]) then
			AAP.GroupListSteps[1] = {}
			AAP.GroupListStepsNr = 1
		end
		AAP.GroupListSteps[1]["Step"] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		AAP.GroupListSteps[1]["Name"] = AAP.Name
		local CLi
		for CLi = 1, 5 do
			if (AAP.GroupListSteps[CLi]) then
				AAP.PartyList.PartyFramesFS1[CLi]:SetText(AAP.GroupListSteps[CLi]["Name"])
				AAP.PartyList.PartyFramesFS2[CLi]:SetText(AAP.GroupListSteps[CLi]["Step"])
				local CLi2
				local Highnr = 0
				for CLi2 = 1, 5 do
					if (AAP.GroupListSteps[CLi2] and AAP.GroupListSteps[CLi2]["Step"] and AAP.GroupListSteps[CLi] and AAP.GroupListSteps[CLi]["Step"] and (AAP.GroupListSteps[CLi2]["Step"] > AAP.GroupListSteps[CLi]["Step"])) then
						Highnr = 1
					end
				end
				if (Highnr == 1) then
					AAP.PartyList.PartyFramesFS2[CLi]:SetTextColor(1, 0, 0)
				else
					AAP.PartyList.PartyFramesFS2[CLi]:SetTextColor(0, 1, 0)
				end
				AAP.PartyList.PartyFrames[CLi]:Show()
				AAP.PartyList.PartyFrames2[CLi]:Show()
			else
				AAP.PartyList.PartyFrames[CLi]:Hide()
				AAP.PartyList.PartyFrames2[CLi]:Hide()
			end
		end
	end
	if (AAP1[AAP.Realm][AAP.Name]["Settings"]["ShowGroup"] == 0) then
		local CLi
		for CLi = 1, 5 do
			AAP.PartyList.PartyFrames[CLi]:Hide()
			AAP.PartyList.PartyFrames2[CLi]:Hide()
		end
	end
end

AAP.LoopBooking = CreateFrame("frame")
AAP.LoopBooking:SetScript("OnUpdate", AAP_LoopBookingFunc)

AAP_QH_EventFrame = CreateFrame("Frame")
AAP_QH_EventFrame:RegisterEvent ("QUEST_REMOVED")
AAP_QH_EventFrame:RegisterEvent ("QUEST_ACCEPTED")
AAP_QH_EventFrame:RegisterEvent ("UNIT_QUEST_LOG_CHANGED")
AAP_QH_EventFrame:RegisterEvent ("PLAYER_EQUIPMENT_CHANGED")
AAP_QH_EventFrame:RegisterEvent ("ZONE_CHANGED")
AAP_QH_EventFrame:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
AAP_QH_EventFrame:RegisterEvent ("UPDATE_MOUSEOVER_UNIT")
AAP_QH_EventFrame:RegisterEvent ("GOSSIP_SHOW")
AAP_QH_EventFrame:RegisterEvent ("UI_INFO_MESSAGE")
AAP_QH_EventFrame:RegisterEvent ("HEARTHSTONE_BOUND")
AAP_QH_EventFrame:RegisterEvent ("UNIT_SPELLCAST_SUCCEEDED")
AAP_QH_EventFrame:RegisterEvent ("UNIT_SPELLCAST_START")
AAP_QH_EventFrame:RegisterEvent ("QUEST_PROGRESS")
AAP_QH_EventFrame:RegisterEvent ("QUEST_DETAIL")
AAP_QH_EventFrame:RegisterEvent ("QUEST_COMPLETE")
AAP_QH_EventFrame:RegisterEvent ("TAXIMAP_OPENED")
AAP_QH_EventFrame:RegisterEvent ("MERCHANT_SHOW")
AAP_QH_EventFrame:RegisterEvent ("QUEST_GREETING")
AAP_QH_EventFrame:RegisterEvent ("ITEM_PUSH")
AAP_QH_EventFrame:RegisterEvent ("QUEST_AUTOCOMPLETE")
AAP_QH_EventFrame:RegisterEvent ("QUEST_ACCEPT_CONFIRM")
AAP_QH_EventFrame:RegisterEvent ("UNIT_ENTERED_VEHICLE")
AAP_QH_EventFrame:RegisterEvent ("QUEST_CHOICE_UPDATE")
AAP_QH_EventFrame:RegisterEvent ("PLAYER_REGEN_ENABLED")
AAP_QH_EventFrame:RegisterEvent ("PLAYER_REGEN_DISABLED")
AAP_QH_EventFrame:RegisterEvent ("CHAT_MSG_ADDON")
AAP_QH_EventFrame:RegisterEvent ("CHAT_MSG_COMBAT_XP_GAIN")
AAP_QH_EventFrame:RegisterEvent ("UNIT_ENTERED_VEHICLE")
AAP_QH_EventFrame:RegisterEvent ("UNIT_AURA")

AAP_QH_EventFrame:SetScript("OnEvent", function(self, event, ...)
	if (event=="UNIT_AURA") then
		local arg1, arg2, arg3, arg4 = ...;
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if (arg1 == "player" and steps and steps["Debuffcount"]) then
			for i=1,20 do
				local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellId = UnitBuff("player", i)
				if (spellId and name and count) then
					if (spellId == 69704 and count == 5) then
						AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
						AAP.BookingList["UpdateQuest"] = 1
						AAP.BookingList["PrintQStep"] = 1
					end
				end
			end
		end
	end
	if (event=="CHAT_MSG_COMBAT_XP_GAIN") then
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if (steps and steps["Treasure"]) then
			AAP.BookingList["UpdateQuest"] = 1
			AAP.BookingList["PrintQStep"] = 1
			C_Timer.After(2, AAP_BookQStep)
			C_Timer.After(4, AAP_BookQStep)
		end
	end
	if (event=="UNIT_ENTERED_VEHICLE") then
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if (steps and steps["MountVehicle"]) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["UpdateQuest"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end
	end
	if (event=="PLAYER_REGEN_ENABLED") then
		AAP.InCombat = 0
		if (AAP.BookUpdAfterCombat == 1) then
			AAP.BookingList["PrintQStep"] = 1
		end
	end
	if (event=="PLAYER_REGEN_DISABLED") then
		AAP.InCombat = 1
	end
	if (event=="CHAT_MSG_ADDON") then
		local arg1, arg2, arg3, arg4 = ...;
		if (arg1 == "AAPChat" and arg3 == "PARTY") then
			AAP.GroupListingFunc(tonumber(arg2), AAP.TrimPlayerServer(arg4))
		end
	end
	if (event=="QUEST_CHOICE_UPDATE") then
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		local choiceID, questionText, numOptions = GetQuestChoiceInfo()
		if (numOptions and numOptions > 1 and steps and steps["LumberYard"]) then
			local CLi
			for CLi = 1, numOptions do
				local optionID, buttonText, description, artFile = GetQuestChoiceOptionInfo(CLi)
				if (steps["LumberYard"] == optionID) then
					SendQuestChoiceResponse(GetQuestChoiceOptionInfo(CLi))
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["UpdateQuest"] = 1
					AAP.BookingList["PrintQStep"] = 1
					break
				end
			end
		end
		if (numOptions and numOptions > 1 and steps and steps["PickUpSpecial"]) then
			local CLi
			for CLi = 1, numOptions do
				local optionID, buttonText, description, artFile = GetQuestChoiceOptionInfo(CLi)
				if (steps["PickUpSpecial"] == optionID) then
					SendQuestChoiceResponse(GetQuestChoiceOptionInfo(CLi))
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["UpdateQuest"] = 1
					AAP.BookingList["PrintQStep"] = 1
					break
				end
			end
		end
	end
	if (event=="UNIT_ENTERED_VEHICLE") then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		if (arg1 == "player") then
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			local steps
			if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
				steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
				if (steps and steps["InVehicle"]) then
					AAP.BookingList["PrintQStep"] = 1
				end
			end
		end
	end
	if (event=="QUEST_AUTOCOMPLETE") then
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if(AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoHandIn"] == 1 and not IsControlKeyDown()) then
			if (steps and steps["SpecialNoAutoHandin"]) then
			else
				AAP_PopupFunc()
			end
		end
	end
	if (event=="QUEST_ACCEPT_CONFIRM") then
		if (AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoAccept"] == 1 and not IsControlKeyDown()) then
			AcceptQuest()
		end
	end
	if (event=="QUEST_GREETING") then
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if (steps and steps["SpecialNoAutoHandin"]) then
			return
		end
		if (UnitGUID("target") and string.find(UnitGUID("target"), "(.*)-(.*)")) then
			local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",UnitGUID("target"))
			if (npc_id and ((tonumber(npc_id) == 141584) or (tonumber(npc_id) == 142063) or (tonumber(npc_id) == 25809))) then
				return
			end
		end
		local numAvailableQuests = 0;
		local numActiveQuests = 0;
		local lastActiveQuest = 0
		local lastAvailableQuest = 0;
		numAvailableQuests = GetNumAvailableQuests();
		numActiveQuests = GetNumActiveQuests();
		if numAvailableQuests > 0 or numActiveQuests > 0 then
			local guid = UnitGUID("target");
			if lastNPC ~= guid then
				lastActiveQuest = 1;
				lastAvailableQuest = 1;
				lastNPC = guid;
			end
			if (lastAvailableQuest > numAvailableQuests) then
				lastAvailableQuest = 1;
			end    
			for i = lastAvailableQuest, numAvailableQuests do
				lastAvailableQuest = i;
				if (AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoAccept"] == 1 and not IsControlKeyDown()) then
					SelectAvailableQuest(i);
				end
			end
		end
		if lastActiveQuest > numActiveQuests then
			lastActiveQuest = 1;
		end
		if (AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoHandIn"] == 1 and not IsControlKeyDown()) then
			local TempQList = {}
			local i = 1
			local UpdateQpart = 0
			while GetQuestLogTitle(i) do
				local questTitle, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(i)
				if (questID > 0) then
					if (not isHeader) then
						TempQList[questID] = {}
						if (isComplete) then
							TempQList[questID]["C"] = 1
						end
						TempQList[questID]["T"] = questTitle
					end
				end
				i = i + 1
			end
			local CLi
			for CLi = 1, numActiveQuests do
				for CL_index,CL_value in pairs(TempQList) do
					if (GetActiveTitle(CLi) == TempQList[CL_index]["T"] and TempQList[CL_index]["C"] and TempQList[CL_index]["C"] == 1) then
						SelectActiveQuest(CLi)
					end
				end
			end
		end
	end
	if (event=="ITEM_PUSH") then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if (AAP1["Debug"]) then
			print(arg2)
		end
		if (steps and 133717 == arg2 and steps["ExtraLine"] == 89) then		
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["UpdateQuest"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end
		if (steps and 134754 == arg2 and steps["ExtraLine"] == 81) then		
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["UpdateQuest"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end
		if (steps and 133798 == arg2 and steps["ExtraLine"] == 79) then		
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["UpdateQuest"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end
		if (steps and 132394 == arg2 and steps["ExtraLine"] == 67) then		
			AAP.BookingList["PrintQStep"] = 1
			C_Timer.After(1, AAP_BookQStep)
		end
		if (steps and 237425 == arg2 and steps["ExtraLine"] == 43) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["UpdateQuest"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end
		if (steps and 134241 == arg2 and steps["ExtraLine"] == 58) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["UpdateQuest"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end
		if (steps and 134241 == arg2 and steps["ExtraLine"] == 38) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["UpdateQuest"] = 1
		end
		AAP.BookingList["PrintQStep"] = 1
		C_Timer.After(1, AAP_BookQStep)
	end
	if (event=="MERCHANT_SHOW") then
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if (steps and steps["BuyMerchant"]) then
				if (not IsControlKeyDown() and AAP_BuyMerchFunc() == 0) then
					C_Timer.After(0.1,print(AAP_BuyMerchFunc()))
				end
		end
		if (AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoRepair"] == 1) then
			if (CanMerchantRepair()) then	
				repairAllCost, canRepair = GetRepairAllCost();
				if (canRepair and repairAllCost > 0) then
					guildRepairedItems = false
					if (IsInGuild() and CanGuildBankRepair()) then
						local amount = GetGuildBankWithdrawMoney()
						local guildBankMoney = GetGuildBankMoney()
						amount = amount == -1 and guildBankMoney or min(amount, guildBankMoney)
						if (amount >= repairAllCost) then
							RepairAllItems(true);
							guildRepairedItems = true
							DEFAULT_CHAT_FRAME:AddMessage("AAP: Equipment has been repaired by your Guild")
						end
					end
					if (repairAllCost <= GetMoney() and not guildRepairedItems) then
						RepairAllItems(false);
						print("AAP: Equipment has been repaired for "..GetCoinTextureString(repairAllCost))
					end
				end
			end
		end
		if (AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoVendor"] == 1) then
			local AAPtotal = 0
			for myBags = 0,4 do
				for bagSlots = 1, GetContainerNumSlots(myBags) do
					local CurrentItemLink = GetContainerItemLink(myBags, bagSlots)
					if CurrentItemLink then
						local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(CurrentItemLink)
						local _, itemCount = GetContainerItemInfo(myBags, bagSlots)
						if itemRarity == 0 and itemSellPrice ~= 0 then
							AAPtotal = AAPtotal + (itemSellPrice * itemCount)
							UseContainerItem(myBags, bagSlots)
						end
					end
				end
			end
			if AAPtotal ~= 0 then
				print("AAP: Items were sold for "..GetCoinTextureString(AAPtotal))
			end
		end
	end
	if (event=="UI_INFO_MESSAGE") then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		if (arg1 == 280) then
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			local steps
			if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
				steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			end
			if (steps and steps["GetFP"]) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			end
		end
	end
	if (event=="TAXIMAP_OPENED") then
	
	--local CLi
	--AAPHFiller4 = nil
	--AAPHFiller4 = {}
	--for CLi = 1, NumTaxiNodes() do
	--	local aapx,aapy = TaxiNodePosition(CLi)
	--	aapx = (floor(aapx * 1000)/10)
	--	aapy = (floor(aapy * 1000)/10)
	--	if (TaxiNodeGetType(CLi) == "REACHABLE") then
	--	AAPHFiller4["A"..CLi] = TaxiNodeName(CLi).."-X:"..aapx.."-Y:"..aapy
	--		print(CLi .. "-" .. TaxiNodeName(CLi).."-X:"..aapx.."-Y:"..aapy.." Status: "..TaxiNodeGetType(CLi))
	--	end
	--end
	
	
	
	
	
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if (steps and steps["GetFP"] and not IsControlKeyDown()) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["PrintQStep"] = 1
		end
		if (steps and not IsControlKeyDown()) then
			if (steps["UseFlightPath"]) then
				AAP.BookingList["UseTaxiFunc"] = 1
			end
		end
	end
	if (event=="UNIT_SPELLCAST_SUCCEEDED") then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		if (arg1 == "player" and arg3 == 85141) then
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			local steps
			if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
				steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			end
			if (steps and steps["ExtraLine"] and steps["ExtraLine"] == 55) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			end
		end
		--print(arg3)
		if (arg1 == "player" and arg3 == 82788) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["PrintQStep"] = 1
		end
		if ((arg1 == "player") and (arg3 == 8690)) then
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			local steps
			if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
				steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			end
			if (steps and steps["UseHS"]) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			end
		end
		if (arg1 == "player") then
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			local steps
			if (CurStep and AAP.QuestStepList and AAP.ActiveMap and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
				steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			end
			if (steps and steps["ButtonSpellId"]) then
				for AAP_index,AAP_value in pairs(steps["ButtonSpellId"]) do
					if (arg3 == AAP_index) then
						for AAP_index2,AAP_value2 in pairs(AAP.ButtonList) do
							if (AAP_index2 == AAP_value) then
								if (not AAP.BookingList["ButtonSpellidchk"]) then
									AAP.BookingList["ButtonSpellidchk"] = {}
								end
								AAP.BookingList["ButtonSpellidchk"][AAP_value2] = steps["Button"][AAP_value]
							end
						end
					end
				end
			end
		end
	end
	if (event=="UNIT_SPELLCAST_START") then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		if ((arg1 == "player") and (arg3 == 171253)) then
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			local steps
			if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
				steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			end
			if (steps and steps["UseGarrisonHS"]) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			end		
		end
		if ((arg1 == "player") and (arg3 == 222695)) then
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			local steps
			if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
				steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			end
			if (steps and steps["UseDalaHS"]) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			end
		end
	end
	if (event=="HEARTHSTONE_BOUND") then
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if (steps and steps["SetHS"]) then
			AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
			AAP.BookingList["PrintQStep"] = 1
		end
	end
	if (event=="QUEST_ACCEPTED") then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		if (AAP1["Debug"]) then
			print("QUEST_ACCEPTED: ".. arg2)
		end
		if (arg2 and arg2 > 0 and not AAP.ActiveQuests[arg2]) then
			AAP.BookingList["AddQuest"] = arg2
		end
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		if (CurStep and AAP.QuestStepList and AAP.ActiveMap and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
			local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			if (steps and steps["ZonePick"]) then
				AAP.BookingList["CheckZonePick"] = 1
			end
			if (steps and steps["LoaPick"] and steps["LoaPick"] == 123 and (AAP.ActiveQuests[47440] or AAP.ActiveQuests[47439])) then
				AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				AAP.BookingList["PrintQStep"] = 1
			end
		end
		C_Timer.After(3, AAP_BookQStep)
		if (AAP.HordeWQList and AAP.HordeWQList[arg2] and AAP.Faction == "Horde" and AAP.Level == 120 and AAP.WQActive == 0 and AAP1[AAP.Realm][AAP.Name]["Settings"]["WQs"] == 1) then
			AAP.WQFunc()
			AAP.BookingList["UpdateMapId"] = 1
			AAP.BookingList["PrintQStep"] = 1
		end
	end
	if (event=="QUEST_REMOVED") then
		if (AAP1["Debug"]) then
			print("QUEST_REMOVED")
		end
		local arg1, arg2, arg3, arg4, arg5 = ...;
		AAP.BookingList["RemoveQuest"] = arg1
		if (AAP.ActiveMap == arg1 and AAP1[AAP.Realm][AAP.Name]["Settings"]["WQs"] == 1) then
			AAP.WQFunc()
			AAP.BookingList["UpdateMapId"] = 1
			AAP.BookingList["PrintQStep"] = 1
			AAP1[AAP.Realm][AAP.Name][arg1] = nil
			AAP.RemoveMapIcons()
		end
	end
	if (event=="UNIT_QUEST_LOG_CHANGED") then
		local arg1, arg2, arg3, arg4, arg5 = ...;
		if (arg1 == "player" and Updateblock == 0) then
			Updateblock = 1
			C_Timer.After(0.3, AAP_UpdQuestThing)
		end
	end
	if (event=="PLAYER_EQUIPMENT_CHANGED") then
		AAP.BookingList["Heirloomscheck"] = 1
	end
	if (event=="ZONE_CHANGED") then
		QNumberLocal = 0
		C_Timer.After(2, AAP_UpdatezeMapId)
		C_Timer.After(3, AAP_ZoneResetQnumb)
	end
	if (event=="ZONE_CHANGED_NEW_AREA") then
		C_Timer.After(2, AAP_UpdatezeMapId)
	end
	if (event=="GOSSIP_SHOW") then
		if (UnitGUID("target") and string.find(UnitGUID("target"), "(.*)-(.*)")) then
			local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",UnitGUID("target"))
			if (UnitGUID("target") and string.find(UnitGUID("target"), "(.*)-(.*)")) then
				if (npc_id and ((tonumber(npc_id) == 141584) or (tonumber(npc_id) == 142063))) then
					return
				end
			end
		end
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		if (CurStep and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
			if (UnitGUID("target") and string.find(UnitGUID("target"), "(.*)-(.*)")) then
				local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",UnitGUID("target"))
				if (npc_id and ((tonumber(npc_id) == 141584) or (tonumber(npc_id) == 142063) or (tonumber(npc_id) == 45400) or (tonumber(npc_id) == 25809))) then
					local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
					if (steps and steps["Gossip"] and steps["Gossip"] == 27373) then
						SelectGossipOption(1)
						AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
						AAP.BookingList["PrintQStep"] = 1
					end
					return
				end
				if (npc_id and (tonumber(npc_id) == 43733) and (tonumber(npc_id) == 45312)) then
					Dismount()
				end
			end
			local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			local AAPDenied = 0
			if (steps and steps["DenyNPC"]) then
				if (UnitGUID("target") and UnitName("target")) then
					local guid, name = UnitGUID("target"), UnitName("target")
					local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",guid);
					if (npc_id and name) then
						if (tonumber(npc_id) == steps["DenyNPC"]) then
							AAPDenied = 1
						end
					end
				end
			end
			if (steps and steps["SpecialNoAutoHandin"]) then
				return
			end
			if (AAPDenied == 1) then
				CloseGossip()
				print("AAP: Not Yet!")
			elseif (steps and steps["Gossip"] and AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoGossip"] == 1 and not IsControlKeyDown()) then
				if (steps["Gossip"] == 99) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["PrintQStep"] = 1
				elseif (steps["Gossip"] == 39516) then
					if (UnitGUID("target") and UnitName("target")) then
						local guid, name = UnitGUID("target"), UnitName("target")
						local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",guid);
						if (npc_id and name and tonumber(npc_id) == 93127) then
							SelectGossipOption(2)
						else
							SelectGossipOption(1)
						end
					end
				elseif (steps["Gossip"] == 12255) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["PrintQStep"] = 1
				elseif (steps["Gossip"] == 38872) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["PrintQStep"] = 1
				elseif (steps["Gossip"] == 39456) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["PrintQStep"] = 1
				elseif (steps["Gossip"] == 39387) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["PrintQStep"] = 1
				elseif (steps["Gossip"] == 12097) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["PrintQStep"] = 1
				elseif (steps["Gossip"] == 11984) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["PrintQStep"] = 1
				elseif (steps["Gossip"] == 26773) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				elseif (steps["Gossip"] == 26359) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
				elseif (steps["Gossip"] == 26301) then
					SelectGossipOption(2)
				elseif (steps["Gossip"] == 999) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["PrintQStep"] = 1
				elseif (steps["Gossip"] == 101) then
					SelectGossipOption(1)
					AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
					AAP.BookingList["PrintQStep"] = 1
				else
					SelectGossipOption(steps["Gossip"])
					if (steps["ExtraLine"] == 39) then
						AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap] + 1
						AAP.BookingList["PrintQStep"] = 1
					end
				end
			end
		end
		local arg1, arg2, arg3, arg4 = ...;
		local ActiveQuests = {GetGossipActiveQuests()}
		local ActiveQNr = GetNumGossipActiveQuests()
		local CLi
		local NumAvailableQuests = GetNumGossipAvailableQuests()
		local AvailableQuests = {GetGossipAvailableQuests()}
		if (ActiveQuests and AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoHandIn"] == 1 and not IsControlKeyDown()) then
			for CLi = 1, ActiveQNr do
				if (ActiveQuests[(((CLi-1) * 6)+4)] == true) then
					SelectGossipActiveQuest(CLi)
				end
			end
		end
		if (NumAvailableQuests > 0 and AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoAccept"] == 1 and not IsControlKeyDown()) then
			if (steps and steps["SpecialPickupOrder"]) then
				SelectGossipAvailableQuest(2)
			else
				SelectGossipAvailableQuest(1)
			end
		end
	end
	if (event=="QUEST_DETAIL") then
		if (UnitGUID("target") and string.find(UnitGUID("target"), "(.*)-(.*)")) then
			local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",UnitGUID("target"))
			if (npc_id and ((tonumber(npc_id) == 141584) or (tonumber(npc_id) == 142063) or (tonumber(npc_id) == 45400))) then
				return
			end
			if (npc_id and (tonumber(npc_id) == 43733)) then
				Dismount()
			end
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			if (CurStep and AAP.ActiveMap and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
				local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
				local AAPDenied = 0
				if (steps and steps["DenyNPC"]) then
					if (UnitGUID("target") and UnitName("target")) then
						local guid, name = UnitGUID("target"), UnitName("target")
						local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",guid);
						if (npc_id and name) then
							if (tonumber(npc_id) == steps["DenyNPC"]) then
								AAPDenied = 1
							end
						end
					end
				end
				if (AAPDenied == 1) then
					CloseQuest()
					print("AAP: Not Yet!")
				end
			end
		end
		if (GetQuestID() and (AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoAccept"] == 1) and (not IsControlKeyDown()) and (GetQuestID() ~= 50476) and (GetQuestID() ~= 52058) and (53372 ~= GetQuestID()) and (52946 ~= GetQuestID())) then
			if (27406 == GetQuestID()) then
				Dismount()
			end
			if (QuestGetAutoAccept()) then
				CloseQuest()
			else
				QuestInfoDescriptionText:SetAlphaGradient(0, -1)
				QuestInfoDescriptionText:SetAlpha(1)
				AAP.BookingList["AcceptQuest"] = 1
			end
		end
	end
	if (event=="QUEST_PROGRESS") then
		if (AAP1["Debug"]) then
			print("QUEST_PROGRESS")
		end
		if (UnitGUID("target") and string.find(UnitGUID("target"), "(.*)-(.*)")) then
			local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",UnitGUID("target"))
			if (npc_id and ((tonumber(npc_id) == 141584) or (tonumber(npc_id) == 142063) or (tonumber(npc_id) == 45400))) then
				return
			end
		end
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		local steps
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
			steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
		end
		if (AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoHandIn"] == 1 and not IsControlKeyDown()) then
			if (steps and steps["SpecialNoAutoHandin"]) then
				return
			end
			AAP.BookingList["CompleteQuest"] = 1
			if (AAP1["Debug"]) then
				print("Complete")
			end
		end
	end
	if (event=="QUEST_COMPLETE") then
		if (UnitGUID("target") and string.find(UnitGUID("target"), "(.*)-(.*)")) then
			local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",UnitGUID("target"))
			if (npc_id and ((tonumber(npc_id) == 141584) or (tonumber(npc_id) == 142063) or (tonumber(npc_id) == 45400))) then
				return
			end
		end
		if (GetNumQuestChoices() > 1) then
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoHandInChoice"] == 1) then
				local AAP_GearIlvlList = {}
				for slots2 = 0,18 do
					if (GetInventoryItemLink("player", slots2)) then
						local _, _, itemRarity, itemLevel, _, _, _, _, SpotName = GetItemInfo(GetInventoryItemLink("player", slots2))
						if (itemRarity == 7) then
							itemLevel = GetDetailedItemLevelInfo(GetInventoryItemLink("player", slots2))
						end
						if (SpotName and itemLevel) then
							if (SpotName == "INVTYPE_WEAPONOFFHAND") then
								SpotName = "INVTYPE_WEAPON"
							end
							if (SpotName == "INVTYPE_WEAPONMAINHAND") then
								SpotName = "INVTYPE_WEAPON"
							end
							if (AAP_GearIlvlList[SpotName]) then
								if (AAP_GearIlvlList[SpotName] > itemLevel) then
									AAP_GearIlvlList[SpotName] = itemLevel
								end
							else
								AAP_GearIlvlList[SpotName] = itemLevel
							end
						end
					end
				end
				local AAPTempGearList = {}
				local isweaponz = 0
				local AAPColorof = 0
				for h=1, GetNumQuestChoices() do
					local _, _, ItemRarityz, _, _, _, _, _, SpotName = GetItemInfo(GetQuestItemLink("choice", h))
					local ilvl = GetDetailedItemLevelInfo(GetQuestItemLink("choice", h))
					if (AAP_GearIlvlList[SpotName]) then
						if (ItemRarityz > 2) then
							AAPColorof = ItemRarityz
						end
						AAPTempGearList[h] = ilvl - AAP_GearIlvlList[SpotName]
						--print("Qilvl: "..ItemRarityz.." - "..SpotName.." - MySpot: "..AAP_GearIlvlList[SpotName])
						if (SpotName == "INVTYPE_WEAPON" or SpotName == "INVTYPE_SHIELD" or SpotName == "INVTYPE_2HWEAPON" or SpotName == "INVTYPE_WEAPONMAINHAND" or SpotName == "INVTYPE_WEAPONOFFHAND" or SpotName == "INVTYPE_HOLDABLE" or SpotName == "INVTYPE_RANGED" or SpotName == "INVTYPE_THROWN" or SpotName == "INVTYPE_RANGEDRIGHT" or SpotName == "INVTYPE_RELIC") then
							isweaponz = 1
						end
					end
				end
				if (AAPColorof > 2) then
				elseif (isweaponz == 1) then

				else
					local PickOne = 0
					local PickOne2 = -99999
					for AAP_indexx,AAP_valuex in pairs(AAPTempGearList) do
						if (AAP_valuex > PickOne2) then
							PickOne = AAP_indexx
							PickOne2 = AAP_valuex
						end
					end
					if (PickOne > 0) then
						GetQuestReward(PickOne)
						--print("picked: "..PickOne)
					end
				end
			end
		else
			local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
			local steps
			if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap]) then
				steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			end
			if (AAP1[AAP.Realm][AAP.Name]["Settings"]["AutoHandIn"] == 1 and not IsControlKeyDown()) then
				if (steps and steps["SpecialNoAutoHandin"]) then
					return
				end
				if (UnitGUID("target") and string.find(UnitGUID("target"), "(.*)-(.*)")) then
					local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",UnitGUID("target"))
					if (npc_id and ((tonumber(npc_id) == 141584) or (tonumber(npc_id) == 142063) or (tonumber(npc_id) == 45400) or (tonumber(npc_id) == 25809))) then
						return
					end
				end
				GetQuestReward(1)
			end
		end
	end
	if (event=="UPDATE_MOUSEOVER_UNIT") then
		local CurStep = AAP1[AAP.Realm][AAP.Name][AAP.ActiveMap]
		if (CurStep and AAP.QuestStepList and AAP.QuestStepList[AAP.ActiveMap] and AAP.QuestStepList[AAP.ActiveMap][CurStep]) then
			local steps = AAP.QuestStepList[AAP.ActiveMap][CurStep]
			if (steps and steps["RaidIcon"]) then
				local guid = UnitGUID("mouseover")
				if (guid) then
					local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",guid)
					if (npc_id and tonumber(steps["RaidIcon"]) == tonumber(npc_id)) then
						if (not GetRaidTargetIndex("mouseover")) then
							SetRaidTarget("mouseover",8)
						end
					end
				end
			elseif (steps and steps["DroppableQuest"]) then
				if (UnitGUID("mouseover") and UnitName("mouseover")) then
					local guid, name = UnitGUID("mouseover"), UnitName("mouseover")
					local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",guid);
					if (type == "Creature" and npc_id and name and steps["DroppableQuest"]["MobId"] == tonumber(npc_id)) then
						if (AAP.NPCList and not AAP.NPCList[tonumber(npc_id)]) then
							AAP.NPCList[tonumber(npc_id)] = name

						end
					end
				end
			end
		end
	end
end)