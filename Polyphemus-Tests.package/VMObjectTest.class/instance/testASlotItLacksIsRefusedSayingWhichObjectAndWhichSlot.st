tests
testASlotItLacksIsRefusedSayingWhichObjectAndWhichSlot

	"#118: a slot beyond an object's own was a SubscriptOutOfBounds with no text."

	| object |
	object := self testedObject.
	self
		should: [ object reifiedSlotAt: 4 ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal |
			self
				assert: refusal messageText
				equals: 'the object at ' , (object address printStringRadix: 16) , ' has no slot 4' ]
