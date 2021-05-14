/////////////////////  BASIC TANK  /////////////////////

/obj/item/tank/internals/AltClick(mob/user)  //  New Feature, Alt-Clicking a tank resets it to the original 17KPa pressure, not that you'll probably ever use this often
	. = ..()
	distribute_pressure = 17


/////////////////////  OCCULT TANK  /////////////////////

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


/////////////////////  COMBAT TANK  /////////////////////

/obj/item/tank/internals/combat/loot  //  Contains a small measure of nitryl and oxygen, you can alt-click it to activate the nitryl secondary effects.
	name = "combat mix tank"
	desc = "A partial tank of nitryl and pluoxium. Alt-click to quickly shift modes."
	icon = 'austation/icons/obj/tank.dmi'
	icon_state = "combat"
	distribute_pressure = 26
	force = 10
	dog_fashion = /datum/dog_fashion/back
	var/toggles = TRUE

/obj/item/tank/internals/combat/advanced  //  Admin spawn, contains the incredibly powerful stimulum.  Do not give this to players through normal means.
	name = "advanced combat mix tank"
	desc = "A full tank of stimulum and pluoxium. The real deal, feel blessed."
	distribute_pressure = 13
	icon_state = "combat_adv"
	toggles = FALSE

/obj/item/tank/internals/combat/populate_gas()
	air_contents.set_moles(/datum/gas/oxygen, (0.7*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)*0.63)
	air_contents.set_moles(/datum/gas/nitryl, (0.7*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)*0.37)  //  should give up to a maximum of 5 minutes and 15 seconds of meth speed

/obj/item/tank/internals/combat/advanced/populate_gas()
	air_contents.set_moles(/datum/gas/pluoxium, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)*0.17)
	air_contents.set_moles(/datum/gas/stimulum, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)*0.83)

/obj/item/tank/internals/combat/AltClick(mob/user)
	. = ..()
	if(!toggles)  //  Advanced tanks use stimulum and don't need to switch pressures
		distribute_pressure = 13  //  Pressure was set to 17 during the .=..() step
		return
	if(distribute_pressure <= 41)  //  Pressure is considered to be low so make it higher, otherwise it's high so make it lower
		distribute_pressure = 55
		to_chat(user, "<span class='notice'> You quickly adjust \the [src] to HIGH PRESSURE mode.</span>")
		if(air_contents.return_pressure < 55)  //  We can set it to 55, but if there isn't enough gas it will just drop during the next breath
			to_chat(user, "<span class='warning'> But the pressure can not be raised high enough!</span>")
		else
			audible_message("<span class='notice'> \The [src] hisses loudly as more gas begins to escape!</span>")
	else
		distribute_pressure = 26
		to_chat(user, "<span class='notice'> You quickly adjust \the [src] to LOW PRESSURE mode.</span>")
