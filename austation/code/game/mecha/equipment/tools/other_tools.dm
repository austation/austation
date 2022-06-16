/obj/item/mecha_parts/mecha_equipment/thrusters/ion // Fuck you we got ION THRUSTERS. Apparently they actually exist, but here they are in their glorious, constructable form. Hope that doesn't break anything.
	detachable = TRUE // Detach 'em!
	salvageable = TRUE // Smash 'em
	var/move_cost = 5 //  Boil and broil 'em! Move cost is a multiplier applied to the normal energy cost per step. That means 5 times the normal power cost for a mech stepping when using ion thrusters.

/obj/item/mecha_parts/mecha_equipment/thrusters/ion/thrust(var/movement_dir)
	if(!chassis)
		return FALSE
	if(chassis.use_power(chassis.step_energy_drain * move_cost))
		generate_effect(movement_dir)
		return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/thrusters/gas
	move_cost = 1 // Upstream says 20. Here we say fuck you. Makes RCS thrusters actually viable.
