tests
testATargetsLongLogIsQuotedByItsStartAndItsEnd

	"A crash report opens with the signal and closes with the last process: the middle is left out."

	| said |
	said := LiveImageTestCase endOf: 'Segmentation fault' , (String new: 5000 withAll: $.) , 'the end'.
	self assert: (said beginsWith: 'its log: Segmentation fault').
	self assert: (said endsWith: 'the end').
	self assert: (said includesSubstring: ' [...] ').
	self assert: said size < 1500
