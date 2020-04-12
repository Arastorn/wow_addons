local LA = select(2, ...)

local Session = {}
LA.Session = Session

local private = {
    currentSession = nil,

    pauseStart = nil,
    sessionPause = 0,

    sessionIsRunning = false,
}


-- wow api
local GetBestMapForUnit, GetUnitName, GetRealmName, GetMapInfo =
C_Map.GetBestMapForUnit, GetUnitName, GetRealmName, C_Map.GetMapInfo

-- lua api
local time, tonumber =
time, tonumber


function Session.New()
    LA.Debug.Log("NewSession")

    -- reset all values
    private.PrepareNewSession()

    LA.UI.ClearLootCollectedList()
    LA.UI.ClearLastNoteworthyItemUI()

    LA.UI.RefreshUIs()
end

-- pause session (pause and refresh ui)
function Session.Pause()
    LA.Debug.Log("pauseSession")

    private.pauseStart = time()

    -- ui refresh
    LA.UI.RefreshUIs()
end

-- restart session (add pause to sessionPause and refresh ui)
function Session.Restart()
    LA.Debug.Log("restartSession")

    -- calc pause add add to sessionPause
    private.sessionPause = private.sessionPause + (time() - private.pauseStart)
    private.pauseStart = nil

    -- ui refresh
    LA.UI.RefreshUIs()
end

function Session.IsRunning()
    return private.sessionIsRunning --and private.pauseStart == nil
end

function Session.IsPaused()
    return private.pauseStart ~= nil
end

-- start a new session
function Session.Start(showMainUI)
--    LA.SetLootAppraiserDisabled(false)

    if not Session.IsRunning() then
        LA:Print("Start Session")

        local zoneInfo = GetMapInfo(GetBestMapForUnit("player"))
        zoneInfo = zoneInfo and zoneInfo.name
        LA.Debug.Log("  mapID=%s (%s)", GetBestMapForUnit("player"), zoneInfo)

        private.sessionIsRunning = true

        private.PrepareNewSession()

        -- show main window
        LA.UI.ShowMainWindow(showMainUI)
    end
end

function Session.GetPauseStart()
    return private.pauseStart
end

function Session.GetSessionPause()
    return private.sessionPause
end

function Session.GetCurrentSession(key)
    if not key then
        return private.currentSession
    end
    return private.currentSession[key]
end

function Session.SetCurrentSession(key, value)
    private.currentSession[key] = value
end

function private.PrepareNewSession()
    LA.Debug.Log("prepareNewSession")
    --    LA.Debug.Log("  savedLoot: %s items", LA.Util.tablelength(private.savedLoot))
    local resetLIV = 0
	LA.UI.UpdateLiteWindowUI(resetLIV)	--pass to Update Lite Window to reset session and make value zero

    -- start: prepare session
    private.currentSession = {
        start = time(),
        mapID = GetBestMapForUnit("player"),
        settings = {
            qualityFilter = tonumber(LA.GetFromDb("general", "qualityFilter")),
            gat = tonumber(LA.GetFromDb("general", "goldAlertThreshold")),
            priceSource = LA.GetFromDb("pricesource", "source")
        },
        noteworthyItems = {},
        liv = 0,
        livGroup = 0,
        player = GetUnitName("player", true) .. "-" .. GetRealmName()
    }
	LA.UI.UpdateLiteWindowUI(liv)

    private.sessionPause = 0
    private.pauseStart = nil

    private.sessionIsRunning = true
    -- end: prepare session (for statistics)
end