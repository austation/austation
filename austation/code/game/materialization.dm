/obj/structure/table/mat_shiritori
	name = "\improper Materialization Shiritori"
	desc = "A magical Shiritori table capable of temporarily materializing any object that exists in this reality."
	icon = 'austation/icons/obj/structures.dmi'
	icon_state = "shiritori"
	max_integrity = 300
	canSmoothWith = list()
	flags_1 = NODECONSTRUCT_1
	var/current_letter
	var/time_left = 30
	var/next_tick
	var/active = FALSE
	var/static/list/atom_list // starts off as empty, we only want to make this if we have a table, otherwise we're just wasting memory
	var/static/instances = 0 // amount of tables that currently exist. Used for clearing atom list
	var/list/spent_objs = list() // typepaths that have been used before
	var/list/entities = list() // spawned entities that are currently in existance
	var/list/players = list()
	var/mob/living/carbon/human/current_player
	var/list/knockouts = list()
	var/static/list/blacklist // handled in get_blacklist()

/obj/structure/table/mat_shiritori/New()
	..()
	instances++
	atom_list = generate_name_list(typesof(/atom/movable))

/obj/structure/table/mat_shiritori/Destroy()
	if(active)
		end_game()
		return ..()
	STOP_PROCESSING(SSobj, src)
	QDEL_LIST(entities)
	current_player = null
	players = null
	knockouts = null
	return ..()

/obj/structure/table/mat_shiritori/proc/start_game()
	if(active)
		return
	instances++
	if(!atom_list)
		atom_list = generate_name_list(typesof(/atom/movable))
	players.Cut()
	knockouts.Cut()
	QDEL_LIST(entities)
	time_left = initial(time_left)
	for(var/mob/living/carbon/human/H in range(1, src))
		if(H.stat == DEAD || !H.mind?.hasSoul)
			continue
		if(HAS_TRAIT(H, TRAIT_MUTE))
			to_chat(H, "<span class='warning'>You can't play if you can't speak!</span>")
			continue
		add_player(H)
	if(length(players))
		active = TRUE
		START_PROCESSING(SSobj, src)
		return TRUE

/obj/structure/table/mat_shiritori/proc/end_game()
	if(!active)
		return
	players.Cut()
	knockouts.Cut()
	instances--
	if(instances <= 0)
		atom_list = null
		blacklist = null
	QDEL_LIST(entities)
	time_left = initial(time_left)
	current_player = null
	for(var/mob/living/carbon/human/H in players)
		to_chat(H, "<span class='info'>The game has ended.</span>")
		REMOVE_TRAIT(H, TRAIT_PACIFISM, "shiritori")
	STOP_PROCESSING(SSobj, src)
	active = FALSE


/obj/structure/table/mat_shiritori/proc/find_object(phrase as text)
	if(!(current_player in players))
		return
	phrase = lowertext(phrase)
	if(phrase[1] != current_letter)
		visible_message("<span class='warning'>Invalid word, entity must begin with a <b>[current_letter]</b></span>")
	var/Opath = atom_list[phrase]
	if(Opath)
		if(islist(Opath))
			if(Opath & spent_objs)
				visible_message("<span class='warning'>\"[phrase]\" has already been materialized. <b>[current_player] has been eliminated!</b></span>")
				to_chat(current_player, "<span class='danger'>This has been said before, you've been eliminated!</span>")
				remove_player(current_player)
				return
			Opath -= blacklist
			Opath = pick(Opath)
		if(Opath in spent_objs)
			visible_message("<span class='warning'>\"[phrase]\" has already been materialized. <b>[current_player] has been eliminated!</b></span>")
			to_chat(current_player, "<span class='danger'>This has been said before, you've been eliminated!</span>")
			remove_player(current_player)
			return
		if(Opath in get_blacklist())
			visible_message("<span class='warning'>Entity too vague.</span>")
			return
		var/obj/item/shiritori_ball/ball = new(loc)
		ball.start_spawn(src, Opath)
		current_player.put_in_hands(ball)
		spent_objs.Add(Opath)
		current_letter = phrase[length(phrase)]
		playsound(src, 'sound/magic/clockwork/invoke_general.ogg', 100, TRUE)
		switch_player()
	else
		visible_message("<span class='warning'>Invalid entity.</span>")

