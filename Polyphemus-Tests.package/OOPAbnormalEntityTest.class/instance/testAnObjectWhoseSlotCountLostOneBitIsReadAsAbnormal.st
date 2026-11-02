tests
testAnObjectWhoseSlotCountLostOneBitIsReadAsAbnormal

	"A slot count with one bit flipped makes the object run over the ones after it: it is read as
	abnormal, and what follows it is still read (#139)."

	| association key |
	association := self associationReachableWithItsSlots: true.
	key := memory fetchPointer: 0 ofObject: association.
	memory rawNumSlotsOf: association put: (2 bitXor: 64).
	reifiedMemory := FullyReifiedMemory on: memory.
	self assert: (reifiedMemory objectAt: association) isAbnormalOop.
	self assert: (reifiedMemory objectAt: key) address equals: key
