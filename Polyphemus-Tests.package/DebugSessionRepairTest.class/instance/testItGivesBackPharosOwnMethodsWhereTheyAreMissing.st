tests
testItGivesBackPharosOwnMethodsWhereTheyAreMissing

	"#143: into a session class lacking them (here a subclass of Pharo's, never Pharo's own), the
	two methods as Pharo 10 to 14 have them."

	| lacking |
	lacking := DebugSession newAnonymousSubclass.
	DebugSessionRepair restoreInto: lacking.
	DebugSessionRepair originals keysAndValuesDo: [ :selector :protocolAndSource |
		self assert: (lacking includesSelector: selector).
		self assert: (lacking >> selector) sourceCode equals: protocolAndSource value.
		self assert: (self protocolNameOf: lacking >> selector) equals: protocolAndSource key ]
