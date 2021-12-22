//  ported from citadel, credit to "silicons" for the orignal code


//because I don't want to change original pet carrier code for austation, I'm making it it's own object



//bluespace jar, a reskin of the pet carrier that can fit people and smashes when thrown
#define bluespace_jar_full(jar) jar.occupants.len >= jar.max_occupants || jar.occupant_weight >= jar.max_occupant_weight

/obj/item/bluespace_jar
	name = "bluespace jar"
	desc = "A jar, that seems to be bigger on the inside, somehow allowing lifeforms to fit through its narrow entrance."
	icon = 'austation/icons/obj/bluespace_jar.dmi'
	icon_state = "bluespace_jar"
	item_state = "bluespace_jar"
	force = 5
	attack_verb = list("bashed", "carried")
	lefthand_file = ""
	righthand_file = ""
	throw_speed = 2
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL //it's a jar
	var/open = FALSE //starts closed so it looks better on menus
	var/locked = FALSE
	var/list/occupants = list()
	var/occupant_weight = 0
	var/max_occupants = 1 //Hard-cap so you can't have infinite mice or something in one jar
	var/max_occupant_weight = MOB_SIZE_HUMAN //This is calculated from the mob sizes of occupants
	var/entrance_name = "lid" //name of the entrance to the item
	var/escape_time = 10 //how long it takes for mobs above small sizes to escape (for small sizes, its randomly 1.5 to 2x this)
	var/load_time = 40 //how long it takes for mobs to be loaded into the jar
	var/has_lock_sprites = FALSE //whether to load the lock overlays or not
	var/allows_hostiles = TRUE //does the jar allow hostile entities to be held within it?
	var/datum/gas_mixture/occupant_gas_supply
	var/sipping_level = 150 //level until the reagent gets INGEST ed instead of TOUCH
	var/sipping_probably = 99 //prob50 level of sipping
	var/transfer_rate = 5 //chem transfer rate / second

/obj/item/bluespace_jar/Initialize()
	. = ..()
	create_reagents(300, OPENCONTAINER) //equivalent of bsbeakers

/obj/item/bluespace_jar/Destroy()
	if(occupants.len)
		for(var/V in occupants)
			remove_occupant(V)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/bluespace_jar/Exited(atom/movable/occupant)
	. = ..()
	if(occupant in occupants && isliving(occupant))
		var/mob/living/L = occupant
		occupants -= occupant
		occupant_weight -= L.mob_size

/obj/item/bluespace_jar/handle_atom_del(atom/A)
	if(A in occupants && isliving(A))
		var/mob/living/L = A
		occupants -= L
		occupant_weight -= L.mob_size
	..()

/obj/item/bluespace_jar/examine(mob/user)
	. = ..()
	if(occupants.len)
		for(var/V in occupants)
			var/mob/living/L = V
			. += "<span class='notice'>It has [L] inside.</span>"
	else
		. += "<span class='notice'>It has nothing inside.</span>"
	if(user.canUseTopic(src))
		. += "<span class='notice'>Activate it in your hand to [open ? "close" : "open"] its [entrance_name].</span>"
		if(!open)
			. += "<span class='notice'>Alt-click to [locked ? "unlock" : "lock"] its [entrance_name].</span>"

/obj/item/bluespace_jar/attack_self(mob/living/user)
	if(reagents)
		if(open)
			reagents.flags = NONE
		else
			reagents.flags = OPENCONTAINER
	if(open)
		to_chat(user, "<span class='notice'>You close [src]'s [entrance_name].</span>")
		playsound(user, 'sound/effects/bin_close.ogg', 50, TRUE)
		open = FALSE
	else
		if(locked)
			to_chat(user, "<span class='warning'>[src] is locked!</span>")
			return
		to_chat(user, "<span class='notice'>You open [src]'s [entrance_name].</span>")
		playsound(user, 'sound/effects/bin_open.ogg', 50, TRUE)
		open = TRUE
	update_icon()

/obj/item/bluespace_jar/AltClick(mob/living/user)
	. = ..()
	if(open || !user.canUseTopic(src, BE_CLOSE))
		return
	locked = !locked
	to_chat(user, "<span class='notice'>You flip the lock switch [locked ? "down" : "up"].</span>")
	if(locked)
		playsound(user, 'sound/machines/boltsdown.ogg', 30, TRUE)
	else
		playsound(user, 'sound/machines/boltsup.ogg', 30, TRUE)
	update_icon()
	return TRUE

