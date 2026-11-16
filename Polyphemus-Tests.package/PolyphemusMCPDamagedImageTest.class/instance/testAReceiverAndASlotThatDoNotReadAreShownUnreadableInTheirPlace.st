tests
testAReceiverAndASlotThatDoNotReadAreShownUnreadableInTheirPlace

	"The receiver of one context and the suspended context of one process of the damaged copy
	are words that are no address: `stack` and `inspect` say so in their place, without an
	address to follow, and show the rest."

	| handle rows cut frames process slots unreadable |
	handle := self class handle.
	rows := ((self class call: 'processes' with: (Dictionary new at: 'handle' put: handle; yourself))
		         at: 'structuredContent') at: 'processes'.

	cut := rows detect: [ :each | (each at: 'ends') notNil and: [ (each at: 'ends') includesSubstring: 'is no context' ] ].
	frames := ((self class call: 'stack' with: (Dictionary new
				            at: 'handle' put: handle;
				            at: 'process' put: (cut at: 'process');
				            yourself)) at: 'structuredContent') at: 'frames'.
	unreadable := frames select: [ :each | (each at: 'receiver') = '(unreadable)' ].
	self assert: frames size equals: (cut at: 'depth').
	self assert: unreadable size equals: 1.
	self assert: (unreadable first at: 'receiverAddress') isNil.

	process := rows detect: [ :each | (each at: 'depth') = 0 ].
	slots := ((self class call: 'inspect' with: (Dictionary new
				           at: 'handle' put: handle;
				           at: 'address' put: (process at: 'address');
				           yourself)) at: 'structuredContent') at: 'slots'.
	unreadable := slots select: [ :each | (each at: 'value') = '(unreadable)' ].
	self assert: slots size > 1.
	self assert: unreadable size equals: 1.
	self assert: (unreadable first at: 'name') equals: 'suspendedContext'.
	self assert: (unreadable first at: 'address') isNil
