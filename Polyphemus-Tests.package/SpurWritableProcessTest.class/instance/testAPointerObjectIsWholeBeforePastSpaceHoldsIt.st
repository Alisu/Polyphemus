tests
testAPointerObjectIsWholeBeforePastSpaceHoldsIt

	"#163, risk 5: its slots were 0, words no object is at, until the caller wrote nil, after
	the space's end had moved past it: an observer dying between left the VM an object it cannot walk."

	| pastSpaceStart written object |
	pastSpaceStart := 16r10000 + (7 * 8).
	written := OrderedCollection new.
	process whenWritingDo: [ :address | written add: address ].
	object := memory allocateSlots: 3 format: 2 classIndex: 51 filledWith: 16r20001.
	self assert: ((0 to: 2) collect: [ :each | memory fetchPointer: each ofObject: object ]) asArray equals: #( 16r20001 16r20001 16r20001 ).
	self assert: written last equals: pastSpaceStart.
	self assert: (written select: [ :each | each = pastSpaceStart ]) size equals: 1
