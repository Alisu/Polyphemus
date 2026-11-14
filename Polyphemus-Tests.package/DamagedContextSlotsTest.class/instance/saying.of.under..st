running
saying: anError of: aQuestion under: aKind

	^ aKind key , ', ' , aQuestion key , ': ' , anError class name , ' '
	  , (anError messageText asString truncateTo: 80)
