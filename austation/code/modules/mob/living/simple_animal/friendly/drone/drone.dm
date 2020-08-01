/mob/living/simple_animal/drone/RangedAttack(atom/A, mouseparams)
	. = ..()

	if(isturf(A) && get_dist(src,A) <= 1)
		src.Move_Pulled(A)
		return

/mob/living/simple_animal/drone/get_jetpack()
	var/obj/item/tank/jetpack/J = internal_storage
	if(istype(J))
		return J
