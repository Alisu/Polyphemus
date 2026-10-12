tests
testAPointerSlotIsFollowedByItsAddress

	| process context |
	process := self inspect: (self namedProcess at: 'address') in: self resource target.
	context := self inspect: ((self slotNamed: 'suspendedContext' of: process) at: 'address') in: self resource target.
	self assert: (((context at: 'structuredContent') at: 'class') includesSubstring: 'Context')
