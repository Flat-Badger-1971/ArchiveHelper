--- @meta

LFM = {}
LibAddonMenu2 = {}
LibChatMessage = {}
LibFBCommon = {}
LibGroupBroadcast = {}
LibInfiniteArchive = {}
LibSavedVars = {}
pChat = {}
ACHIEVEMENTS_MANAGER = {}
BOSS_BAR = {}
CENTER_SCREEN_ANNOUNCE = {}
COMPASS = {}
ENDLESS_DUNGEON_MANAGER = {}
SHARED_INVENTORY = {}

ACTION_RESULT_DIED = 2260
ACTION_RESULT_DIED_XP = 2262
ACTION_TYPE_ABILITY = 1
ARCHIVEHELPER_FAVOURITES_LIST = {}
ARCHIVEHELPER_IGNORE_LIST = {}
ARCHIVEHELPER_WEREWOLF_BEHEMOTH = 0
BAG_WORN = 0
BUFF_EFFECT_TYPE_BUFF = 1
CSA_CATEGORY_MAJOR_TEXT = 5
CENTER_SCREEN_ANNOUNCE_TYPE_SYSTEM_BROADCAST = 63
CHAT_CHANNEL_SAY = 0
CHAT_CHANNEL_PARTY = 3
COMBAT_UNIT_TYPE_PLAYER = 1
ENDLESS_DUNGEON_BUFF_BUCKET_TYPE_ITERATION_BEGIN = 1
ENDLESS_DUNGEON_BUFF_BUCKET_TYPE_ITERATION_END = 3
ENDLESS_DUNGEON_BUFF_TYPE_VERSE = 1
ENDLESS_DUNGEON_BUFF_TYPE_VISION = 2
ENDLESS_DUNGEON_GROUP_TYPE_SOLO = 0
EQUIP_SLOT_RING1 = 11
EQUIP_SLOT_RING2 = 12
HOTBAR_CATEGORY_PRIMARY = 0
HOTBAR_CATEGORY_BACKUP = 1
HOTBAR_CATEGORY_TEMPORARY = 9
LIBINFINITEARCHIVE_AUDITOR_NAME = 0
LIBINFINITEARCHIVE_TOMESHELL = 0
LINK_STYLE_BRACKETS = 1
MAP_PIN_TYPE_QUEST_INTERACT = 8
MAX_PET_UNIT_TAGS = 7
POWERTYPE_HEALTH = -2
REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE = 13
RESURRECT_RESULT_SUCCESS = 5
SI_ABILITY_TOOLTIP_DURATION_LABEL = ""
SI_BINDING_NAME_TOGGLE_NOTIFICATIONS = ""
SI_COLLECTIBLE_ACTION_ADD_FAVORITE = ""
SI_COLLECTIBLE_ACTION_REMOVE_FAVORITE = ""
SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER = ""
SI_ENDLESS_DUNGEON_SUMMARY_VERSES_HEADER = ""
SI_ENDLESS_DUNGEON_SUMMARY_VISIONS_HEADER = ""
SI_ENDLESS_DUNGEON_SUMMARY_AVATAR_VISIONS_HEADER = ""
SI_ENDLESSDUNGEONBUFFBUCKETTYPE0 = ""
SI_ENDLESSDUNGEONBUFFBUCKETTYPE1 = ""
SI_ENDLESSDUNGEONBUFFBUCKETTYPE2 = ""
SI_ENDLESSDUNGEONBUFFTYPE1 = ""
SI_ENDLESSDUNGEONBUFFTYPE2 = ""
SI_INTERFACE_OPTIONS_INDICATORS = ""
SI_INTERFACE_OPTIONS_NAMEPLATES_TARGET_MARKERS = ""
SI_ITEMFILTERTYPE5 = ""
SI_UNIT_NAME = ""
SI_ZONECOMPLETIONTYPE3 = ""
SKILL_TYPE_AVA = 6
SKILL_TYPE_CLASS = 1
SKILL_TYPE_GUILD = 5
SKILL_TYPE_WORLD = 4
TARGET_MARKER_TYPE_NONE = 0
TARGET_MARKER_TYPE_ONE = 1
TARGET_MARKER_TYPE_TWO = 2
TARGET_MARKER_TYPE_THREE = 3
TARGET_MARKER_TYPE_FOUR = 4
TARGET_MARKER_TYPE_FIVE = 5
TARGET_MARKER_TYPE_SIX = 6
TARGET_MARKER_TYPE_SEVEN = 7
TARGET_MARKER_TYPE_EIGHT = 8

ZO_ACHIEVEMENTS_COMPLETION_STATUS = {
    COMPLETE = 1
}


---@param eventKey number
---@param ... unknown
function ZO_ChatEvent(eventKey, ...) end

---@param control userdata
---@param side number
---@param ... unknown
function ZO_Tooltips_ShowTextTooltip(control, side, ...) end

function ZO_Tooltips_HideTextTooltip() end

--- @alias EndlessDungeonGroupType integer



