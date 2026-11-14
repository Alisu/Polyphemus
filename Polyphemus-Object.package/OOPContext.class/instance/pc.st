context protocol
pc

	"Where it is in its code; nil for one that has returned. Refused when it is no integer (#196)."

	^ self integerInSlot: memory stacks contextPcSlot called: 'pc' ifNil: [ nil ]
