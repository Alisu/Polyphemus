highlighting
onceForTheMethodOf: anActivation as: aName do: aBlock

	"aBlock's value for the activation's home method, worked out once per method and kept under
	aName; nil where it has no home method that reads, and where aBlock answered nil."

	| home |
	home := [ anActivation homeMethod ] on: PolyphemusError do: [ :e | nil ].
	home ifNil: [ ^ nil ].
	^ (memory rememberedAt: aName , '.' , home address printString ifAbsentPut: [ aBlock value ifNil: [ false ] ])
		  ifNotNil: [ :cached | cached == false ifTrue: [ nil ] ifFalse: [ cached ] ]
