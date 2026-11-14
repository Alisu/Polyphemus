accessing
oopPageCaller

	"The context that called into this page, where this frame's reader says the VM keeps it:
	the nil object for the first activation of a process. Refused by name when the word there is
	neither (#198)."

	| word caller |
	self refuseIfMachineCode.
	word := self layout callerContextOf: framePointer.
	caller := self layout objectAt: word.
	caller ifNil: [ ^ self refuseItsField: 'caller context' holding: word ].
	(caller isNilOop or: [ caller isContextOop ]) ifFalse: [
		^ NotInTheReading signal: 'the caller context of the frame at ' , (framePointer printStringRadix: 16)
			  , ' is no context: ' , caller whatItReadsAs ].
	^ caller
