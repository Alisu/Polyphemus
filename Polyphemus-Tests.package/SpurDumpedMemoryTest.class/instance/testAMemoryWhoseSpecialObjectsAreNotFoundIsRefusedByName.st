tests
testAMemoryWhoseSpecialObjectsAreNotFoundIsRefusedByName

	"#211: in a copy of a real core's bytes, the special objects array loses its shape (its first
	slot is no longer nil). A reading cannot be set up without it: refused as ours, naming the rung,
	where it was an error of VMMaker's fetching a slot of nil."

	<readsAnUnsoundHeap>
	| soa copy broken |
	soa := dumped raw specialObjectsOop.
	copy := dumped raw bytes copy.
	self poke: 16r29 at: soa + 8 in: copy.
	broken := SpurDumpedMemory
		          on: (ByteArrayAddressSpace on: copy at: dumped raw mappingStart)
		          from: dumped raw mappingStart
		          to: dumped raw mappingLimit.

	self deny: (broken raw readability canRead: #specialObjects).
	self
		should: [ broken reifiedMemory ]
		raise: SpurCannotRead
		withExceptionDo: [ :refusal | self assert: refusal level equals: #specialObjects ]
