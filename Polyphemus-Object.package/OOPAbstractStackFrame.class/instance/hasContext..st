context protocol
hasContext: anActivation

	^ (self findContextSuchThat: [ :each | each == anActivation ]) notNil
