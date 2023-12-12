local EAVV = _G.EndlessArchiveVersesAndVisions

-- some ability names do not match the achievement name
EAVV.EXCEPTIONS = {[191802] = _G.EndlessArchiveVersesAndVisions_WEREWOLF_BEHEMOTH}

-- O - Offensive
-- D - Defensive
-- U - Utility
-- V - Vision
-- A - Avatar vision

EAVV.ABILITIES = {
    [191802] = {3796}, -- A - Bestial Transformation
    [191849] = {3781, 3799, 3800, 3801}, -- O - Flame Aura
    [191936] = {3782, 3802, 3803, 3804}, -- D - Sequential Shield
    [192667] = {3781, 3799, 3800, 3801}, -- O - Swift Gale
    [192848] = {3781, 3799, 3800, 3801}, -- O - Pustulent Globs
    [192992] = {3781, 3799, 3800, 3801}, -- O - Archival Weaponry
    [193146] = {3785}, -- DV - Tempered Ward
    [193551] = {3781, 3799, 3800, 3801}, -- O - Cold Blast
    [193597] = {3781, 3799, 3800, 3801}, -- O - Beatdown
    [193692] = {3782, 3802, 3803, 3804}, -- D - Transfusion
    [193711] = {3782, 3802, 3803, 3804}, -- D - Siphoning Vigor
    [193749] = {3782, 3802, 3803, 3804}, -- D - Enhanced Remedy
    [193758] = {3783, 3805, 3806, 3807}, -- U - Magicka Renewal
    [193977] = {3781, 3799, 3800, 3801}, -- O - Augmented Areas
    [193984] = {3781, 3799, 3800, 3801}, -- O - Exsanguinate
    [194030] = {3782, 3802, 3803, 3804}, -- D - Regenerating Bastion
    [194058] = {3782, 3802, 3803, 3804}, -- D - Restorative Elixirs
    [194062] = {3783, 3805, 3806, 3807}, -- U - Stamina Renewal
    [194138] = {3782, 3802, 3803, 3804}, -- D - Rebirth
    [194153] = {3782, 3802, 3803, 3804}, -- D - Reactive Curse
    [194166] = {3782, 3802, 3803, 3804}, -- D - Archival Evasion
    [194179] = {3782, 3802, 3803, 3804}, -- D - On Defense
    [194181] = {3783, 3805, 3806, 3807}, -- U - Magical Expiration
    [194183] = {3783, 3805, 3806, 3807}, -- U - Energetic Expiration
    [194192] = {3783, 3805, 3806, 3807}, -- U - Glamorous Scholar
    [195038] = {3782, 3802, 3803, 3804}, -- D - Shackled Resolve
    [195928] = {3783, 3805, 3806, 3807}, -- U - Vital Expiration
    [196018] = {3797}, -- A - Iron Atronach
    [197522] = {3785}, -- DV - Curative Vigor
    [197652] = {3785}, -- DV - Hearty Vitality
    [197684] = {3785}, -- DV - Refined Restoration
    [197694] = {3785}, -- DV - Armored Shell
    [199960] = {3785}, -- DV - Sweeping Guard
    [199990] = {3785, 3796}, -- A - Ferocious Fortification
    [199997] = {3785, 3795}, -- A - Crystalline Fortification
    [200004] = {3785, 3797}, -- A - Scorching Fortification
    [200015] = {3781, 3799, 3800, 3801}, -- O - Archival Worldliness
    [200016] = {3781, 3799, 3800, 3801}, -- O - Guild Superiority
    [200017] = {3781, 3799, 3800, 3801}, -- O - Class Embodiment
    [200018] = {3781, 3799, 3800, 3801}, -- O - Archival Assault
    [200020] = {3781, 3799, 3800, 3801}, -- O - Magical Multitudes
    [200022] = {3785}, -- DV - Bolstered Mending
    [200051] = {3785}, -- DV - Energized Salve
    [200075] = {3781, 3799, 3800, 3801}, -- O - Frenzied Zeal
    [200093] = {3781, 3799, 3800, 3801}, -- O - Guardian of Pestilence
    [200127] = {3785}, -- DV - Effortless Aegis
    [200135] = {3785}, -- DV - Unrestrained Endurance
    [200142] = {3785}, -- DV - Effortless Acrobatics
    [200150] = {3785}, -- DV - Mystical Ward
    [200164] = {3785}, -- DV - Restorative Protection
    [200175] = {3782, 3802, 3803, 3804}, -- D - Redirecting Bonds
    [200180] = {3784}, -- OV - Powerful Domain
    [200202] = {3782, 3802, 3803, 3804}, -- D - Defensive Maneuver
    [200204] = {3782, 3802, 3803, 3804}, -- D - Fortified Dexterity
    [200236] = {3782, 3802, 3803, 3804}, -- D - Restorative Enabling
    [200291] = {3784}, -- OV - Lethal Sorcery
    [200306] = {3783, 3805, 3806, 3807}, -- U - Bountiful Resources
    [200311] = {3783, 3805, 3806, 3807}, -- U - Mighty Bash
    [200359] = {3784}, -- OV - Brawling Advantage
    [200370] = {3784}, -- OV - Thaumic Boom
    [200399] = {3784}, -- OV - Brawling Blitz
    [200412] = {3783, 3805, 3806, 3807}, -- U - Tomefoolery
    [200421] = {3784, 3796}, -- A - Ferocious Strikes
    [200494] = {3784, 3795}, -- A - Crystalline Strikes
    [200521] = {3783, 3805, 3806, 3807}, -- U - Unwitting Fortress
    [200679] = {3784, 3797}, -- A - Scorching Strikes
    [200686] = {3784}, -- OV - Piercing Perfection
    [200714] = {3784}, -- OV - Painful Proficient
    [200728] = {3784}, -- OV - Thumping Thaumaturgy
    [200742] = {3784}, -- OV - Persistant Pain
    [200790] = {3784}, -- OV - Lasting Harm
    [200798] = {3784}, -- OV - Targeted Ire
    [200904] = {3784}, -- OV - Focused Efforts
    [200941] = {3783, 3805, 3806, 3807}, -- U - Gilded Sleight
    [201012] = {3784}, -- OV - Well-Trained Command
    [201098] = {3786}, -- UV - Lessons Learned
    [201341] = {3786}, -- UV - Full Coffers
    [201400] = {3786}, -- UV - Archival Intelligence
    [201407] = {3786}, -- UV - Archival Endurance
    [201414] = {3786}, -- UV - Stamina Reserves
    [201428] = {3786}, -- UV - Magicka Reserves
    [201435] = {3786}, -- UV - Boundless Potential
    [201443] = {3786}, -- UV - Extended Favor
    [201472] = {3782, 3802, 3803, 3804}, -- D - Eye Catching
    [201474] = {3786}, -- UV - Resolute Mind
    [201491] = {3786}, -- UV - Attuned Enchantments
    [201504] = {3786}, -- UV - Vicious Poisons
    [202134] = {3795}, -- A - Ice Avatar
    [202510] = {3786, 3795}, -- A - Crystalline Support
    [202743] = {3796, 3786}, -- A - Ferocious Support
    [202804] = {3786, 3797}, -- A - Scorching Support
    [203352] = {3781, 3799, 3800, 3801}, -- O - Fire Orb
    [211730] = {3786} -- UV - Supplemental Thread
}

EAVV.AVATAR = {
    ICE = {202134, 202510, 200494, 199997},
    WOLF = {202743, 200421, 199990, 191802},
    IRON = {202804, 200679, 200004, 196018}
}

--3781 - I crave violence
--3782 - You can't touch me
--3783 - Viable and versatile
--3784 - Visions of violence
--3785 - Endless defender
--3786 - Seeing the big picture
--3795 - Keeping it cool
--3796 - Howling with rage
--3797 - Molten measures
--3799 - Battle ready
--3800 - Armed onslaught
--3801 - Mora's onslaught
--3802 - A sturdy shield
--3803 - Forceful Fortification
--3804 - Under Mora's protection
--3805 - Studying up
--3806 - Unorthdox approach
--3807 - Power practicum
