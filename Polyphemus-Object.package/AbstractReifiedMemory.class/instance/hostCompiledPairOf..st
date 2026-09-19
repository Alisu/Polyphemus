highlighting
hostCompiledPairOf: anActivation

	"{method. tree} for the activation's method, compiled here once. Cached per method."

	| home |
	home := [ anActivation homeMethod ] on: Error do: [ :e | nil ].
	home ifNil: [ ^ nil ].
	^ (self
		   rememberedAt: 'hostCompilation.' , home address printString
		   ifAbsentPut: [ (self compileHostSourceFor: anActivation) ifNil: [ false ] ])
		  ifNotNil: [ :cached | cached == false ifTrue: [ nil ] ifFalse: [ cached ] ]
