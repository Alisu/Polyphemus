tests
testEachEditionHasAScratchDirectoryOfItsOwn

	"#50: two hosts' suites on one box shared every file tests leave in /tmp, named by class
	alone, and killed each other's targets. Each edition's are under its own name."

	| other |
	other := PolyphemusEdition host: (PolyphemusHost pharo: 99 os: 'Linux' cpu: 'x64') targets: #( 10 ).
	self assert: (PolyphemusEdition current scratch fullName includesSubstring: PolyphemusEdition current name).
	self deny: other scratch equals: PolyphemusEdition current scratch.
	self
		assert: (PolyphemusEdition using: other during: [ LiveEditingTest new spikeDirectory ]) parent fullName
		equals: other scratch fullName
