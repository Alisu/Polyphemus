querying
reifiedMethods

	"Every method the dictionary holds. They are in its array, from that array's first slot,
	while its selectors are in the dictionary itself from the third (#28)."

	| methods |
	methods := self reifiedMethodDictionary reifiedSlotAt: 2.
	^ (1 to: methods oopNumberOfSlots)
		  collect: [ :anIndex | methods reifiedSlotAt: anIndex ]
		  thenSelect: [ :anOop | anOop isNilOop not ]
