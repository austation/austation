// Ah fuck, I can't believe you've done this - need to override the new attacking proc
/mob/living/simple_animal/hostile/cat_butcherer/AttackingTarget()
	. = ..()
	if(. && prob(35) && iscarbon(target))
		var/mob/living/carbon/human/L = target
		var/obj/item/organ/tail/cat/tail = L.getorgan(/obj/item/organ/tail/cat)
		if(!QDELETED(tail))
			visible_message("[src] severs [L]'s tail in one swift swipe!", "<span class='notice'>You sever [L]'s tail in one swift swipe.</span>")
			tail.Remove(L)
			var/obj/item/organ/tail/cat/dropped_tail = new(target.drop_location())
			dropped_tail.color = L.hair_color
		return 1
