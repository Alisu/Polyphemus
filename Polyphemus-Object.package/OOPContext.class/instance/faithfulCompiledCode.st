highlighting
faithfulCompiledCode

	"This frame's code, compiled here from the source in the file -- and answered only when
	it comes out as the very same code the file holds.

	A snapshot carries no map from a pc to a place in the source, so the only way to know
	which part of the method a frame is in is to build the map by compiling the source
	again. That is worth nothing unless the code compiled here is the code that was
	running, so the bytecodes are compared, and nothing is answered when they differ. All
	27 method frames of the pinned image match; when one does not, this frame simply
	highlights nothing.

	Kept, because the debugger asks for a range every time it redraws."

	| code |
	faithfulCode ifNotNil: [
		^ faithfulCode == false
			  ifTrue: [ nil ]
			  ifFalse: [ faithfulCode ] ].

	code := [ self computeFaithfulCompiledCode ] on: Error do: [ :e | nil ].
	faithfulCode := code ifNil: [ false ].
	^ code
