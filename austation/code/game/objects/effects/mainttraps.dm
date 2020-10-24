/obj/effect/trap/nexus/doorbolt/wikipedia
	name = "wikipedia"
	desc = "the free online encyclopedia that ANYONE can edit"
	var/cocktime = 199 SECONDS

/obj/effect/trap/nexus/doorbolt/wikipedia/TrapEffect(AM)
	for(var/mob/living/carbon/human/C in range(5, src))
		if(C.mind)
			playsound(C,'austation/sound/misc/wikipedia.ogg', 100)
	stoplag(cocktime)
	return TRUE
