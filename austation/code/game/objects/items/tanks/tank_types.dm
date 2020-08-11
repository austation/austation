#define CURSED_TANK_TRAIT "cursed-tank"
/obj/item/tank/internals/emergency_oxygen/infinite
	name = "cursed emergency oxygen tank"
	desc = "Cursed by an unholy fusion experiment. Holds a seemingly endless supply of oxygen, but oh god if it ruptures..."

/obj/item/tank/internals/emergency_oxygen/infinite/process()
	..() // Do shmut
	air_contents.clear() // Removes all contents
	air_contents.set_moles(/datum/gas/oxygen, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)) // Sets it to the default pressure

/obj/item/tank/internals/emergency_oxygen/infinite/deconstruct(disassembled = TRUE)
	explosion(src, 2, 4, 8, 12) // If this thing explodes it goes boom. :)


/obj/item/tank/internals/emergency_oxygen/infinite/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_TANK_TRAIT)
#undef CURSED_TANK_TRAIT
