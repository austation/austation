
/datum/hud
	var/atom/movable/screen/screentip/screentip_text

/datum/hud/New(mob/owner)
	. = ..()
	screentip_text = new(null, src)
	static_inventory += screentip_text
