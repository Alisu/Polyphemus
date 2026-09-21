tests
testItMakesTheLiteralsAFixWantsInTheImage

	"The edit people actually make: it inlines something and names a string the image never
	held, so the literal frame is not the old one's -- reordered by the inlined selector, and
	one longer. The literals are made in the image and the method installed with them."

	| method source |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].
	source := self statementPutInto: method getSourceFromFile
		          source: '''polyphemus'' size = 10 ifTrue: [ ]. '.

	self assert: (self fix apply: source to: method) equals: #madeRoomForIt
