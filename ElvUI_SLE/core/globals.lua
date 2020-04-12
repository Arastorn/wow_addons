local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local format = format

--Chat icon paths--
local slePath = [[|TInterface\AddOns\ElvUI_SLE\media\textures\]]
local blizzPath = [[|TInterface\ICONS\]]
local repooc = slePath..[[SLE_Chat_Logo:12:24|t ]]
local darth = slePath..[[SLE_Chat_Logo:12:24|t ]]
local friend = slePath..[[Chat_Friend:16:16|t ]]
local test = slePath..[[Chat_Test:16:16|t ]]
local blizzicon = blizzPath..[[%s:12:12:0:0:64:64:4:60:4:60|t]]
-- local rpg = slePath..[[Chat_RPG:13:35|t]]

local orc = blizzPath..[[Achievement_Character_Orc_Male:16:16|t ]]
--local coppericon = [[|TInterface\MONEYFRAME\UI-CopperIcon:12:12|t]]
local silvericon = [[|TInterface\MONEYFRAME\UI-SilverIcon:12:12|t]]
local goldicon = [[|TInterface\MONEYFRAME\UI-GoldIcon:12:12|t]]

SLE.ArmoryConfigBackgroundValues = {
	BackgroundValues = {
		["HIDE"] = HIDE,
		["CUSTOM"] = CUSTOM,
		["Space"] = "Space",
		["TheEmpire"] = "The Empire",
		["Castle"] = "Castle",
		["Alliance-text"] = FACTION_ALLIANCE,
		["Horde-text"] = FACTION_HORDE,
		["Alliance-bliz"] = FACTION_ALLIANCE.." 2",
		["Horde-bliz"] = FACTION_HORDE.." 2",
		["Arena-bliz"] = ARENA,
		["CLASS"] = CLASS,
	},
	BlizzardBackdropList = {
		["Alliance-bliz"] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Alliance]],
		["Horde-bliz"] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Horde]],
		["Arena-bliz"] = [[Interface\PVPFrame\PvpBg-NagrandArena-ToastBG]]
	},
}

local classTable = {
	deathknight = blizzPath..[[ClassIcon_DeathKnight:16:16|t ]],
	demonhunter = blizzPath..[[ClassIcon_DemonHunter:16:16|t ]],
	druid = blizzPath..[[ClassIcon_Druid:16:16|t ]],
	hunter = blizzPath..[[ClassIcon_Hunter:16:16|t ]],
	mage = blizzPath..[[ClassIcon_Mage:16:16|t ]],
	monk = blizzPath..[[ClassIcon_Monk:16:16|t ]],
	paladin = blizzPath..[[ClassIcon_Paladin:16:16|t ]],
	priest = blizzPath..[[ClassIcon_Priest:16:16|t ]],
	rogue = blizzPath..[[ClassIcon_Rogue:16:16|t ]],
	shaman = blizzPath..[[ClassIcon_Shaman:16:16|t ]],
	warlock = blizzPath..[[ClassIcon_Warlock:16:16|t ]],
	warrior = blizzPath..[[ClassIcon_Warrior:16:16|t ]],
}

--Role icons
SLE.rolePaths = {
	["ElvUI"] = {
		TANK = [[Interface\AddOns\ElvUI\media\textures\tank]],
		HEALER = [[Interface\AddOns\ElvUI\media\textures\healer]],
		DAMAGER = [[Interface\AddOns\ElvUI\media\textures\dps]]
	},
	["SupervillainUI"] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\svui-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\svui-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\svui-dps]]
	},
	["Blizzard"] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\blizz-dps]]
	},
	["MiirGui"] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\mg-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\mg-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\mg-dps]]
	},
	["Lyn"] = {
		TANK = [[Interface\AddOns\ElvUI_SLE\media\textures\role\lyn-tank]],
		HEALER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\lyn-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_SLE\media\textures\role\lyn-dps]]
	},
}

--Epty Tables
SLE.Configs = {}

--Variables
SLE.region = false

--Toonlists
SLE.SpecialChatIcons = {
	["EU"] = {
		["DarkmoonFaire"] = {
			["Shaylith"] = darth,
			["Yandria"] = darth,
			["Ardon"] = darth,
			["Lelora"] = darth,
			["Illia"] = darth,
			["Jumahko"] = darth,
			["Jilti"] = darth,
			["Hweiru"] = darth,
			["Maggas"] = darth,
			["Faanna"] = darth,
			["Naliss"] = darth,
			["Ahkara"] = darth,
		},
		["TheSha'tar"] = {
			["Lelora"] = darth,
			["Alamira"] = darth,
		},
		["ВечнаяПесня"] = {
			--Darth's toons
			["Дартпредатор"] = darth,
			["Алея"] = darth,
			["Ваззули"] = darth,
			["Сиаранна"] = darth,
			["Джатон"] = darth,
			["Фикстер"] = darth,
			["Киландра"] = darth,
			["Нарджо"] = darth,
			["Келинира"] = darth,
			["Крениг"] = darth,
			["Мейжи"] = darth,
			["Тисандри"] = darth,
			["Мемри"] = darth,
			--Darth's friends
			["Леани"] = friend,
			["Кайрия"] = friend,
			["Дендрин"] = friend,
			["Аргрут"] = friend,
			--Da tester lol
			["Харореанн"] = test,
			["Нерререанн"] = test,
			["Аргусил"] = orc
		},
		["Пиратскаябухта"] = {
			["Брэгари"] = test
		},
		["Ревущийфьорд"] = {
			["Рыжая"] = friend,
			["Рыжа"] = friend,
			["Шензо"] = classTable.hunter,
			--Some people
			["Маразм"] = classTable.shaman,
			["Брэгар"] = test
		},
		["ЧерныйШрам"] = {
			["Емалия"] = friend,
		},
	},
	["US"] = {
		["Andorhal"] = {
			["Dapooc"] = repooc,
			["Rovert"] = repooc,
			["Sliceoflife"] = repooc
		},
		["Illidan"] = {
			--Darth's toon
			["Darthpred"] = darth,
			--Repooc's Toon
			["Repooc"] = repooc,
		},
		["Spirestone"] = {
			["Sifupooc"] = repooc,
			["Dapooc"] = repooc,
			["Lapooc"] = repooc,
			["Warpooc"] = repooc,
			["Repooc"] = repooc,
			["Cursewordz"] = repooc
		},
		["Stormrage"] = {
			["Sifpooc"] = repooc,
			["Urgfelstorm"] = blizzicon:format("inv_misc_bomb_02"),
			["Vaxum"] = goldicon,
			["Lloosh"] = silvericon --Patreon & Repooc's Guild Mate
		},
		["WyrmrestAccord"] = {
			["Dapooc"] = repooc,
		},
	},
	["CN"] = {},
	["KR"] = {},
	["TW"] = {},
	["PTR"] = {
		["Brill(EU)"] = {
			["Дартпредатор"] = darth,
			["Киландра"] = darth,
		},
	},
}
