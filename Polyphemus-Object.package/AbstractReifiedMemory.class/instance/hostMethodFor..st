highlighting
hostMethodFor: anActivation

	"The activation's method recompiled here from its source, answered only when the
	bytecodes equal the file's; nil otherwise. Cached per method."

	| home |
	home := [ anActivation homeMethod ] on: Error do: [ :e | nil ].
	home ifNil: [ ^ nil ].

	^ (self
		   rememberedAt: 'hostMethod.' , home address printString
		   ifAbsentPut: [ (self compileHostMethodFor: anActivation) ifNil: [ false ] ])
		  ifNotNil: [ :cached | cached == false ifTrue: [ nil ] ifFalse: [ cached ] ]
