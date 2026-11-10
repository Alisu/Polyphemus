tests
testEveryObserverOfEveryUserSharesTheLocks

	"#163, risk 8: in each user's temporary directory, a root observer's lock and a user's did not
	exclude each other (macOS gives each user its own)."

	OSPlatform current isWindows ifTrue: [ ^ self skip: 'the stop helper is for Linux and macOS' ].
	self assert: StopHelper sharedDirectory fullName equals: '/tmp/polyphemus-stop'
