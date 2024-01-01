_G.ArchiveHelper = {
    Defaults = {
        AvatarVisionCount = {IRON = 0, WOLF = 0, ICE = 0},
        CheckQuestItems = true,
        EchoingDenTimer = 60,
        FabledCheck = true,
        Favourites = {},
        MarauderCheck = true,
        MarauderPlay = true,
        MarkAchievements = true,
        MarkAvatar = true,
        MarkFavourites = true,
        Notify = true,
        NotifyChat = true,
        NotifyScreen = true,
        ShardCheck = true,
        ShowNotice = true,
        ShowStacks = true,
        ShowTimer = true
    },
    Name = "ArchiveHelper",
    LF = string.char(10),
    ICONS = {
        ACH = {name = "login/login_icon_yield", colour = {1, 0, 0, 1}},
        FAV = {name = "campaign/overview_indexicon_bonus_down", colour = {0, 1, 0, 1}},
        IRON = {name = "icons/achievement_u40_ed2_iron_atronach", colour = {1, 1, 1, 1}},
        WOLF = {name = "icons/achievement_u40_ed2_werewolf_behemoth", colour = {1, 1, 1, 1}},
        ICE = {name = "icons/achievement_u40_ed2_ice_avatar", colour = {1, 1, 1, 1}}
    },
    MAPS = {
        TREACHEROUS_CROSSING = {id = 2420, name = "Treacherous Crossing"},
        HAEFELS_BUTCHERY = {id = 2421, name = "Haefel's Butchery"},
        FILERS_WING = {id = 2422, name = "Filer's Wing"},
        ECHOING_DEN = {id = 2423, name = "Echoing Den"},
        THEATRE_OF_WAR = {id = 2424, name = "Theatre of War"},
        DESTOZUNOS_LIBRARY = {id = 2425, name = "Destozuno's Library"}
    },
    InEchoingDen = false,
    Marauders = {"gothmau", "hilkarax", "ulmor"},
    ArchiveIndex = 2407,
    FoundQuestItem = false,
    ArchiveQuests = {GetQuestName(7091), GetQuestName(7101), GetQuestName(7102)}
}
