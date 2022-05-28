SUBSYSTEM_DEF(siege)
	name = "siege gamemode controller"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 1 MINUTES

	var/starttime
	var/targettime
	var/phasedelay = 60

/datum/controller/subsystem/siege/Initialize(timeofday)
	starttime = REALTIMEOFDAY
	targettime = starttime + phasedelay MINUTES

	if(GLOB.master_mode != "siege")
		can_fire = FALSE
	. = ..()

/datum/controller/subsystem/siege/fire()
	if(SSticker.mode.gamemode_status == 0 && REALTIMEOFDAY > 100)//Prevent this being called before players have loaded in
		set_security_level("red")
		priority_announce("The syndicate has united and is launching an all out war on NanoTrasen! \
			Protect the station for as long as possible, until you can be relieved. \
			Surrounding stations have been attacked. Intelligence indicates that your station has [phasedelay] minutes to prepare for an invasion. \
			Syndicate operatives are suspected to be aboard, Station Security is authorised the highest level of force.", "NanoTrasen Central Command War Report",
			'sound/misc/notice1.ogg', "Priority")
	else if(REALTIMEOFDAY > targettime)
		if(SSticker.mode.gamemode_status == 1)
			for(var/obj/machinery/siege_spawner/spawners in GLOB.poi_list)
				notify_ghosts("Siege spawning has been enabled!", 'sound/effects/ghost2.ogg', enter_link="<a href=?src=[REF(spawners)];join=1>(Click to join the Syndicates!)</a> or click on the controller directly!", source = spawners, action=NOTIFY_ATTACK, header = "Siege Starting")
			targettime += 20 MINUTES
		else
			can_fire = FALSE
			return
	SSticker.mode.gamemode_status++
