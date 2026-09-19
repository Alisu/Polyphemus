tests
testOneBrokenClassCostsThatClassAndNothingElse

	"Breaking one class table entry in a copy of a real core loses that class's name only;
	the memory stays readable."

	| soa index page entry copy broken reified |
	soa := dumped specialObjectsOop.
	index := dumped memory classIndexOf: soa.
	page := dumped scanner
		        slotOf: (dumped scanner hiddenRootsFrom: dumped heapStart)
		        at: index // 1024 + 1.
	entry := page + 8 + (index \\ 1024 * 8).

	copy := dumped bytes copy.
	self poke: soa "an Array, which is not a class" at: entry in: copy.
	broken := SpurDumpedMemory
		          on: (ByteArrayAddressSpace on: copy at: dumped mappingStart)
		          from: dumped mappingStart
		          to: dumped mappingLimit.

	"local damage: the table still resolves, so the memory is still readable"
	self assert: (broken readability canRead: #classes).
	self assert: broken classTableStructureProblems asArray equals: #(  ).
	self assert: (broken unreadableClassIndexes includes: index).

	reified := broken reifiedMemory.
	self assert: (reified reifyOop: soa) oopClass isUnreadableClass.
	self assert: (reified reifyOop: soa) oopClass classIndex equals: index.
	self assert: (reified reifyOop: soa) allReifiedSlots size > 3.

	"and nothing else lost its name"
	self
		assert: (reified reifyOop: broken heapStart) oopClass name
		equals: 'UndefinedObject'
