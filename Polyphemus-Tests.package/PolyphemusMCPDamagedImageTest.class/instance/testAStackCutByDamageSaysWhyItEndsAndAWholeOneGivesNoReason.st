tests
testAStackCutByDamageSaysWhyItEndsAndAWholeOneGivesNoReason

	"Three of the eight stacks of the damaged copy are cut, one of them not read at all.
	`processes` gives each process the reason its stack ends, none for a whole one; `stack`
	gives the same reason, and says it after the frames."

	| handle rows cut whole stack text |
	handle := self class handle.
	rows := ((self class call: 'processes' with: (Dictionary new at: 'handle' put: handle; yourself))
		         at: 'structuredContent') at: 'processes'.
	cut := (rows select: [ :each | (each at: 'ends') notNil ]) asSortedCollection: [ :a :b | (a at: 'depth') >= (b at: 'depth') ].
	whole := rows detect: [ :each | (each at: 'ends') isNil and: [ (each at: 'depth') > 3 ] ].
	self assert: rows size equals: 8.
	self assert: cut size equals: 3.
	self assert: (cut last at: 'depth') equals: 0.
	self assert: ((cut last at: 'ends') includesSubstring: 'suspended context of the process does not read').
	self assert: (cut anySatisfy: [ :each | (each at: 'ends') includesSubstring: 'is no context' ]).
	self assert: (cut anySatisfy: [ :each | (each at: 'ends') includesSubstring: 'is no address of this memory' ]).

	stack := self class call: 'stack' with: (Dictionary new
			          at: 'handle' put: handle;
			          at: 'process' put: (cut first at: 'process');
			          yourself).
	text := (stack at: 'content') first at: 'text'.
	self assert: ((stack at: 'structuredContent') at: 'ends') equals: (cut first at: 'ends').
	self assert: (text lines last includesSubstring: (cut first at: 'ends')).

	stack := self class call: 'stack' with: (Dictionary new
			          at: 'handle' put: handle;
			          at: 'process' put: (whole at: 'process');
			          yourself).
	self assert: ((stack at: 'structuredContent') at: 'ends') isNil.
	self deny: ((((stack at: 'content') first at: 'text') lines last) includesSubstring: 'the stack ends')
