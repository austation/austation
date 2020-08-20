/obj/item/projectile
  var/ignore_dt = FALSE

/obj/item/projectile/on_hit(atom/target, blocked = FALSE)
  var/turf/target_loc = get_turf(target)

  if(!nodamage && (damage_type == BRUTE || damage_type == BURN) && iswallturf(target_loc))
    var/turf/closed/wall/w = target_loc
    if(w.damage_threshold <= damage || ignore_dt)
      w.durability -= damage
      if(w.durability <= 0)
        w.dismantle_wall(0,1)

  ..()
