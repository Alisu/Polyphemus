private
sendersOf: aSelector

	"What to follow next from aSelector: its senders of ours. None, it is reached at run time (a
	request, a menu, Pharo's tools): the tests and resources naming the classes implementing it."

	| ours |
	ours := (SystemNavigation default allSendersOf: aSelector) select: [ :each | self isOurs: each compiledMethod ].
	ours ifNotEmpty: [ ^ ours flatCollect: [ :each | self reach: each compiledMethod ] ].
	^ ((SystemNavigation default allImplementorsOf: aSelector) select: [ :each | self isOurs: each compiledMethod ])
		  flatCollect: [ :each | self testsNaming: each compiledMethod methodClass instanceSide ]
