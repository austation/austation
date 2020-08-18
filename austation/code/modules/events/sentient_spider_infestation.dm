/datum/round_event_control/sentient_spider_infestation
	name = "Sentient Spider Infestation"
	typepath = /datum/round_event/sentient_spider_infestation
	weight = 5
	max_occurrences = 1
	min_players = 15

/datum/round_event/sentient_spider_infestation
	announceWhen	= 400
	var/spawncount = 1

/datum/round_event/sentient_spider_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
	spawncount = rand(1, 2)

/datum/round_event/sentient_spider_infestation/announce(fake)
	priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", 'sound/ai/aliens.ogg')

/datum/round_event/sentient_spider_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/temp_vent in GLOB.machines)
		if(QDELETED(temp_vent))
			continue
		if(is_station_level(temp_vent.loc.z) && !temp_vent.welded)
			var/datum/pipeline/temp_vent_parent = temp_vent.parents[1]
			if(temp_vent_parent.other_atmosmch.len > 20)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		var/obj/structure/spider/spiderling/nurse/S = new(vent.loc)
		S.player_spiders = 1
		announce_to_ghosts(S)
		vents -= vent
		spawncount--
