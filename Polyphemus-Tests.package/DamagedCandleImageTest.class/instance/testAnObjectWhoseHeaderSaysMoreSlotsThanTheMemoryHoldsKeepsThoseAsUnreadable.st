tests
testAnObjectWhoseHeaderSaysMoreSlotsThanTheMemoryHoldsKeepsThoseAsUnreadable

	"#118: an Array made in the loaded memory, then its slot count overwritten there so that its
	slots run past the end of the memory, as in a process whose memory was damaged after it was
	read. A slot past that end stands as unreadable, where VMMaker says only that it has no such key."

	| loaded vm array count memory object slots |
	loaded := DamagedCandleImage loadedClean.
	vm := loaded instVarNamed: 'memory'.
	array := loaded
		         newOldSpaceObjectWithSlots: 300
		         format: vm arrayFormat
		         classIndex: (vm classIndexOf: vm specialObjectsOop).
	loaded postImageLoad.
	memory := loaded instVarNamed: 'reifiedMemory'.
	count := vm endOfMemory - array // 8 + 600.
	vm long64At: array - 8 put: (255 bitShift: 56) + count.
	object := memory reifyOop: array.
	slots := object allReifiedSlots.

	self assert: slots size equals: count.
	self deny: ((slots first: 300) anySatisfy: [ :each | each isUnreadableSlot ]).
	self assert: slots last isUnreadableSlot.
	self assert: (memory readSlot: count of: object ifUnreadable: [ #unreadable ]) equals: #unreadable.
	self should: [ object reifiedSlotAt: count ] raise: NotInTheReading
