//Update the screentip to reflect what we're hoverin over
/atom/MouseEntered(location, control, params)
	. = ..()
	if(flags_1 & NO_SCREENTIPS_1 || !usr?.client?.prefs.screentip_pref)
		usr.hud_used.screentip_text.maptext = ""
		return
	usr.hud_used.screentip_text.maptext = MAPTEXT("<span style='text-align: center'><span style='font-size: 32px'><span style='color:[usr.client.prefs.screentip_color]: 32px'>[name]</span>")
