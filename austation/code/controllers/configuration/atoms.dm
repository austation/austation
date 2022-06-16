
/datum/controller/subsystem/atoms/proc/init_atoms_in_list(list/turf/terfs)
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/structure/cable/cables = list()
	var/list/atom/movable/movables = list()
	var/list/area/areas = list()

	for(var/turf/current_turf as anything in terfs)
		var/area/current_turfs_area = current_turf.loc
		areas |= current_turfs_area
		if(!initialized)
			continue

		for(var/movable_in_turf in current_turf)
			movables += movable_in_turf
			if(istype(movable_in_turf, /obj/structure/cable))
				cables += movable_in_turf
				continue
			if(istype(movable_in_turf, /obj/machinery/atmospherics))
				atmos_machines += movable_in_turf

	SSmapping.reg_in_areas_in_z(areas)
	if(!initialized)
		return

	InitializeAtoms(areas + terfs + movables, null)

	SSmachines.setup_template_powernets(cables)
	SSair.setup_template_machinery(atmos_machines)

	for(var/turf/terf as anything in terfs)
		terf.levelupdate()
