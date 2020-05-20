/datum/round_event_control/sun_burst
	name = "Sun Burst"
	typepath = /datum/round_event/sun_burst
	max_occurrences = 1

/datum/round_event/sun_burst


/datum/round_event/sun_burst/setup()
	startWhen = 3
	endWhen = startWhen + 1
	announceWhen	= 1

/datum/round_event/sun_burst/announce(fake)
	priority_announce("The station's orbit is reaching a dangerously close distance to the nearby star. All EVA operations are to be halted until further notice.", "Anomaly Alert", 'sound/ai/radiation.ogg')

/datum/round_event/sun_burst/start()
	SSweather.run_weather(/datum/weather/sun_burst)
