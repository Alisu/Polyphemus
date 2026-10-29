initialization
piecesOf: someSegments from: aReader

	"One piece for each run of touching segments: macOS lists a heap as many regions, which the
	raw heap then reads in place as one instead of copying them again (#122)."

	| runs |
	runs := OrderedCollection new.
	(someSegments asSortedCollection: [ :a :b | a address <= b address ]) do: [ :each |
		(runs notEmpty and: [ runs last last address + runs last last sizeInMemory = each address ])
			ifTrue: [ runs last add: each ]
			ifFalse: [ runs add: (OrderedCollection with: each) ] ].
	^ (runs asArray collect: [ :each | self copyOfRun: each from: aReader ]) reject: [ :each | each isNil ]