/obj/structure/table/mat_shiritori/proc/add_player(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if((H in players) || (H in knockouts))
		return
	players.Add(H)
	to_chat(H, "<span class='notice'>Welcome to <b>Materialization Shiritori!</b> \n
				Similar to traditional Shiritori, but any valid word submitted by the player will materialize infront of them, as long as it exists in this world.</span> \n
				<span class='info'>The last player standing is declared as the winner, players can be eliminated in 3 different ways: \n
				<b>1:/b> Failing to name a valid entity within 30 seconds of the last player's turn. \n
				<b>2:/b> Attempting to summon an entity that has already been mentioned. \n
				<b>3:</b> Death. \n
				You cannot harm your opponents through <b>direct</b> means. Any and all summoned entities will be destroyed once the game has concluded.")
	ADD_TRAIT(H, TRAIT_PACIFISM, "shiritori")

/obj/structure/table/mat_shiritori/proc/remove_player(mob/living/carbon/human/H, elimination = TRUE)
	players.Remove(H)
	knockouts.Add(H)
	if(current_player == H)
		switch_player()
	if(!QDELETED(H) && istype(H)) // in case they got gibbed or something weird happened
		REMOVE_TRAIT(H, TRAIT_PACIFISM, "shiritori")
	if(elimination)
		visible_message("<span class='danger'>[H] has been eliminated!</span>")
	if(length(players) == 1)
		visible_message("<span class='boldannounce'>[current_player] has won the game!</span>")
		playsound(src, 'sound/effects/gong.ogg', 250, 0, 5)
		playsound(src, 'sound/effects/bamf.ogg', 100, 0, 5)
		end_game()


/obj/structure/table/mat_shiritori/proc/switch_player()
	var/index = players.Find(current_player)
	if(length(players) == index)
		index = 1
	time_left = initial(time_left)
	current_player = players[index]
	to_chat(current_player, "<span class='notice'>It is now your turn.</span>")

/obj/structure/table/mat_shiritori/process()
	if(!active)
		return PROCESS_KILL
	for(var/mob/living/L as() in players)
		if(QDELETED(L) || L.stat == DEAD)
			remove_player(L)
			continue
	if(world.time > next_tick)
		time_left--
		next_tick = world.time + 10
		if(time_left <= 0)
			visible_message("<span class='warning'>[current_player] has ran out of time!</span>")
			playsound(src, 'sound/effects/clock_tick.ogg', 120, FALSE, 2)
			remove_player(current_player)

/obj/structure/table/mat_shiritori/examine()
	. = ..()
	if(current_letter)
		. += "<span class='info'>The next word must start with <b>[uppertext(current_letter)]</b></span>"
	else if(!active)
		. += "<span class='info'>It doesn't look like anyone is playing it right now.</span>"







/obj/item/shiritori_ball
	name = "materialization ball"
	desc = "Materializes selected entities at it's location after a short delay."
	icon = 'austation/icons/obj/items.dmi'
	icon_state = "shiri_ball"
	var/entity_path
	var/countdown = 5
	var/next_tick
	var/obj/structure/table/mat_shiritori/table


/obj/item/shiritori_ball/Destroy()
	table = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/shiritori_ball/proc/start_spawn(obj/structure/table/mat_shiritori/table, entity_path)
	src.entity_path = entity_path
	src.table = table
	if(!entity_path)
		qdel(src)
		return
	START_PROCESSING(SSobj, src)

/obj/item/shiritori_ball/process()
	if(countdown > 0)
		if(world.time > next_tick)
			countdown--
			next_tick - world.time + 10
		return
	var/atom/movable/M = new entity_path(loc)
	table.entities.Add(M)
	qdel(src)
	return PROCESS_KILL

/obj/structure/table/mat_shiritori/proc/get_blacklist()
	if(!blacklist)
		blacklist = list(
			/obj/effect/decal/cleanable,
			/obj/item/radio/headset,
			/obj/item/clothing/head/helmet/space,
			/obj/item/book/manual,
			/obj/item/reagent_containers/food/drinks,
			/obj/item/reagent_containers/food,
			/obj/item/reagent_containers,
			/obj/machinery/atmospherics,
			/obj/machinery/portable_atmospherics,
			/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack,
			/obj/item/mecha_parts/mecha_equipment,
			/obj/item/storage,
			/obj/item/clothing,
			/obj/item/stock_parts,
			/obj/item/gun,
			/obj/item/organ,
			/obj/item,
			/obj/machinery/power,
			/obj/machinery,
			/obj/effect,
			/obj,
			/mob/living/carbon,
			/mob/living/simple_animal,
			/mob/living,
			/mob
			)
	return blacklist
