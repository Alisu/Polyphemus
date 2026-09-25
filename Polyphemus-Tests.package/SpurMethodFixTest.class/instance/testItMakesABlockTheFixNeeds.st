tests
testItMakesABlockTheFixNeeds

	"An edit with a block in it, which is most of them. The block is a compiled block of the
	image's own, belonging to the method that was made for it, and the machine runs it: the
	statement really evaluates, so a block put together wrongly would not survive this."

	| method source |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].
	source := self
		          statementPutInto: method getSourceFromFile
		          source: '((1 to: 3) collect: [ :each | each * 2 ]) size = 3 ifTrue: [ ]. '.
	self assert: (self fix apply: source to: method) equals: #madeRoomForIt.
	(SpurWritableVMMakerMemory on: reading) writeTo: written.

	self
		assert: (self
				 evaluate: '(1000000000000000000000 - 999999999999999999999) printString'
				 in: written)
		equals: '''1'''
