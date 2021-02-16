/mob/living/simple_animal/hostile/poison/bees/AttackingTarget()
	..()
	if isliving(target)
		Destroy()  //  please die, little bee
