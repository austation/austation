//Sunbursts are a period when the station's orbit is too close to the nearby star, this results in any living mob in space gets flashed and burned.
/datum/weather/sun_burst
	name = "sun burst"
	desc = "a period where the station's orbit is close enough to the nearest star to cause severe damage to EVA operations"

	telegraph_duration = 400
	telegraph_message = "<span class='danger'>The hull begins to crack and creak arounds you.</span>"

	weather_message = "<span class='userdanger'><i>It's getting too bright! Get back in the station!</i></span>"
	weather_overlay = "sun_burst"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_color = "white"
	weather_sound = 'sound/misc/bloblarm.ogg'

	end_duration = 100
	end_message = "<span class='notice'>The radiant heat begins to dissipate.</span>"

	area_type = /area/space
	target_trait = ZTRAIT_STATION

	immunity_type = "lava"

/datum/weather/sun_burst/telegraph()
	..()
	status_alarm(TRUE)


/datum/weather/sun_burst/weather_act(mob/living/L)
	var/light_intensity = 1
	L.adjustFireLoss(20)
	L.adjust_fire_stacks(20)
	L.IgniteMob()
	L.flash_act(min(light_intensity,1))

/datum/weather/sun_burst/end()
	if(..())
		return
	priority_announce("The station's orbit has stabilized in a safe distance from the star. All suspended EVA operations are to be continued", "Anomaly Alert")
	status_alarm(FALSE)

/datum/weather/sun_burst/proc/status_alarm(active)	//Makes the status displays show the radiation warning for those who missed the announcement.
	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)
	if(!frequency)
		return

	var/datum/signal/signal = new
	if (active)
		signal.data["command"] = "alert"
		signal.data["picture_state"] = "radiation"
	else
		signal.data["command"] = "shuttle"

	var/atom/movable/virtualspeaker/virt = new(null)
	frequency.post_signal(virt, signal)
