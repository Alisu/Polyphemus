private
sendersOf: aSelector

	"What to follow next from aSelector: its senders of ours. None, it is reached at run time (a
	request, a menu, Pharo's tools): the tests and resources naming the classes implementing it."

	| ours |
	ours := self sendersOfOurs: aSelector.
	ours ifNotEmpty: [ ^ ours asArray flatCollect: [ :each | self reach: each ] ].
	^ ((self implementorsOf: aSelector) select: [ :each | self isOurs: each compiledMethod ])
		  flatCollect: [ :each | self testsNaming: each compiledMethod methodClass instanceSide ]
