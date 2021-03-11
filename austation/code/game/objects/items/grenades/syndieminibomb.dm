/obj/item/grenade/syndieminibomb
  var/open_panel = 0

/obj/item/grenade/syndieminibomb/Initialize()
	. = ..()
	wires = new /datum/wires/explosive/minibomb(src)

/obj/item/grenade/syndieminibomb/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/empprotection, EMP_PROTECT_WIRES)


/obj/item/grenade/syndieminibomb/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		open_panel = !open_panel
		to_chat(user, "<span class='notice'>You [open_panel ? "open" : "close"] the wire panel.</span>")
	else if(is_wire_tool(I))
		wires.interact(user)
	else if(I.tool_behaviour == TOOL_WIRECUTTER)
		switch(det_time)
			if (1)
				det_time = 10
				to_chat(user, "<span class='notice'>You set the [name] for 1 second detonation time.</span>")
			if (10)
				det_time = 30
				to_chat(user, "<span class='notice'>You set the [name] for 3 second detonation time.</span>")
			if (30)
				det_time = 50
				to_chat(user, "<span class='notice'>You set the [name] for 5 second detonation time.</span>")
			if (50)
				det_time = 1
				to_chat(user, "<span class='notice'>You set the [name] for instant detonation.</span>")
		add_fingerprint(user)
	else
		return
