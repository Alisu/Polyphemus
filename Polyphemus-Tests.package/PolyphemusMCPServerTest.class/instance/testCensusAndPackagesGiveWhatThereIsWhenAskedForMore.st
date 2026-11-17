tests
testCensusAndPackagesGiveWhatThereIsWhenAskedForMore

	"#180: the first twenty lines, or the top asked for, of an image that has fewer failed."

	| line lines reading handle |
	line := (DefectiveReadDouble of: Object new)
		        when: #name answer: [ 'Kernel' ];
		        when: #count answer: [ 3 ];
		        when: #bytes answer: [ 48 ];
		        yourself.
	lines := (DefectiveReadDouble of: Object new) when: #lines answer: [ { line. line } ]; yourself.
	reading := (DefectiveReadDouble of: PolyphemusMCPReading new)
		           when: #census answer: [ lines ];
		           when: #footprint answer: [ lines ];
		           yourself.
	handle := self server open: reading as: 'image'.
	{ 'census' -> 'classes'. 'packages' -> 'packages' } do: [ :each |
		{ Dictionary new. (Dictionary new at: 'top' put: 500; yourself) } do: [ :arguments |
			| result |
			arguments at: 'handle' put: handle.
			result := self resultOf: each key with: arguments.
			self assert: ((result at: 'structuredContent') at: each value) size equals: 2 ] ]