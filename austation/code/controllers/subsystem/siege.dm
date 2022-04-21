SUBSYSTEM_DEF(siege)
	name = "siege gamemode controller"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 1 MINUTES

	var/starttime
	var/targettime

/datum/controller/subsystem/siege/Initialize(timeofday)
	if(GLOB.master_mode == "siege")
		starttime = world.time
		targettime = starttime + 100 // 18000 = 30 Minutes 600/Minute
		. = ..()
	else
		SSsiege.pause()

/datum/controller/subsystem/siege/fire()
	if(SSticker.mode.gamemode_status == 0)
		priority_announce("The syndicate has united and is launching an all out war on NanoTrasen! \
			Protect the station for as long as possible, until you can be relieved. \
			Surrounding stations have been attacked. Intelligence indicates that your station has 40 minutes to prepare for an invasion. \
			Syndicate operatives are suspected to be aboard, Station Security is authorised the highest level of force.", "NanoTrasen Central Command War Report",
			'sound/misc/notice1.ogg', "Priority")
		set_security_level("red")
	else if(world.time > targettime)
		if(SSticker.mode.gamemode_status == 1)
			for(var/obj/machinery/siege_spawner/spawners in GLOB.poi_list)
				notify_ghosts("Siege spawning has been enabled!", 'sound/effects/ghost2.ogg', enter_link="<a href=?src=[REF(spawners)];join=1>(Click to join the Syndicates!)</a> or click on the controller directly!", source = spawners, action=NOTIFY_ATTACK, header = "Siege Starting")
			targettime += 1000 //30 minutes
		else if(SSticker.mode.gamemode_status == 2)
			SSsiege.pause()
			return
	SSticker.mode.gamemode_status++
