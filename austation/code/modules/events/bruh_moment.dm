/datum/round_event_control/bruh_moment
	name = "Bruh Moment"
	typepath = /datum/round_event/bruh_moment
	weight = 5
	min_players = 1
	earliest_start = 10 MINUTES
	max_occurrences = 1

/datum/round_event/bruh_moment
	startWhen = 8
	fakeable = FALSE

/datum/round_event/bruh_moment/start()
	for(var/mob/B in shuffle(GLOB.alive_mob_list))
		B.emote("bruh")
		sleep(0.2)

/datum/round_event/bruh_moment/announce()
	priority_announce("NanoTrasen is issuing a Bruh Moment warning. Please stand by.", "Bruhspace Anomaly")
