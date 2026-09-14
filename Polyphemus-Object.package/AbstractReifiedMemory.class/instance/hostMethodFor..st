highlighting
hostMethodFor: anActivation

	"The method this activation is running, compiled here from the source in the file --
	and answered only when it comes out as the very same code the file holds.

	A snapshot carries no map from a pc to a place in the source, so the only way to know
	which part of a method an activation is in is to build the map by compiling the source
	again. That is worth nothing unless the code compiled here is the code that was
	running, so the bytecodes are compared, and nothing is answered when they differ.

	Kept by the method it was compiled from, not by the activation asking: two frames of the
	same method share it, and a frame is built afresh every time its page is asked for its
	frames."

	| home |
	home := [ anActivation homeMethod ] on: Error do: [ :e | nil ].
	home ifNil: [ ^ nil ].

	^ (self
		   rememberedAt: 'hostMethod.' , home address printString
		   ifAbsentPut: [ (self compileHostMethodFor: anActivation) ifNil: [ false ] ])
		  ifNotNil: [ :cached | cached == false ifTrue: [ nil ] ifFalse: [ cached ] ]
