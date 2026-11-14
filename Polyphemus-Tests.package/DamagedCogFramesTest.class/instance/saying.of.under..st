running
saying: anError of: aQuestion under: aDamage

	^ aDamage , ', ' , aQuestion key , ': ' , anError class name , ' '
	  , (anError messageText asString truncateTo: 80)
