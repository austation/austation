/client/proc/obnoxious()
	set category = "Admin"
	set name = "Obnoxious Mode"
	set desc = "Assume your true form and rule the station."
	if(holder)
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			if(O.icon_state == "eldrich_bw")
				O.icon = 'icons/mob/mob.dmi'
				O.icon_state = "ghost"
				O.color = "#ffffffff"
				O.restore_ghost_appearance()
				O.desc = "It's a g-g-g-g-ghooooost!"
				O.invisibility = initial(O.invisibility)
				to_chat(mob, "<span class='adminnotice'><b>You return to your usual form.</b></span>")
			else
				O.icon = 'austation/icons/mob/mob.dmi'
				O.icon_state = "eldrich_bw"
				O.color = prefs.ooccolor // nice
				O.invisibility = 0
				O.overlays = null
				O.name = "Eldrich Being"
				O.desc = "A small protrusion of an incredibly powerful eldrich being into this realm. You can feel its omnipotent gaze upon you..."
				to_chat(mob, "<span class='boldannounce'>You assume your true form, in all its administrative glory!</span>")
				message_admins()
			log_admin("[key_name(usr)] has turned obnoxious mode [O.icon_state == "eldrich_bw" ? "ON" : "OFF"]")
			message_admins("[key_name_admin(usr)] has turned obnoxious mode [O.icon_state == "eldrich_bw" ? "ON" : "OFF"]")
		else
			to_chat(mob, "<span class='boldannounce'>You must be observing to use this feature!</span>")
