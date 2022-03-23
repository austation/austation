/datum/xenoartifactseller //Vendor
    var/name
    var/price
    var/dialogue
    var/unique_id //not really uniuqe
    var/difficulty //Xenoartifact shit, not really difficulty

/datum/xenoartifactseller/proc/generate()
    name = "Placeholder"
    price = rand(5,80) * 10
    switch(price)
        if(50 to 300)
            difficulty = BLUESPACE
        if(301 to 500)
            difficulty = PLASMA
        if(501 to 700)
            difficulty = URANIUM
        if(701 to 800)
            difficulty = AUSTRALIUM
    price = price * rand(1.0, 1.5) //Measure of error for no particular reason
    dialogue = "lorem ipsum"
    unique_id = "[rand(1,100)][rand(1,100)][rand(1,100)]:[world.time]" //World.time is the only thing that stops these 'unique' IDs being the same, retard