ARCHIVEHELPER_ADD_AVOID = 1
ARCHIVEHELPER_ALL_BOTH = 1
ARCHIVEHELPER_ALL_VISIONS = 1
ARCHIVEHELPER_ALL_VERSES = 1
ARCHIVEHELPER_ARC_BOSS = 1
ARCHIVEHELPER_AUDITOR = 1
ARCHIVEHELPER_AUDITOR_NAME = 1
ARCHIVEHELPER_AVOID = 1
ARCHIVEHELPER_BONUS = 1
ARCHIVEHELPER_BUFF_SELECTED = 1
ARCHIVEHELPER_COUNT = 1
ARCHIVEHELPER_CROSSING_END = 1
ARCHIVEHELPER_CROSSING_KEY = 1
ARCHIVEHELPER_CROSSING_INVALID = 1
ARCHIVEHELPER_CROSSING_FAIL = 1
ARCHIVEHELPER_CROSSING_NO_SOLUTIONS = 1
ARCHIVEHELPER_CROSSING_PATHS = 1
ARCHIVEHELPER_CROSSING_SLASH = 1
ARCHIVEHELPER_CROSSING_START = 1
ARCHIVEHELPER_CROSSING_SUCCESS = 1
ARCHIVEHELPER_CROSSING_TITLE = 1
ARCHIVEHELPER_CROSSING_INSTRUCTIONS = 1
ARCHIVEHELPER_CYCLE_BOSS = 1
ARCHIVEHELPER_DEN_TIMER = 1
ARCHIVEHELPER_FABLED = 1
ARCHIVEHELPER_FABLED_MARKER = 1
ARCHIVEHELPER_FABLED_TOOLTIP = 1
ARCHIVEHELPER_FLAMESHAPER = 1
ARCHIVEHELPER_GW = 1
ARCHIVEHELPER_GW_MARKER = 1
ARCHIVEHELPER_GW_PLAY = 1
ARCHIVEHELPER_HERD = 1
ARCHIVEHELPER_HERD_FAIL = 1
ARCHIVEHELPER_HERD_SUCCESS = 1
ARCHIVEHELPER_MARAUDER_MARKER = 1
ARCHIVEHELPER_MARAUDER_INCOMING_PLAY = 1
ARCHIVEHELPER_OPTIONAL_LIBS_CHAT = 1
ARCHIVEHELPER_OPTIONAL_LIBS_SHARE = 1
ARCHIVEHELPER_PREVENT = 1
ARCHIVEHELPER_PREVENT_TOOLTIP = 1
ARCHIVEHELPER_PROGRESS = 1
ARCHIVEHELPER_PROGRESS_ACHIEVEMENT = 1
ARCHIVEHELPER_PROGRESS_CHAT = 1
ARCHIVEHELPER_PROGRESS_SCREEN = 1
ARCHIVEHELPER_RANDOM = 1
ARCHIVEHELPER_REMINDER = 1
ARCHIVEHELPER_REMINDER_QUEST = 1
ARCHIVEHELPER_REMINDER_QUEST_TEXT = 1
ARCHIVEHELPER_REMINDER_TOOLTIP = 1
ARCHIVEHELPER_REMOVE_AVOID = 1
ARCHIVEHELPER_REQUIRES = 1
ARCHIVEHELPER_SECONDS = 1
ARCHIVEHELPER_SHARD = 1
ARCHIVEHELPER_SHARD_IGNORE = 1
ARCHIVEHELPER_SHARD_MARKER = 1
ARCHIVEHELPER_SHOW_COUNT = 1
ARCHIVEHELPER_SHOW_CROSSING_HELPER = 1
ARCHIVEHELPER_SHOW_COUNT_TOOLTIP = 1
ARCHIVEHELPER_SHOW_ECHO = 1
ARCHIVEHELPER_SHOW_SELECTION = 1
ARCHIVEHELPER_SHOW_SELECTION_DISPLAY_NAME = 1
ARCHIVEHELPER_SHOW_SELECTION_DISPLAY_NAME_TOOLTIP = 1
ARCHIVEHELPER_SHOW_TERRAIN_WARNING = 1
ARCHIVEHELPER_SHOW_TERRAIN_WARNING_TOOLTIP = 1
ARCHIVEHELPER_SHOW_THEATRE_WARNING = 1
ARCHIVEHELPER_SLASH_MISSING = 1
ARCHIVEHELPER_STACKS = 1
ARCHIVEHELPER_TOMESHELL = 1
ARCHIVEHELPER_TOMESHELL_COUNT = 1
ARCHIVEHELPER_USE_AUTO_AVOID = 1
ARCHIVEHELPER_USE_AUTO_AVOID_TOOLTIP = 1
ARCHIVEHELPER_WARNING = 1
ARCHIVEHELPER_WEREWOLF_BEHEMOTH = 1
ARCHIVEHELPER_SI_BINDING_NAME_ARCHIVEHELPER_MARK_CURRENT_TARGET = 1
ARCHIVEHELPER_SI_BINDING_NAME_ARCHIVEHELPER_TOGGLE_CROSSING_HELPER = 1
ARCHIVEHELPER_SI_BINDING_NAME_ARCHIVEHELPER_UNMARK_CURRENT_TARGET = 1
ARCHIVEHELPER_MARAUDER_GOTHMAU = 1
ARCHIVEHELPER_MARAUDER_HILKARAX = 1
ARCHIVEHELPER_MARAUDER_ULMOR = 1
ARCHIVEHELPER_MARAUDER_BITTOG = 1
ARCHIVEHELPER_MARAUDER_ZULFIMBUL = 1
ARCHIVEHELPER_MAP_TREACHEROUS_CROSSING = 1
ARCHIVEHELPER_MAP_HAEFELS_BUTCHERY = 1
ARCHIVEHELPER_MAP_FILERS_WING = 1
ARCHIVEHELPER_MAP_ECHOING_DEN = 1
ARCHIVEHELPER_MAP_THEATRE_OF_WAR = 1
ARCHIVEHELPER_MAP_DESTOZUNOS_LIBRARY = 1


GAMEPLAY_ACTOR_CATEGORY_PLAYER = 0
