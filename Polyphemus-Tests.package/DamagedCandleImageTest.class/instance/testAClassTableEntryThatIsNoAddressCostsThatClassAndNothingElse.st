tests
testAClassTableEntryThatIsNoAddressCostsThatClassAndNothingElse

	"#118: the class table's entry for PCAssociation overwritten with a word that is no address,
	not even aligned. Its instances still read, their class standing as unreadable; others are whole."

	| association index memory page |
	memory := DamagedCandleImage readingWith: [ :clean |
		          | class |
		          class := clean oopClassNamed: 'PCAssociation'.
		          association := class instancesOop first address.
		          index := class instancesOop first oopClassTag.
		          page := clean reifiedClassTable reifiedSlotAt: index // 1024 + 1.
		          { ((self slot: index \\ 1024 + 1 of: page) -> 16r1234561) } ].

	self assert: (memory reifyOop: association) oopClass isUnreadableClass.
	self assert: (memory reifyOop: association) oopNumberOfSlots equals: 2.
	self assert: (memory reifyOop: association) allReifiedSlots size equals: 2.
	self deny: (memory classIsReadableAt: 16r1234561).
	self assert: (memory oopClassNamed: 'PCPoint') hasAReadableName
