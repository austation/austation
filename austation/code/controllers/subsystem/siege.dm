SUBSYSTEM_DEF(siege)
	name = "siege gamemode controller"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 1 MINUTES

	var/starttime
	var/targettime
	var/gamemode_status
	var/datum/team/siege/team

/datum/controller/subsystem/siege/Initialize(timeofday)
	if(GLOB.master_mode == "siege")
		starttime = world.time
		targettime = starttime + 100 // 18000 = 30 Minutes 600/Minute
		priority_announce("The syndicate has united and is launching an all out war on NanoTrasen! \
			Protect the station for as long as possible, until you can be relieved. \
			Surrounding stations have been attacked. Intelligence indicates that your station has 40 minutes to prepare for an invasion. \
			Syndicate operatives are suspected to be aboard, Station Security is authorised the highest level of force.", "NanoTrasen Central Command War Report",
			null, 'sound/misc/notice1.ogg', "Priority")
		set_security_level("red")
		. = ..()
	else
		SSsiege.pause()


/datum/controller/subsystem/siege/fire()
	if(world.time > targettime)
		if(gamemode_status == 0)
			notify_ghosts("Siege spawning has been enabled!",'sound/effects/ghost2.ogg')
			targettime += 1000 //30 minutes
			priority_announce("The syndicate has united and is launching an all out war on NanoTrasen! \
			Protect the station for as long as possible, until you can be relieved. \
			Initial reports state that your station has 30 minutes to prepare for invasion.", "NanoTrasen Central Command War Report",
			null, 'sound/misc/notice1.ogg', "Priority")
		else if(gamemode_status == 1)
			SSsiege.pause()
		gamemode_status++
