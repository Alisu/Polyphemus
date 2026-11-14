tests
testAWordAtAWipedHeaderIsRefusedAsNoObjectSayingWhichWord

	"#118: a word that names no object was a bare Error, with no text and no word of which."

	| association |
	association := self associationReachableWithItsSlots: true.
	self wipe: association.
	reifiedMemory := FullyReifiedMemory on: memory.
	self
		should: [ OOPAbnormalEntity canHandle: association memory: reifiedMemory ]
		raise: OopIsNotAnObject
		withExceptionDo: [ :refusal |
			self assert: refusal oop equals: association.
			self assert: (refusal messageText includesSubstring: association printStringHex) ]
