PROCESSING_SUBSYSTEM_DEF(siege)
	name = "siege gamemode controller"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 1 MINUTES
	runlevels = RUNLEVEL_GAME
	init_order = INIT_ORDER_TICKER

	var/starttime
	var/targettime

/datum/controller/subsystem/processing/siege/Initialize(timeofday)
	message_admins("AAA")
	if(GLOB.master_mode == "siege")
		message_admins("AAA2")
		starttime = world.time
		targettime = starttime + 100 // 18000 = 30 Minutes 600/Minute
		priority_announce("The syndicate has united and is launching an all out war on NanoTrasen! \
			Protect the station for as long as possible, until you can be relieved. \
			Surrounding stations have been attacked. Intelligence indicates that your station has 40 minutes to prepare for an invasion. \
			Syndicate operatives are suspected to be aboard, Station Security is authorised the highest level of force.", "NanoTrasen Central Command War Report",
			null, 'sound/misc/notice1.ogg', "Priority")
		set_security_level("red")
		message_admins("AAA3")
		. = ..()
	else
		SSsiege.pause()

/datum/controller/subsystem/processing/siege/fire()
	if(SSticker.HasRoundStarted())

	else if(world.time > targettime)
		if(SSticker.mode.gamemode_status == 0)
			notify_ghosts("Siege spawning has been enabled!",'sound/effects/ghost2.ogg')
			targettime += 1000 //30 minutes
			priority_announce("The syndicate has united and is launching an all out war on NanoTrasen! \
			Protect the station for as long as possible, until you can be relieved. \
			Initial reports state that your station has 30 minutes to prepare for invasion.", "NanoTrasen Central Command War Report",
			null, 'sound/misc/notice1.ogg', "Priority")
		else if(SSticker.mode.gamemode_status == 1)
			SSsiege.pause()
		SSticker.mode.gamemode_status++
