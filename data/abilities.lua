local AH = _G.ArchiveHelper

-- some ability names do not match the achievement name
AH.EXCEPTIONS = {[191802] = _G.ARCHIVEHELPER_WEREWOLF_BEHEMOTH}

AH.TYPES = {
    VERSE = _G.ENDLESS_DUNGEON_BUFF_TYPE_VERSE,
    VISION = _G.ENDLESS_DUNGEON_BUFF_TYPE_VISION
}

AH.CLASSES = {
    AVATAR = _G.SI_ENDLESSDUNGEONBUFFTYPE_AVATAR2,
    DEFENCE = _G.SI_ENDLESSDUNGEONBUFFBUCKETTYPE1,
    OFFENCE = _G.SI_ENDLESSDUNGEONBUFFBUCKETTYPE0,
    UTILITY = _G.SI_ENDLESSDUNGEONBUFFBUCKETTYPE2
}

AH.ABILITIES = {
    [191802] = {ids = {3796}, class = AH.CLASSES.AVATAR}, -- Bestial Transformation
    [191849] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Flame Aura
    [191936] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Sequential Shield
    [192667] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Swift Gale
    [192848] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Pustulent Globs
    [192992] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Archival Weaponry
    [193146] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Tempered Ward
    [193551] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Cold Blast
    [193597] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Beatdown
    [193692] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Transfusion
    [193711] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Siphoning Vigor
    [193749] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Enhanced Remedy
    [193758] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Magicka Renewal
    [193977] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Augmented Areas
    [193984] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Exsanguinate
    [194030] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Regenerating Bastion
    [194058] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Restorative Elixirs
    [194062] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Stamina Renewal
    [194138] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Rebirth
    [194153] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Reactive Curse
    [194166] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Archival Evasion
    [194179] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- On Defense
    [194181] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Magical Expiration
    [194183] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Energetic Expiration
    [194192] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Glamorous Scholar
    [195038] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Shackled Resolve
    [195928] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Vital Expiration
    [196018] = {ids = {3797}, class = AH.CLASSES.AVATAR}, -- Iron Atronach
    [197522] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Curative Vigor
    [197652] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Hearty Vitality
    [197684] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Refined Restoration
    [197694] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Armored Shell
    [199960] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Sweeping Guard
    [199990] = {ids = {3785, 3796}, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR}, -- Ferocious Fortification
    [199997] = {ids = {3785, 3795}, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR}, -- Crystalline Fortification
    [200004] = {ids = {3785, 3797}, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR}, -- Scorching Fortification
    [200015] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Archival Worldliness
    [200016] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Guild Superiority
    [200017] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Class Embodiment
    [200018] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Archival Assault
    [200020] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Magical Multitudes
    [200022] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Bolstered Mending
    [200051] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Energized Salve
    [200075] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Frenzied Zeal
    [200093] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Guardian of Pestilence
    [200127] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Effortless Aegis
    [200135] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Unrestrained Endurance
    [200142] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Effortless Acrobatics
    [200150] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Mystical Ward
    [200164] = {ids = {3785}, type = AH.TYPES.VISION, class = AH.CLASSES.DEFENCE}, -- Restorative Protection
    [200175] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Redirecting Bonds
    [200180] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Powerful Domain
    [200202] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Defensive Maneuver
    [200204] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Fortified Dexterity
    [200236] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Restorative Enabling
    [200291] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Lethal Sorcery
    [200306] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Bountiful Resources
    [200311] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Mighty Bash
    [200359] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Brawling Advantage
    [200370] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Thaumic Boom
    [200399] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Brawling Blitz
    [200412] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Tomefoolery
    [200421] = {ids = {3784, 3796}, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR}, -- Ferocious Strikes
    [200494] = {ids = {3784, 3795}, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR}, -- Crystalline Strikes
    [200521] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Unwitting Fortress
    [200679] = {ids = {3784, 3797}, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR}, -- Scorching Strikes
    [200686] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Piercing Perfection
    [200714] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Painful Proficient
    [200728] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Thumping Thaumaturgy
    [200742] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Persistant Pain
    [200790] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Lasting Harm
    [200798] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Targeted Ire
    [200904] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Focused Efforts
    [200941] = {ids = {3783, 3805, 3806, 3807}, class = AH.CLASSES.UTILITY}, -- Gilded Sleight
    [201012] = {ids = {3784}, type = AH.TYPES.VISION, class = AH.CLASSES.OFFENCE}, -- Well-Trained Command
    [201098] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Lessons Learned
    [201341] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Full Coffers
    [201400] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Archival Intelligence
    [201407] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Archival Endurance
    [201414] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Stamina Reserves
    [201428] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Magicka Reserves
    [201435] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Boundless Potential
    [201443] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Extended Favor
    [201472] = {ids = {3782, 3802, 3803, 3804}, class = AH.CLASSES.DEFENCE}, -- Eye Catching
    [201474] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Resolute Mind
    [201491] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Attuned Enchantments
    [201504] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY}, -- Vicious Poisons
    [202134] = {ids = {3795}, class = AH.CLASSES.AVATAR}, -- Ice Avatar
    [202510] = {ids = {3786, 3795}, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR}, -- Crystalline Support
    [202743] = {ids = {3796, 3786}, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR}, -- Ferocious Support
    [202804] = {ids = {3786, 3797}, type = AH.TYPES.VISION, class = AH.CLASSES.AVATAR}, -- Scorching Support
    [203352] = {ids = {3781, 3799, 3800, 3801}, class = AH.CLASSES.OFFENCE}, -- Fire Orb
    [211730] = {ids = {3786}, type = AH.TYPES.VISION, class = AH.CLASSES.UTILITY} -- Supplemental Thread
}

do
    for _, info in pairs(AH.ABILITIES) do
        if (not info.type) then
            info.type = AH.TYPES.VERSE
        end
    end
end

AH.AVATAR = {
    ICE = {id = 3795, abilityIds = {202134, 202510, 200494, 199997}, class = AH.CLASSES.DEFENCE},
    WOLF = {id = 3796, abilityIds = {202743, 200421, 199990, 191802}, class = AH.CLASSES.OFFENCE},
    IRON = {id = 3797, abilityIds = {202804, 200679, 200004, 196018}, class = AH.CLASSES.UTILITY}
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

AH.ACHIEVEMENTS = {
    START = 3751,
    END = 3807,
    LIMIT = {
        3762 -- defeat 5000 maligraphies, really don't need this firing every time you kill something
    }
}

--[[
3781, -- I crave violence
3782, -- You can't touch me
3783, -- Viable and versatile
3784, -- Visions of violence
3785, -- Endless defender
3786, -- Seeing the big picture
3795, -- Keeping it cool
3796, -- Howling with rage
3797, -- Molten measures
3799, -- Battle ready
3800, -- Armed onslaught
3801, -- Mora's onslaught
3802, -- A sturdy shield
3803, -- Forceful Fortification
3804, -- Under Mora's protection
3805, -- Studying up
3806, -- Unorthdox approach
3807, -- Power practicum
]]
