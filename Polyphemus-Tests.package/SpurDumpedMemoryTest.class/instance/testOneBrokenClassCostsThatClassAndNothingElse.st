tests
testOneBrokenClassCostsThatClassAndNothingElse

	"Break a single entry of the class table in a copy of a real core -- point it at an
	object that is not a class -- and read the result.

	The objects of that class are still entirely there. They keep their slots, their size
	and their place; what they lose is the ability to say what they are, and they say *that*
	instead of guessing. Every other object in the heap is unaffected, which is the whole
	argument for not refusing the memory over it."

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
