tests
testRunUntilRefusesAKeywordSelectorWithAnEmptyPart

	"#180: a keyword selector is names each ended by a colon; two colons together, or a colon
	alone, spell none, and went through as if they did."

	| handle |
	handle := self heldBy: UnaskedDouble new.
	#( 'Object >> #at::put:' 'Object >> #:' 'Object >> #at:put::' ) do: [ :each |
		| result |
		result := self resultOf: 'run_until' with: (Dictionary new at: 'handle' put: handle; at: 'method' put: each; yourself).
		self assert: (result at: 'isError') description: each.
		self assert: (((result at: 'content') first at: 'text') includesSubstring: 'Class >> #selector') ]
