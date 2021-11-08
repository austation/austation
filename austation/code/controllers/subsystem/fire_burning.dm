/datum/controller/subsystem/fire_burning/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/delta_time = wait * 0.1

	while(currentrun.len)
		var/obj/O = currentrun[currentrun.len]
		currentrun.len--
		if (!O || QDELETED(O))
			processing -= O
			if (MC_TICK_CHECK)
				return
			continue


		if(O.resistance_flags & ON_FIRE) //in case an object is extinguished while still in currentrun
			if(!(O.resistance_flags & FIRE_PROOF))
				var/turf/terf = get_turf(O)
				if(isopenturf(terf))
					var/turf/open/openterf = terf
					if(openterf.air)
						openterf.air.adjust_moles(GAS_SMOKE, 10)
				O.take_damage(10 * delta_time, BURN, "fire", 0)
			else
				O.extinguish()

		if (MC_TICK_CHECK)
			return

