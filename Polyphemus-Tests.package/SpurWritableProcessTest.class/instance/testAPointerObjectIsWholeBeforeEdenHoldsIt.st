tests
testAPointerObjectIsWholeBeforeEdenHoldsIt

	"#163, risk 5: its slots were 0, words no object is at, until the caller wrote nil, after
	freeStart had moved past it: an observer dying between left the VM an object it cannot walk."

	| freeStart written object |
	freeStart := 16r10000 + (5 * 8).
	written := OrderedCollection new.
	process whenWritingDo: [ :address | written add: address ].
	object := memory allocateSlots: 3 format: 2 classIndex: 51 filledWith: 16r20001.
	self assert: ((0 to: 2) collect: [ :each | memory fetchPointer: each ofObject: object ]) asArray equals: #( 16r20001 16r20001 16r20001 ).
	self assert: written last equals: freeStart.
	self assert: (written select: [ :each | each = freeStart ]) size equals: 1
