/turf/closed/wall
  var/max_durability = 200
  var/durability = 200
  var/damage_threshold = 20

/turf/closed/wall/try_clean(obj/item/W, mob/user, turf/T)
	if((user.a_intent != INTENT_HELP) || !LAZYLEN(dent_decals))
		return FALSE

	if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, "<span class='notice'>You begin fixing dents on the wall...</span>")
		if(W.use_tool(src, user, 0, volume=100))
			if(iswallturf(src) && LAZYLEN(dent_decals))
				to_chat(user, "<span class='notice'>You fix some dents on the wall.</span>")
				cut_overlay(dent_decals)
				dent_decals.Cut()

				durability = max_durability
			return TRUE
