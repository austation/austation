/////////////////////  BASIC TANK  /////////////////////


//  New Feature, Alt-Clicking a tank resets it to the original 17kPa pressure, not that you'll probably ever use this often.
//  Also supports swapping between multiple modes from a list.
//  If by any chance somebody adds another tank with multiple modes, it can use this system by just plugging in a new list into var/list/modes()
/obj/item/tank/internals
	var/list/modes = list(TANK_DEFAULT_RELEASE_PRESSURE)  //  MUST be ordered numerically from lowest to highest!

/obj/item/tank/internals/AltClick(mob/user)
	. = ..()
	if(!length(modes))  //  Something weird happened
		distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE  //  Probably for the best?
		return
	if(length(modes) == 1)
		distribute_pressure = modes[1]
		to_chat(user, "<span class='notice'>You quickly adjust \the [src] to release [distribute_pressure]kPa.</span>")
		return

	var/index = modes.Find(distribute_pressure)
	if(!index || index == length(modes))
		index = 1
	else
		index++
	distribute_pressure = modes[index]
	to_chat(user, "<span class='notice'>You quickly adjust \the [src] to release [distribute_pressure]kPa.</span>")

/obj/item/tank/internals/examine(mob/user)
	. = ..()
	if(length(modes) >= 2)
		. += "<span class='notice'>Alt-click to quickly shift through \the [src]'s pressure modes.</span>"
		. += "<span class='notice'>\The [src] can be set to:</span>"
		. += "<span class='notice'>[english_list(input = modes, and_text = "kPa or ", comma_text = "kPa, ")]kPa</span>"
	else
		. += "<span class='notice'>Alt-click to quickly set \the [src] to [modes[1]]kPa.</span>"


/////////////////////  OCCULT TANK  /////////////////////

/obj/item/tank/internals/occult
  name = "occult tank"
  desc = "An unnatural experiment. Hyms with a musical tune, god knows what happens if it ruptures..."
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
		if(1 to 30)  //  Cold.
			gas_temp = rand(0, 280)
		if(31 to 60)  //  Normal.
			gas_temp = 293.15
		if(61 to 90)  //  Hot.
			gas_temp = rand(300, 1000)
		if(91 to 100)  //  S U P E R  H O T.
			gas_temp = rand(1001, 100000)

	switch(rand(1, 100))
		if(1 to 10)  //  Better luck next time.
			gas_list = list(GAS_N2, GAS_CO2, GAS_NITROUS, GAS_H2O)
		if(11 to 50)  //  Usefull but boring.
			gas_list = list(GAS_O2)
			gas_temp = 293.15
		if(50 to 90)  //  We are getting somewhere.
			gas_list = list(GAS_PLASMA, GAS_NITRYL, GAS_BZ, GAS_MIASMA, GAS_PLUOXIUM)
		if(91 to 100)  //  Are you winning son?
			gas_list = list(GAS_TRITIUM, GAS_STIMULUM, GAS_HYPERNOB)

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

/obj/item/tank/internals/combat  //  Contains a small measure of nitryl and oxygen, you can alt-click it to activate the nitryl secondary effects.
	name = "combat mix tank"
	desc = "A partial tank of nitryl and oxygen."
	icon = 'austation/icons/obj/tank.dmi'
	icon_state = "combat"
	distribute_pressure = 27
	force = 10
	dog_fashion = /datum/dog_fashion/back
	modes = list(27, 55)

/obj/item/tank/internals/combat/advanced  //  Admin spawn, contains the incredibly powerful stimulum.  Do not give this to players through normal means.
	name = "advanced combat mix tank"
	desc = "A full tank of stimulum and pluoxium. The real deal, feel blessed."
	distribute_pressure = 13
	icon_state = "combat_adv"
	modes = list(13)

/obj/item/tank/internals/combat/populate_gas()
	air_contents.set_moles(GAS_O2, (0.7*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)*(17/27))  //  17 parts Oxygen, releases at 17pp.
	air_contents.set_moles(GAS_NITRYL, (0.7*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)*(10/27))  //  Should give up to a maximum of 5 minutes and 15 seconds of meth speed.

/obj/item/tank/internals/combat/advanced/populate_gas()
	air_contents.set_moles(GAS_PLUOXIUM, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)*(1/6))  //  1 parts Pluoxium, releases at 2pp.
	air_contents.set_moles(GAS_STIMULUM, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)*(5/6))
