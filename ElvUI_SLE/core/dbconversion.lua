local SLE, T, E, L, V, P, G = unpack(select(2, ...))

--GLOBALS: ElvDB, ElvPrivateDB
local SLE_Test = false

local ProfileNames = NONE
local CharacterNames = NONE


--Convers all the things!
function SLE:DatabaseConversions()
	if ElvDB.SLE_DB_Ver == SLE.DBversion and not SLE_Test then return end --Only execute all this shit when current database is actually outdated.
	--Profile options conversion
	for profile, data in T.pairs(ElvDB.profiles) do
		-- if profile ~= "Minimalistic" then
		-- print(profile)
		-- end
		local profileChanged = false
		if data then
			if data.sle then
				if data.sle.Armory then data.sle.Armory = nil; profileChanged = true end
				if data.sle.minimap and data.sle.minimap.locPanel then
					if data.sle.minimap.portals then
						if T.type(data.sle.minimap.locPanel.portals.hsPrio) == "table" then
							data.sle.minimap.locPanel.portals.hsPrio = P.sle.minimap.locPanel.portals.hsPrio
							profileChanged = true
						end
					elseif data.sle.minimap.locPanel.portals and data.sle.minimap.locPanel.portals.hsPrio then
						local CurrentDefault = P.sle.minimap.locPanel.portals.hsPrio
						local CurrentSettings = data.sle.minimap.locPanel.portals.hsPrio
						for hs in CurrentDefault:gmatch("%d+") do
							if not CurrentSettings:match(hs) then CurrentSettings = CurrentSettings .. "," .. hs; profileChanged = true end
						end
					end
				end
				if data.sle.datatexts then
					if data.sle.datatexts.rightchat then
						if data.sle.datatexts.rightchat.noborders then data.sle.datatexts.rightchat.noborders = nil; profileChanged = true end
					end
					if data.sle.datatexts.leftchat then
						if data.sle.datatexts.leftchat.noborders then data.sle.datatexts.leftchat.noborders = nil; profileChanged = true end
					end
				end
				if profileChanged then
					if ProfileNames == NONE then
						ProfileNames = profile
					else
						ProfileNames = ProfileNames..", "..profile
					end
				end
			end
		end
	end
	--Private options convert
	for private, data in T.pairs(ElvPrivateDB.profiles) do
		local privateChanged = false
		if data then
			if data.sle then
				if data.sle.module then
					if data.sle.module.blizzmove then
						if not data.sle.module.blizzmove.points then data.sle.module.blizzmove.points = {} end
						if data.sle.module.blizzmove and T.type(data.sle.module.blizzmove) == "boolean" then data.sle.module.blizzmove = V.sle.module.blizzmove; privateChanged = true; end --Ancient setting conversions
						if not data.sle.pvpreadydialogreset then data.sle.module.blizzmove.points["PVPReadyDialog"] = nil; data.sle.pvpreadydialogreset = true; privateChanged = true; end
						if data.sle.module.blizzmove.points["CalendarViewEventFrame"] then data.sle.module.blizzmove.points["CalendarViewEventFrame"] = nil; privateChanged = true; end
						if data.sle.module.blizzmove.points["CalendarViewHolidayFrame"] then data.sle.module.blizzmove.points["CalendarViewHolidayFrame"] = nil; privateChanged = true; end
						--Remove these from saved variables so the script will not attempt to mess with them, cause they are not ment to be moved permanently
						if data.sle.module.blizzmove.points["BonusRollFrame"] then data.sle.module.blizzmove.points["BonusRollFrame"] = nil; privateChanged = true; end
						if data.sle.module.blizzmove.points["BonusRollLootWonFrame"] then data.sle.module.blizzmove.points["BonusRollLootWonFrame"] = nil; privateChanged = true; end
						if data.sle.module.blizzmove.points["BonusRollMoneyWonFrame"] then data.sle.module.blizzmove.points["BonusRollMoneyWonFrame"] = nil; privateChanged = true; end
					end
				end
				if privateChanged then
					if CharacterNames == NONE then
						CharacterNames = private
					else
						CharacterNames = CharacterNames..", "..private
					end
				end
			end
		end
	end
	--Global settions converted
	local golbals = ElvDB.global
	if globals then
		if globals.sle then
			if globals.sle.pvpreadydialogreset then globals.sle.pvpreadydialogreset = nil; end
		end
	end

	if not SLE_Test then ElvDB.SLE_DB_Ver = SLE.DBversion end
	E:StaticPopup_Show("SLE_CONVERSION_COMPLETE", ProfileNames, CharacterNames)
end
