/turf/open/high_pressure_movements()
	var/atom/movable/M
	var/multiplier = 1
	if(locate(/obj/structure/rack) in src)
		multiplier *= 0.1
	else if(locate(/obj/structure/table) in src)
		multiplier *= 0.2
	for(var/thing in src)
		M = thing
		if (!M.anchored && !M.pulledby && M.last_high_pressure_movement_air_cycle < SSair.times_fired)
			M.experience_pressure_difference(pressure_difference * multiplier, pressure_direction, 0, pressure_specific_target)
	if(pressure_difference > 100)
		new /obj/effect/temp_visual/dir_setting/space_wind(src, pressure_direction, CLAMP(round(sqrt(pressure_difference) * 2), 10, 255))

/atom/movable/experience_pressure_difference(pressure_difference, direction, pressure_resistance_prob_delta = 0, throw_target)
	var/const/PROBABILITY_OFFSET = 40
	var/const/PROBABILITY_BASE_PRECENT = 10
	var/max_force = sqrt(pressure_difference)*(MOVE_FORCE_DEFAULT / 5)
	set waitfor = 0
	var/move_prob = 100
	if (pressure_resistance > 0)
		move_prob = (pressure_difference/pressure_resistance*PROBABILITY_BASE_PRECENT)-PROBABILITY_OFFSET
	move_prob += pressure_resistance_prob_delta
	if(ishuman(src))
		var/mob/living/carbon/human/bootloader = src
		var/item = bootloader.get_item_by_slot(ITEM_SLOT_FEET)
		if(item && istype(item, /obj/item/clothing/shoes/magboots))
			var/obj/item/clothing/shoes/magboots/booties = item
			if(booties.magpulse && bootloader.has_gravity())
				return
	if (move_prob > PROBABILITY_OFFSET && prob(move_prob) && (move_resist != INFINITY) && (!anchored && (max_force >= (move_resist * MOVE_FORCE_PUSH_RATIO))) || (anchored && (max_force >= (move_resist * MOVE_FORCE_FORCEPUSH_RATIO))))
		var/move_force = max_force * CLAMP(move_prob, 0, 100) / 100
		if(move_force > 6000)
			// WALLSLAM HELL TIME OH BOY
			var/turf/throw_turf = get_ranged_target_turf(get_turf(src), direction, round(move_force / 2000))
			if(throw_target && (get_dir(src, throw_target) & direction))
				throw_turf = get_turf(throw_target)
			var/throw_speed = CLAMP(round(move_force / 3000), 1, 10)
			throw_at(throw_turf, move_force / 3000, throw_speed, quickstart = FALSE)
		else
			step(src, direction)
		last_high_pressure_movement_air_cycle = SSair.times_fired
