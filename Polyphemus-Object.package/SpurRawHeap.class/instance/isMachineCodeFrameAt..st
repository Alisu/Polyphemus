frames
isMachineCodeFrameAt: aFramePointer

	"CoInterpreter>>isMachineCodeFrame: on a dump: the method field is below the heap's mapping
	(a CogMethod in the code zone) rather than a CompiledMethod."

	| method |
	method := self wordOfFrame: aFramePointer at: -8.
	^ method notNil and: [ method < mappingStart ]
