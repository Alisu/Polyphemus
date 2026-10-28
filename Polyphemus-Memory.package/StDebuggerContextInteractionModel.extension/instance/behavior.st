*Polyphemus-Memory
behavior

	"The class the code pane completes and colours against: for a frame of the image being read,
	the nearest class of that image this one has by name, as Pharo's tools need a real class (#120)."

	self context class == OOPContext ifTrue: [
		^ [ self context receiver oopClass nearestClassHere ] on: Error do: [ :e | Object ] ].
	^ self context receiver class
