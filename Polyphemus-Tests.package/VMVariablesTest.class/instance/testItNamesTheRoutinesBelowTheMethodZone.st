tests
testItNamesTheRoutinesBelowTheMethodZone

	"The trampolines and enilopmarts Cog generates sit below its methods, each address
	kept in a variable of the library named after it."

	| names low high |
	names := variables trampolines.
	low := variables at: 'codeBase'.
	high := variables at: 'methodZoneBase'.

	self assert: names size >= 30.
	self assert: (names values includes: 'ceBaseFrameReturnTrampoline').
	self assert: (names values includes: 'ceReturnToInterpreterTrampoline').
	names keysDo: [ :each | self assert: (each between: low and: high - 1) ]
