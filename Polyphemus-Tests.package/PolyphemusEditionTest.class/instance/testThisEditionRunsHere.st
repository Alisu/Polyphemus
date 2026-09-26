tests
testThisEditionRunsHere

	"The edition this code is, on the host the suite runs on."

	self assert: (PolyphemusEdition current refusalOfHost: PolyphemusHost current) isNil
