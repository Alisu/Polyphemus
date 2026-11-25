tests
testTheOldestFrameOfAProcessHasNoSender

	"#215: the oldest frame of a process answered the nil object as its sender where a context
	answers nil, so a walk down the senders went on into it."

	| oldest |
	oldest := self allFrames select: [ :each | each isBaseFrame and: [ each oopPageCaller isNilOop ] ].
	self assert: oldest notEmpty.
	oldest do: [ :each | self assert: each sender isNil ]
