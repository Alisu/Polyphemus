tests
testAHeaderDamagedInTheHeapCostsTheListingsWhatIsPastItAndTheySaySo

	"#211: in a copy of the core's file, the header of an object of bytes two thirds of the way
	through old space is given a format no object has. The core still opens; the processes listed
	are those before it, and the listing says where its walk stopped and why."

	<readsAnUnsoundHeap>
	| scanner addresses victim header offset copy stream reading processes stop |
	DamagedCoreTest hasAnElfCore ifFalse: [ ^ self skip: 'the damage is written at an ELF core''s offsets' ].
	scanner := dumped raw scanner.
	addresses := OrderedCollection new.
	scanner
		walkFrom: dumped raw heapStart
		upTo: dumped raw mappingLimit
		atMost: nil
		liveDo: [ :address :itsHeader | addresses add: address ].
	victim := (addresses allButFirst: addresses size * 2 // 3) detect: [ :each |
		          (scanner formatIn: (scanner headerAt: each)) between: 16 and: 23 ].
	header := scanner headerAt: victim.
	offset := (dumped raw space segmentHolding: victim) fileOffsetFor: victim.
	copy := PolyphemusEdition current scratch / 'polyphemus-damaged-header.core'.
	copy ensureDelete.
	self dumpFile copyTo: copy.
	stream := (File named: copy fullName) writeStream.
	[
	stream
		position: offset;
		nextPutAll: (((header bitAnd: (16r1F bitShift: 24) bitInvert) bitOr: (6 bitShift: 24)) asByteArrayOfSize: 8) reversed ]
		ensure: [ stream flush; close ].
	reading := Polyphemus readCoreDump: copy fullName.
	[
	processes := reading allReifiedProcesses.
	stop := reading whereItsListingsStop.
	self assert: stop stoppedAt equals: victim.
	self assert: stop reason equals: #unusedFormat.
	self assert: processes notEmpty.
	self assert: (processes allSatisfy: [ :each | each address < victim ]).
	self assert: (reading processes whyTheListMayBeShort includesSubstring: victim printStringHex).
	self assert: (reading processInconsistencies anySatisfy: [ :each |
			 each value = #processesPastWhereTheHeapWalkStoppedAreNotListed ]) ] ensure: [
		reading vmLayout raw space close.
		copy ensureDelete ]
