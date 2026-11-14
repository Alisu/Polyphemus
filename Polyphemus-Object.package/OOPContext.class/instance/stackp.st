context protocol
stackp

	"How many slots of its stack are in use. Refused when it is no integer (#196)."

	^ self integerInSlot: memory stacks contextStackPointerSlot called: 'stack pointer' ifNil: [ 0 ]
