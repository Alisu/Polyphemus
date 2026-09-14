context protocol
hasContext: anOOPContext

	^ (self findContextSuchThat: [ :context | context == anOOPContext ]) notNil
