/*
AUStation Necro Chest Loot Table
Beeloot is the number of items in Bees loot table excluding disabled loot
*/
/obj/structure/closet/crate/necropolis/tendril/proc/AU_PopulateContents(var/Beeloot_Amount = 0)
	var/AUloot_Amount = 1
	var/AUloot_Roll_Chance = (100 / (Beeloot_Amount + AUloot_Amount)) * AUloot_Amount

	if(prob(AUloot_Roll_Chance))
		var/AU_lootroll = rand(1,AUloot_Amount)
		switch(AU_lootroll)
			if(1)
				new /obj/item/tank/internals/occult(src)
		return TRUE
	else
		return FALSE

/obj/item/tank/internals/occult
  name = "occult tank"
  desc = "An un-natural experiment. Hyms with a musical tune, god knows what happens if it ruptures..."
  icon = 'austation/icons/obj/tank.dmi'
  icon_state = "occult"
  max_integrity = 10
  volume = 200000
  no_rupture = TRUE

  var/datum/gas/gas_type
  var/gas_temp

/obj/item/tank/internals/occult/Initialize()
	..()

	var/list/gas_list = list()

	switch(rand(1, 100))
		if(1 to 30) //cold
			gas_temp = rand(0, 280)
		if(31 to 60) //normal
			gas_temp = 293.15
		if(61 to 90) //hot
			gas_temp = rand(300, 1000)
		if(91 to 100) //S U P E R  H O T
			gas_temp = rand(1001, 100000)

	switch(rand(1, 100))
		if(1 to 10) //better luck next time
			gas_list = list(/datum/gas/nitrogen, /datum/gas/carbon_dioxide, /datum/gas/nitrous_oxide, /datum/gas/water_vapor)
		if(11 to 50) //usefull but boring
			gas_list = list(/datum/gas/oxygen)
			gas_temp = 293.15
		if(50 to 90) //we are getting somewhere
			gas_list = list(/datum/gas/plasma, /datum/gas/nitryl, /datum/gas/bz, /datum/gas/miasma, /datum/gas/pluoxium)
		if(91 to 100) //are you winning son?
			gas_list = list(/datum/gas/tritium, /datum/gas/stimulum, /datum/gas/hypernoblium)

	gas_type = pick(gas_list)

/obj/item/tank/internals/occult/process()
	..()

	air_contents.clear()
	air_contents.set_moles(gas_type, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	air_contents.set_temperature(gas_temp)

/obj/item/tank/internals/occult/deconstruct(disassembled = TRUE)
  explosion(src, 0, 0, 8)
  ..()
