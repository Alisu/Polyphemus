tests
testOneBrokenClassCostsThatClassAndNothingElse

	"Breaking one class table entry in a copy of a real core loses that class's name only;
	the memory stays readable."

	| soa index page entry copy broken reified |
	soa := dumped raw specialObjectsOop.
	index := dumped memory classIndexOf: soa.
	page := dumped raw scanner
		        slotOf: (dumped raw scanner hiddenRootsFrom: dumped raw heapStart)
		        at: index // 1024 + 1.
	entry := page + 8 + (index \\ 1024 * 8).

	copy := dumped raw bytes copy.
	self poke: soa "an Array, which is not a class" at: entry in: copy.
	broken := SpurDumpedMemory
		          on: (ByteArrayAddressSpace on: copy at: dumped raw mappingStart)
		          from: dumped raw mappingStart
		          to: dumped raw mappingLimit.

	"local damage: the table still resolves, so the memory is still readable"
	self assert: (broken raw readability canRead: #classes).
	self assert: broken raw classTableStructureProblems asArray equals: #(  ).
	self assert: (broken raw unreadableClassIndexes includes: index).

	reified := broken reifiedMemory.
	self assert: (reified reifyOop: soa) oopClass isUnreadableClass.
	self assert: (reified reifyOop: soa) oopClass classIndex equals: index.
	self assert: (reified reifyOop: soa) allReifiedSlots size > 3.

	"and nothing else lost its name"
	self
		assert: (reified reifyOop: broken raw heapStart) oopClass name
		equals: 'UndefinedObject'
