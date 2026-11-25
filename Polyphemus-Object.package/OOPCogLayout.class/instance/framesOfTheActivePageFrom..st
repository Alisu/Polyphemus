reading
framesOfTheActivePageFrom: aFramePointer

	"The active page's frames from that one down, as read from the VM's own pointers, its page record
	keeping a stale head (CoInterpreter>>externalWriteBackHeadFramePointers). nil on any other page."

	| variables page frames index |
	variables := raw vmVariables.
	page := [ variables pageHolding: aFramePointer ] on: SpurCannotRead do: [ :unsaid | ^ nil ].
	(page notNil and: [ page address = (variables at: 'stackPage') ]) ifFalse: [ ^ nil ].
	frames := [ self framesOfActiveProcess ] on: SpurCannotRead do: [ :refusal | ^ nil ].
	index := frames findFirst: [ :each | each framePointer = aFramePointer ].
	^ index = 0 ifFalse: [ frames allButFirst: index - 1 ]
