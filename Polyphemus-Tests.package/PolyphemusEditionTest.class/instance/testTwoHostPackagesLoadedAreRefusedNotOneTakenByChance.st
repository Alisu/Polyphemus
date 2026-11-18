tests
testTwoHostPackagesLoadedAreRefusedNotOneTakenByChance

	"#118: the host was the first subclass the image listed. An image holding two hosts' packages
	read processes with whichever came first; it is told, by name."

	self assert: (PolyphemusMadeFor oneOf: { PolyphemusMadeFor current }) identicalTo: PolyphemusMadeFor current.
	self should: [ PolyphemusMadeFor oneOf: #(  ) ] raise: NotSetUp.
	self
		should: [ PolyphemusMadeFor oneOf: { PolyphemusMadeFor current. PolyphemusMadeFor } ]
		raise: NotSetUp
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'Several') ]