/obj/item/bluespace_jar/attack(mob/living/target, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!open)
		to_chat(user, "<span class='warning'>You need to open [src]'s [entrance_name]!</span>")
		return
	if(target.mob_size > max_occupant_weight)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(iscatperson(H))
				to_chat(user, "<span class='warning'>You'd need a lot of catnip and treats, plus maybe a laser pointer, for that to work.</span>")
			else
				to_chat(user, "<span class='warning'>Humans, generally, do not fit into [name]s.</span>")
		else
			to_chat(user, "<span class='warning'>You get the feeling [target] isn't meant for a [name].</span>")
		return
	if(user == target)
		to_chat(user, "<span class='warning'>Why would you ever do that?</span>")
		return
	if(ishostile(target) && !allows_hostiles && target.move_resist < MOVE_FORCE_VERY_STRONG) //don't allow goliaths into jars
		to_chat(user, "<span class='warning'>You have a feeling you shouldn't keep this as a pet.</span>")
	load_occupant(user, target)

/obj/item/bluespace_jar/relaymove(mob/living/user, direction)
	if(open)
		loc.visible_message("<span class='notice'>[user] climbs out of [src]!</span>", \
		"<span class='warning'>[user] jumps out of [src]!</span>")
		remove_occupant(user)
		return
	else if(!locked)
		loc.visible_message("<span class='notice'>[user] pushes open the [entrance_name] to [src]!</span>", \
		"<span class='warning'>[user] pushes open the [entrance_name] of [src]!</span>")
		open = TRUE
		update_icon()
		return
	else if(user.client)
		container_resist(user)

/obj/item/bluespace_jar/container_resist(mob/living/user)
	//don't do the whole resist timer thing if it's open!
	if(open)
		loc.visible_message("<span class='notice'>[user] climbs out of [src]!</span>", \
		"<span class='warning'>[user] jumps out of [src]!</span>")
		remove_occupant(user)
		return

	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	if(user.mob_size <= MOB_SIZE_SMALL)
		to_chat(user, "<span class='notice'>You begin to try escaping the [src] and start fumbling for the lock switch... (This will take some time.)</span>")
		to_chat(loc, "<span class='warning'>You see [user] attempting to unlock the [src]!</span>")
		if(!do_after(user, rand(escape_time * 1.5, escape_time * 2), target = user) || open || !locked || !(user in occupants))
			return
		loc.visible_message("<span class='warning'>[user] flips the lock switch on [src] by reaching through!</span>", null, null, null, user)
		to_chat(user, "<span class='boldannounce'>Bingo! The lock pops open!</span>")
		locked = FALSE
		playsound(src, 'sound/machines/boltsup.ogg', 30, TRUE)
		update_icon()
	else
		loc.visible_message("<span class='warning'>[src] starts rattling as something pushes against the [entrance_name]!</span>", null, null, null, user)
		to_chat(user, "<span class='notice'>You start pushing out of [src]... (This will take about 20 seconds.)</span>")
		if(!do_after(user, escape_time, target = user) || open || !locked || !(user in occupants))
			return
		loc.visible_message("<span class='warning'>[user] shoves out of	[src]!</span>", null, null, null, user)
		to_chat(user, "<span class='notice'>You shove open [src]'s [entrance_name] against the lock's resistance and fall out!</span>")
		locked = FALSE
		open = TRUE
		update_icon()
		remove_occupant(user)

/obj/item/bluespace_jar/update_icon_state()
	. = ..()
	if(open)
		icon_state = initial(icon_state)
	else
		icon_state = "bluespace_jar_[!occupants.len ? "closed" : "occupied"]"


/obj/item/bluespace_jar/MouseDrop(atom/over_atom)
	if(isopenturf(over_atom) && usr.canUseTopic(src, BE_CLOSE, ismonkey(usr)) && usr.Adjacent(over_atom) && open && occupants.len)
		usr.visible_message("<span class='notice'>[usr] unloads [src].</span>", \
		"<span class='notice'>You unload [src] onto [over_atom].</span>")
		for(var/V in occupants)
			remove_occupant(V, over_atom)
	else
		return ..()

/obj/item/bluespace_jar/proc/load_occupant(mob/living/user, mob/living/target)
	if(bluespace_jar_full(src))
		to_chat(user, "<span class='warning'>[src] is already carrying too much!</span>")
		return
	user.visible_message("<span class='notice'>[user] starts loading [target] into [src].</span>", \
	"<span class='notice'>You start loading [target] into [src]...</span>", null, null, target)
	to_chat(target, "<span class='userdanger'>[user] starts loading you into [user.p_their()] [name]!</span>")
	if(!do_mob(user, target, load_time))
		return
	if(target in occupants)
		return
	if(bluespace_jar_full(src)) //Run the checks again, just in case
		to_chat(user, "<span class='warning'>[src] is already carrying too much!</span>")
		return
	user.visible_message("<span class='notice'>[user] loads [target] into [src]!</span>", \
	"<span class='notice'>You load [target] into [src].</span>", null, null, target)
	to_chat(target, "<span class='userdanger'>[user] loads you into [user.p_their()] [name]!</span>")
	add_occupant(target)

