local AH = ArchiveHelper

-- some ability names do not match the achievement name
AH.EXCEPTIONS = { [191802] = ARCHIVEHELPER_WEREWOLF_BEHEMOTH }

AH.TYPES = {
    VERSE = ENDLESS_DUNGEON_BUFF_TYPE_VERSE,
    VISION = ENDLESS_DUNGEON_BUFF_TYPE_VISION
}

--- @diagnostic disable undefined-global
AH.CLASSES = {
    AVATAR = SI_ENDLESSDUNGEONBUFFTYPE_AVATAR2,
    DEFENCE = SI_ENDLESSDUNGEONBUFFBUCKETTYPE1,
    OFFENCE = SI_ENDLESSDUNGEONBUFFBUCKETTYPE0,
    UTILITY = SI_ENDLESSDUNGEONBUFFBUCKETTYPE2
}
--- @diagnostic enable undefined-global

AH.ABILITIES = {
    [191802] = { ids = { 3796 }, class = AH.CLASSES.AVATAR },                                                  -- Bestial Transformation
    [191849] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Flame Aura
    [191936] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Sequential Shield
    [192667] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Swift Gale
    [192848] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Pustulent Globs
    [192992] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Archival Weaponry
    [193146] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Tempered Ward
    [193551] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Cold Blast
    [193597] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Beatdown
    [193692] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Transfusion
    [193711] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Siphoning Vigor
    [193749] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Enhanced Remedy
    [193758] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Magicka Renewal
    [193977] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Augmented Areas
    [193984] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Exsanguinate
    [194030] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Regenerating Bastion
    [194058] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Restorative Elixirs
    [194062] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Stamina Renewal
    [194138] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Rebirth
    [194153] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Reactive Curse
    [194166] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Archival Evasion
    [194179] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Head-On Defense
    [194181] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Magical Expiration
    [194183] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Energetic Expiration
    [194192] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Glamorous Scholar
    [195038] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Shackled Resolve
    [195928] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Vital Expiration
    [196018] = { ids = { 3797 }, class = AH.CLASSES.AVATAR },                                                  -- Iron Atronach
    [197522] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Curative Vigor
    [197652] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Hearty Vitality
    [197684] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Refined Restoration
    [197694] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Armored Shell
    [199960] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Sweeping Guard
    [199990] = { ids = { 3785, 3796 }, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR },                    -- Ferocious Fortification
    [199997] = { ids = { 3785, 3795 }, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR },                    -- Crystalline Fortification
    [200004] = { ids = { 3785, 3797 }, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR },                    -- Scorching Fortification
    [200015] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Archival Worldliness
    [200016] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Guild Superiority
    [200017] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Class Embodiment
    [200018] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Archival Assault
    [200020] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Magical Multitudes
    [200022] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Bolstered Mending
    [200045] = { ids = { 3799, 3800, 3801, 4153 }, class = AH.CLASSES.OFFENCE },                               -- Orbiting Echoes ***
    [200051] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Energized Salve
    [200075] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Frenzied Zeal
    [200093] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Guardian of Pestilence
    [200127] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Effortless Aegis
    [200135] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Unrestrained Endurance
    [200142] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Effortless Acrobatics
    [200150] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Mystical Ward
    [200164] = { ids = { 3785 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },                         -- Restorative Protection
    [200175] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Redirecting Bonds
    [200180] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Powerful Domain
    [200202] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Defensive Maneuver
    [200204] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Fortified Dexterity
    [200236] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Restorative Enabling
    [200291] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Lethal Sorcery
    [200306] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Bountiful Resources
    [200311] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Mighty Bash
    [200359] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Brawling Advantage
    [200370] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Thaumic Boom
    [200399] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Brawling Blitz
    [200412] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Tomefoolery
    [200421] = { ids = { 3784, 3796 }, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR },                    -- Ferocious Strikes
    [200494] = { ids = { 3784, 3795 }, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR },                    -- Crystalline Strikes
    [200521] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Unwitting Fortress
    [200679] = { ids = { 3784, 3797 }, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR },                    -- Scorching Strikes
    [200686] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Piercing Perfection
    [200714] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Painful Proficient
    [200728] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Thumping Thaumaturgy
    [200742] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Persistant Pain
    [200790] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Lasting Harm
    [200798] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Targeted Ire
    [200904] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Focused Efforts
    [200941] = { ids = { 3783, 3805, 3806, 3807 }, class = AH.CLASSES.UTILITY },                               -- Gilded Sleight
    [201012] = { ids = { 3784 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },                         -- Well-Trained Command
    [201098] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Lessons Learned
    [201341] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Full Coffers
    [201400] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Archival Intelligence
    [201407] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Archival Endurance
    [201414] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Stamina Reserves
    [201428] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Magicka Reserves
    [201435] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Boundless Potential
    [201443] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Extended Favor
    [201472] = { ids = { 3782, 3802, 3803, 3804 }, class = AH.CLASSES.DEFENCE },                               -- Eye Catching
    [201474] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Resolute Mind
    [201491] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Attuned Enchantments
    [201504] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Vicious Poisons
    [202134] = { ids = { 3795 }, class = AH.CLASSES.AVATAR },                                                  -- Ice Avatar
    [202510] = { ids = { 3786, 3795 }, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR },                    -- Crystalline Support
    [202743] = { ids = { 3796, 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR },                    -- Ferocious Support
    [202804] = { ids = { 3786, 3797 }, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR },                    -- Scorching Support
    [211730] = { ids = { 3786 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },                         -- Supplemental Thread
    [220160] = { ids = { 3802, 3803, 3804, 4153 }, class = AH.CLASSES.DEFENCE },                               -- Reflected Ruin ***
    [220184] = { ids = { 3799, 3800, 3801, 4153 }, class = AH.CLASSES.OFFENCE },                               -- Tempest ***
    [220189] = { ids = { 4153, 4155 }, class = AH.CLASSES.AVATAR },                                            -- Undead Avatar ***
    [220193] = { ids = { 3805, 3806, 3807, 4153 }, class = AH.CLASSES.UTILITY },                               -- Grasping Limbs ***
    [220194] = { ids = { 3805, 3806, 3807, 4153 }, class = AH.CLASSES.UTILITY },                               -- Temporal Speed ***
    [220195] = { ids = { 3805, 3806, 3807, 4153 }, class = AH.CLASSES.UTILITY },                               -- Extravagant Elixirs ***
    [220557] = { ids = { 3802, 3803, 3804, 4154, 4155 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE }, -- Necrotic Fortification ***
    [220563] = { ids = { 3799, 3800, 3801, 4154, 4155 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE }, -- Necrotic Strikes ***
    [220568] = { ids = { 3805, 3806, 3807, 4154, 4155 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY }, -- Necrotic Support ***
    [220730] = { ids = { 3802, 3803, 3804, 4153 }, class = AH.CLASSES.DEFENCE },                               -- Phalanx ***
    [220765] = { ids = { 3799, 3800, 3801, 4154 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },       -- Storm Projection ***
    [220770] = { ids = { 3802, 3803, 3804, 4154 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },       -- Prickly Retort ***
    [220775] = { ids = { 3802, 3803, 3804, 4154 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },       -- Apocryphal Emissary ***
    [220780] = { ids = { 3805, 3806, 3807, 4154 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY },       -- Quickened Tinctures ***
    [221194] = { ids = { 3781, 3799, 3800, 3801 }, class = AH.CLASSES.OFFENCE },                               -- Fire Orb
    [222405] = { ids = { 3802, 3803, 3804, 4154 }, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE },       -- Adaptive Defender ***
    [222413] = { ids = { 3799, 3800, 3801, 4154 }, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE },       -- Adaptive Conqueror ***
    [222418] = { ids = { 3805, 3806, 3807, 4154 }, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY }        -- Adaptive Athlete ***
}

do
    for _, info in pairs(AH.ABILITIES) do
        if (not info.type) then
            info.type = AH.TYPES.VERSE
        end
    end
end

AH.AVATAR = {
    ICE = { id = 3795, abilityIds = { 202134, 202510, 200494, 199997 }, class = AH.CLASSES.DEFENCE, transform = 202134 },
    WOLF = { id = 3796, abilityIds = { 202743, 200421, 199990, 191802 }, class = AH.CLASSES.OFFENCE, transform = 191802 },
    IRON = { id = 3797, abilityIds = { 202804, 200679, 200004, 196018 }, class = AH.CLASSES.UTILITY, transform = 196018 },
    UNDEAD = { id = 4155, abilityIds = { 220557, 220563, 220568, 220189 }, class = AH.CLASSES.OFFENCE, transform = 220189 }
}

-- collect a number of unspecified verse/vision types
AH.GENERAL = {
    3799,
    3800,
    3801,
    3802,
    3803,
    3804,
    3805,
    3806,
    3807
}

AH.MYSTERY = {
    [203611] = "u40_verse_item_offense", -- offensive
    [203612] = "u40_verse_item_defense", -- defensive
    [203613] = "u40_verse_item_utility"  -- utility
}

local achievementIds = {
    "3751,3787",
    "3789,3807",
    3848,
    "3926,3938",
    4005,
    4008,
    4063,
    "4152,4157",
    "4198,4199",
    4215
}

AH.ACHIEVEMENTS = {
    IDS = AH.LC.BuildList(achievementIds),
    LIMIT = {
        3760,
        3761,
        3762 -- defeat thousands of maligraphies, really don't need this firing every time you kill something
    }
}

AH.SKILL_TYPE_BUFFS = {
    [SKILL_TYPE_AVA] = { 200018 },
    [SKILL_TYPE_CLASS] = { 200017 },
    [SKILL_TYPE_GUILD] = { 200016 },
    [SKILL_TYPE_WORLD] = { 200015 },
    [AH.SKILL_TYPE_PET] = { 201012 }
}

local pets = {
    23304,
    23316,
    23319,
    24613,
    24636,
    24639,
    30581,
    30584,
    30587,
    30592,
    30595,
    30598,
    30618,
    30622,
    30626,
    30631,
    30636,
    30641,
    30647,
    30652,
    30657,
    30664,
    30669,
    30674,
    "85982,85993"
}

AH.PETS = AH.LC.BuildList(pets)

AH.TERRAIN = {
    -- Molten rain (which ones are relevant?)
    151317,          -- Molten rain
    151328,          -- Molten rain
    "151357,151362", -- Molten rain
    151365,          -- Molten rain
    151367,          -- Molten rain
    151369,          -- Molten rain
    "151370,151371", -- Molten rain
    "151391,151395", -- Molten rain
    151397,          -- Molten rain
    "151402,151403", -- Molten rain
    152194,          -- Molten rain
    "154992,154993", -- Molten rain
    "154995,154998", -- Molten rain
    "155000,155001", -- Molten rain
    "155004,155005", -- Molten rain
    "156951,156952", -- Molten rain
    "157482,157504", -- Molten rain
    "158393,158405", -- Molten rain
    "182805,182807", -- Lava
    182833,          -- Lava
    "195454,195458", -- Molten rain
    198997,          -- Molten rain
    199002,          -- Molten rain
    "224944,224945", -- Frigid waters
    "224947,224949", -- Frigid Waters
    "224951,224952"  -- Frigid waters
}

AH.AUDITOR = 12269

AH.ARCANE_BARRAGE = {
    "212081,212088"
}

AH.SEEKING_RUNESCRAWL = {
    "207590,207592"
}
