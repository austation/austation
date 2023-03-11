SUBSYSTEM_DEF(parallax)
	name = "Parallax"
	wait = 2
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND
	priority = FIRE_PRIORITY_PARALLAX
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun
	var/planet_x_offset = 128
	var/planet_y_offset = 128
	var/random_layer
	var/random_parallax_color

//These are cached per client so needs to be done asap so people joining at roundstart do not miss these.
/datum/controller/subsystem/parallax/PreInit()
	. = ..()
	if(prob(70))	//70% chance to pick a special extra layer
		random_layer = pick(/atom/movable/screen/parallax_layer/random/space_gas, /atom/movable/screen/parallax_layer/random/asteroids)
		random_parallax_color = pick(COLOR_TEAL, COLOR_GREEN, COLOR_SILVER, COLOR_YELLOW, COLOR_CYAN, COLOR_ORANGE, COLOR_PURPLE)//Special color for random_layer1. Has to be done here so everyone sees the same color.
	planet_y_offset = rand(100, 160)
	planet_x_offset = rand(100, 160)

<<<<<<< HEAD
=======
/datum/controller/subsystem/parallax/Initialize(start_timeofday)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGGED_IN, PROC_REF(on_mob_login))
	throttle_ghost_pop = CONFIG_GET(number/parallax_ghost_disable_pop)
	throttle_all_pop = CONFIG_GET(number/parallax_disable_pop)

>>>>>>> 7d11b2f84d (515 Compatibility (#8648))
/datum/controller/subsystem/parallax/fire(resumed = 0)
	if (!resumed)
		src.currentrun = GLOB.clients.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/client/C = currentrun[currentrun.len]
		currentrun.len--
		if (!C || !C.eye)
			if (MC_TICK_CHECK)
				return
			continue
		var/atom/movable/A = C.eye
		if(!istype(A))
			continue
		for (A; isloc(A.loc) && !isturf(A.loc); A = A.loc);

		if(A != C.movingmob)
			if(C.movingmob != null)
				C.movingmob.client_mobs_in_contents -= C.mob
				UNSETEMPTY(C.movingmob.client_mobs_in_contents)
			LAZYINITLIST(A.client_mobs_in_contents)
			A.client_mobs_in_contents += C.mob
			C.movingmob = A
		if (MC_TICK_CHECK)
			return
<<<<<<< HEAD
	currentrun = null
=======
	//Processing is completed, clear the list
	currentrun.len = 0

/datum/controller/subsystem/parallax/proc/on_mob_login(datum/source, mob/new_login)
	SIGNAL_HANDLER
	//Register the required signals
	RegisterSignal(new_login, COMSIG_PARENT_MOVED_RELAY, PROC_REF(on_mob_moved))
	RegisterSignal(new_login, COMSIG_MOB_LOGOUT, PROC_REF(on_mob_logout))

/datum/controller/subsystem/parallax/proc/on_mob_logout(mob/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_PARENT_MOVED_RELAY)
	UnregisterSignal(source, COMSIG_MOB_LOGOUT)

/datum/controller/subsystem/parallax/proc/on_mob_moved(mob/moving_mob, atom/parent, force)
	SIGNAL_HANDLER
	update_client_parallax(moving_mob.client)

//We need a client var for optimisation purposes
/client
	var/parallax_update_queued = FALSE
	var/last_parallax_update_tick

/datum/controller/subsystem/parallax/proc/update_client_parallax(client/updater, force = FALSE)
	//Already queued for update
	if(!updater || updater?.parallax_update_queued)
		return
	//If we haven't updated yet, instantly update
	if (updater?.last_parallax_update_tick < times_fired || force)
		if ((throttle_ghosts && isobserver(updater.mob)) || (throttle_all))
			updater?.mob?.hud_used?.freeze_parallax()
		else
			updater?.mob?.hud_used?.update_parallax()
		//Don't allow an instant update on the next fire, to maintain parallax_free_fire_delay_ticks fire per tick max
		updater?.last_parallax_update_tick = times_fired + parallax_free_fire_delay_ticks
		return
	//Mark it as being queued
	updater?.parallax_update_queued = TRUE
	queued += updater
>>>>>>> 7d11b2f84d (515 Compatibility (#8648))
