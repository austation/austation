/obj/item/reagent_containers/fertilizer_bag
	name = "Fertilizer Bag"
	desc = "A plant's meal sack."
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	var/bag_capacity = 300
	var/mix = list()
	var/mix_size = 0
	var/apply_chance = 0
	var/apply_strength = 0

	//all the stat catergories effects - TRUE/FALSE
	var/mutate_pot = 0//potency -
	var/mutate_yld = 0//yield -
	var/mutate_prd_spd = 0//production_speed -
	var/mutate_mat_spd = 0//maturation_speed -
	var/mutate_lif = 0//lifespan -
	var/mutate_end = 0//endurance -
	var/mutate_prd = 0//production

/obj/item/reagent_containers/fertilizer_bag/Initialize()
	. = ..()
	create_reagents(bag_capacity, OPENCONTAINER)

/obj/item/reagent_containers/fertilizer_bag/proc/update_effects()
	if(reagents.has_reagent(/datum/reagent/uranium/radium, 1))
		if(!check_contents(/datum/reagent/uranium/radium))
			apply_chance += 0.20
			apply_strength += 0.10
			mix += list(/datum/reagent/uranium/radium)
		mutate_end = TRUE
		mutate_lif = TRUE

	else if(reagents.has_reagent(/datum/reagent/uranium, 1))
		if(!check_contents(/datum/reagent/uranium/radium))
			apply_chance += 0.25
			apply_strength += 0.25
			mix += list(/datum/reagent/uranium)
		mutate_yld = TRUE
		mutate_pot = TRUE
		mutate_prd = TRUE

	else if(reagents.has_reagent(/datum/reagent/toxin/mutagen, 1))
		if(!check_contents(/datum/reagent/toxin/mutagen))
			apply_chance += 0.20
			apply_strength += 0.15
			mix += list(/datum/reagent/toxin/mutagen)
		mutate_mat_spd = TRUE
		mutate_prd_spd = TRUE

	else if(reagents.has_reagent(/datum/reagent/water, 1))
		if(!check_contents(/datum/reagent/water))
			apply_chance -= 0.15
			apply_strength -= 0.10
			mix += list(/datum/reagent/water)
		remove_random_trait()
	else if(reagents.has_reagent(/datum/reagent/medicine/earthsblood, 1))
		if(!check_contents(/datum/reagent/medicine/earthsblood))
			apply_chance += 0.25
			apply_strength += 0.15
			mix += list(/datum/reagent/medicine/earthsblood)
	remove_specific(/datum/reagent/plantnutriment/generic_fertilizer)

/obj/item/reagent_containers/fertilizer_bag/attackby(obj/item/I, mob/living/user, params)
	update_effects()
	to_chat(user, "check mixed by")

/obj/item/reagent_containers/fertilizer_bag/proc/check_contents(var/C)
	if(C in mix)
		return TRUE

/obj/item/reagent_containers/fertilizer_bag/proc/remove_random_trait()//Removes random fertilizer trait, not plant. Possibly gross code
	var/rem_list = list(mutate_pot,
						mutate_yld,
						mutate_prd_spd,
						mutate_mat_spd,
						mutate_lif,
						mutate_end,
						mutate_prd)
	var/A = rand(0, 6)
	rem_list[A] = FALSE

/obj/item/reagent_containers/fertilizer_bag/proc/remove_specific(var/S)
	for(var/R in reagent_list)
		if(!istype(reagent_list[R], S))
			reagents.remove_reagent(reagent_list[R], bag_capacity, 0)
