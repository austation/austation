var/static/list/notradkillable = typesof(/obj/item/twohanded/required/fuel_rod) + typesof(/obj/machinery/atmospherics/components/trinary/nuclear_reactor)
//shamelessly copied from fix_air(), well most of it anyways
/client/proc/kill_rads(var/turf/open/T in world)
	set name = "Kill Rads"
	set category = "Admin"
	set desc = "Kills all radiation components in specified radius."

	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	if(check_rights(R_ADMIN,1))
		var/range=input("Enter range:","Num",2) as num
		message_admins("[key_name_admin(usr)] killed rads with range [range] in area [T.loc.name]")
		log_game("[key_name_admin(usr)] killed rads with range [range] in area [T.loc.name]")
		for(var/atom/things in range(range,T))
			if(things.type in notradkillable)
				continue
			if(typesof(things, /mob/living))
				var/mob/living/L = things
				L.radiation = 0
			for(var/datum/component/radioactive/R in things.GetComponents(/datum/component/radioactive))
				qdel(R)
