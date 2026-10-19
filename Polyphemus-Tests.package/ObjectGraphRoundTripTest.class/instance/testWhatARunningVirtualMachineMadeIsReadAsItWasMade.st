tests
testWhatARunningVirtualMachineMadeIsReadAsItWasMade

	"Twenty seeds' graphs, made by a running VM and read back from it in one reading, each the
	graph its seed makes here. A failure names the seed and the path (seed 7: 3.2.1); its
	first run found 16 and 32-bit objects read one element off (#88)."

	| pid reified graphs seen |
	pid := self launchTargetMakingTheGraphs.
	[ reified := Polyphemus readProcess: pid ] ensure: [ LibC system: 'kill -9 ' , pid printString ].
	graphs := (reified globalNamed: 'PolyphemusGraphs') reifiedSlotAt: 2.
	self assert: graphs oopNumberOfSlots equals: self seeds size.
	seen := IdentityDictionary new.
	self seeds doWithIndex: [ :seed :index |
		self
			assert: (graphs reifiedSlotAt: index)
			is: (self graphFor: seed)
			at: 'seed ' , seed printString
			seen: seen ]