/obj/item/bluespace_jar/proc/add_occupant(mob/living/occupant)
	if(occupant in occupants || !istype(occupant))
		return
	occupant.forceMove(src)
	occupants += occupant
	occupant_weight += occupant.mob_size

/obj/item/bluespace_jar/proc/remove_occupant(mob/living/occupant, turf/new_turf)
	if(!(occupant in occupants) || !istype(occupant))
		return
	occupant.forceMove(new_turf ? new_turf : get_turf(src))
	occupants -= occupant
	occupant_weight -= occupant.mob_size
	occupant.setDir(SOUTH)


/obj/item/bluespace_jar/update_icon_state()
	if(open)
		icon_state = "bluespace_jar_open"
	else
		icon_state = "bluespace_jar"

/obj/item/bluespace_jar/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	//delete the item upon impact, releasing the creature inside (this is handled by its deletion)
	if(occupants.len)
		loc.visible_message("<span class='warning'>The bluespace jar smashes, releasing [occupants[1]]!</span>")

	if(reagents?.total_volume && ismob(hit_atom) && hit_atom.reagents && open)
		reagents.total_volume *= rand(5,10) * 0.1 //Not all of it makes contact with the target
		var/mob/M = hit_atom
		var/R = reagents.log_list()
		hit_atom.visible_message("<span class='danger'>[M] has been splashed with something!</span>", \
						"<span class='userdanger'>[M] has been splashed with something!</span>")
		var/turf/TT = get_turf(hit_atom)
		if(thrownby)
			log_combat(thrownby, M, "splashed", R)
			message_admins("[ADMIN_LOOKUPFLW(thrownby)] splashed (thrown) [english_list(reagents.reagent_list)] on [TT] at [ADMIN_VERBOSEJMP(TT)].")
		reagents.reaction(hit_atom, TOUCH)
		reagents.clear_reagents()

	playsound(src, "shatter", 70, 1)
	qdel(src)

/obj/item/bluespace_jar/add_occupant(mob/living/occupant) //update the gas supply as required, this acts like magical internals
	. = ..()
	if(!occupant_gas_supply)
		occupant_gas_supply = new
	if(ishuman(occupant)) //humans require resistance to cold/heat and living in no air while inside, and lose this when outside
		START_PROCESSING(SSobj, src)
		ADD_TRAIT(occupant, TRAIT_RESISTCOLD, "bluespace_container_cold_resist")
		ADD_TRAIT(occupant, TRAIT_RESISTHEAT, "bluespace_container_heat_resist")
		ADD_TRAIT(occupant, TRAIT_NOBREATH, "bluespace_container_no_breath")
		ADD_TRAIT(occupant, TRAIT_RESISTHIGHPRESSURE, "bluespace_container_resist_high_pressure")
		ADD_TRAIT(occupant, TRAIT_RESISTLOWPRESSURE, "bluespace_container_resist_low_pressure")

/obj/item/bluespace_jar/remove_occupant(mob/living/occupant)
	. = ..()
	if(ishuman(occupant))
		STOP_PROCESSING(SSobj, src)
		REMOVE_TRAIT(occupant, TRAIT_RESISTCOLD, "bluespace_container_cold_resist")
		REMOVE_TRAIT(occupant, TRAIT_RESISTHEAT, "bluespace_container_heat_resist")
		REMOVE_TRAIT(occupant, TRAIT_NOBREATH, "bluespace_container_no_breath")
		REMOVE_TRAIT(occupant, TRAIT_RESISTHIGHPRESSURE, "bluespace_container_resist_high_pressure")
		REMOVE_TRAIT(occupant, TRAIT_RESISTLOWPRESSURE, "bluespace_container_resist_low_pressure")

/obj/item/bluespace_jar/process()
	if(!reagents)
		return
	for(var/mob/living/L in occupants)
		if(!ishuman(L))
			continue
		if((reagents.total_volume >= sipping_level) || ((reagents.total_volume >= sipping_probably) && prob(50))) //sipp
			reagents.reaction(L, INGEST) //consume
			reagents.trans_to(L, transfer_rate)
		else
			reagents.reaction(L, TOUCH, show_message = FALSE)

/obj/item/bluespace_jar/return_air()
	if(!occupant_gas_supply)
		occupant_gas_supply = new
	return occupant_gas_supply


/obj/item/bluespace_jar/badmin //adminboos time
	escape_time = 10000
	load_time = 1
	max_occupants = 100
