/obj/item/seeds/tower/steel
	name = "pack of steel-cap mycelium"
	desc = "This mycelium grows into steel logs."
	icon_state = "mycelium-steelcap"
	species = "steelcap"
	plantname = "Steel Caps"
	product = /obj/item/grown/log/steel
	reagents_add = list(/datum/reagent/iron = 0.10)
	rarity = 20

/obj/structure/bonfire
	var/target_temp = T0C + 25 // Target temp of 25C
	var/thermal_power = 40000 // About as good as a space heater

/obj/structure/bonfire/process()
	. = ..()
	if(!burning) // Not burning? No heat.
		return

	var/turf/L = loc
	if(!istype(L)) // Where the fuck are we? Nowhere? Understandable, have a nice day.
		return

	var/datum/gas_mixture/env = L.return_air()
	var/env_temp = env.return_temperature()

	if(env_temp < target_temp) // Too hot? No heat.
		var/heat_capacity = env.heat_capacity()

		// This formula is to deluded to explain, just know it works and heat capacity works and we're all good, arite?
		var/delta_temp = abs(env_temp - target_temp)

		delta_temp = min(delta_temp, thermal_power / heat_capacity)

		// Knowing this sets the temperature instead of increments it by the delta hurts me on a spiratual level
		env.set_temperature(env_temp + delta_temp)

		// No idea what this does, but the space heater has it so I presume it's important.
		//air_update_turf()
