frames
isMachineCodeFrameAt: aFramePointer

	"CoInterpreter>>isMachineCodeFrame: on a dump: the method field is a CogMethod, in the code zone
	or else below the heap's mapping, but for new space, below it too from VM 10 (#150)."

	| method |
	method := self wordOfFrame: aFramePointer at: -8.
	method ifNil: [ ^ false ].
	(self isMachineCodeAddress: method) ifTrue: [ ^ true ].
	^ method < mappingStart and: [ (self isInNewSpace: method) not ]
