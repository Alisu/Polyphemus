context protocol
pc

	"Where it is in its code; nil for one that has returned. Refused when it is no integer (#196);
	a machine code pc Cog left in it is mapped to its bytecode (#215)."

	| pc |
	pc := self integerInSlot: memory stacks contextPcSlot called: 'pc' ifNil: [ ^ nil ].
	pc >= 0 ifTrue: [ ^ pc ].
	^ memory vmLayout
		  contextPCOfMachineCodePC: pc
		  method: (self reifiedSlotAt: memory stacks contextMethodSlot) address
		  inABlock: (self reifiedSlotAt: memory stacks contextClosureSlot) isNilOop not
