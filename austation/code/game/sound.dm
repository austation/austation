/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if("water_wade")
				soundin = pick('austation/sound/effects/water_wade1.ogg', 'austation/sound/effects/water_wade2.ogg', 'austation/sound/effects/water_wade3.ogg', 'austation/sound/effects/water_wade4.ogg')
			else
				soundin = ..()
	return soundin
