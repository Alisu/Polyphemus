tests
testASegmentBridgeSpansWhatTheWordBeforeItsEndSays

	"A long bridge's count word says how many words it spans; a short one, the last, spans none,
	the word 16 bytes before the segment's end being then its own header."

	| short |
	short := SpurHeader headerFor: 0 format: 9 classIndex: 3.
	self assert: (SpurHeader isSegmentBridge: short).
	self deny: (SpurHeader isSegmentBridge: (SpurHeader headerFor: 0 format: 10 classIndex: 3)).
	self deny: (SpurHeader isSegmentBridge: (SpurHeader headerFor: 0 format: 9 classIndex: 4)).
	self assert: (SpurHeader bridgeSpanFrom: short) equals: 0.
	self assert: (SpurHeader bridgeSpanFrom: (SpurHeader overflowWordFor: 4)) equals: 32
