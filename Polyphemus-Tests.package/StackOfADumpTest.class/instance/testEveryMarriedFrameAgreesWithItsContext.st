tests
testEveryMarriedFrameAgreesWithItsContext

	"A married frame and its context name the same method and receiver: read from two
	places, one through the heap and one through the stack page."

	| married |
	married := self allFrames select: [ :each | each oopFlag isMarried ].

	self assert: married size >= 12.
	married do: [ :each |
		self
			assert: (each oopContext reifiedSlotAt: memory contextMethodSlot)
			equals: each compiledCode.
		self
			assert: (each oopContext reifiedSlotAt: memory contextReceiverSlot)
			equals: each oopReceiver ]
