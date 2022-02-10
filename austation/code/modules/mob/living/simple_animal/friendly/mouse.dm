/mob/living/simple_animal/mouse
	faction = list("rat")

/mob/living/simple_animal/mouse/handle_automated_action()
	if(prob(chew_probability))
		var/turf/open/floor/F = get_turf(src)
		if(istype(F) && !F.intact)
			var/obj/structure/cable/C = locate() in F
			if(C && prob(15))
				if(C.avail())
					visible_message("<span class='warning'>[src] chews through the [C]. It's toast!</span>")
					playsound(src, 'sound/effects/sparks2.ogg', 100, 1)
					C.deconstruct()
					death(toast=1)
				else
					C.deconstruct()
					visible_message("<span class='warning'>[src] chews through the [C].</span>")
	for(var/obj/item/reagent_containers/food/snacks/cheesewedge/cheese in range(1, src))
		if(prob(10))
			be_fruitful()
			qdel(cheese)
			return
	for(var/obj/item/reagent_containers/food/snacks/royalcheese/bigcheese in range(1, src))
		qdel(bigcheese)
		evolve()
		return

/mob/living/simple_animal/mouse/Destroy()
	SSmobs.cheeserats -= src
	return ..()


/**
  *Checks the mouse cap, if it's above the cap, doesn't spawn a mouse. If below, spawns a mouse and adds it to cheeserats.
  */
/mob/living/simple_animal/mouse/proc/be_fruitful()
	var/cap = CONFIG_GET(number/ratcap)
	if(LAZYLEN(SSmobs.cheeserats) >= cap)
		visible_message("<span class='warning'>[src] carefully eats the cheese, hiding it from the [cap] mice on the station!</span>")
		return
	var/mob/living/newmouse = new /mob/living/simple_animal/mouse(loc)
	SSmobs.cheeserats += newmouse
	visible_message("<span class='notice'>[src] nibbles through the cheese, attracting another mouse!</span>")

/**
  *Spawns a new regal rat, says some good jazz, and if sentient, transfers the relivant mind.
  */
/mob/living/simple_animal/mouse/proc/evolve()
	var/mob/living/simple_animal/hostile/regalrat = new /mob/living/simple_animal/hostile/regalrat(loc)
	visible_message("<span class='warning'>[src] devours the cheese! He morphs into something... greater!</span>")
	regalrat.say("RISE, MY SUBJECTS! SCREEEEEEE!")
	if(mind)
		mind.transfer_to(regalrat)
	qdel(src)

