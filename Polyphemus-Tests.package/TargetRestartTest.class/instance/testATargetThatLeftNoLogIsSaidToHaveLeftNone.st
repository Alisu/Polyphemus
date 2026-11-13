tests
testATargetThatLeftNoLogIsSaidToHaveLeftNone

	"Killed from outside, a VM says nothing; one that crashed does."

	self assert: (LiveImageTestCase endOf: nil) equals: 'it left no log'.
	self assert: (LiveImageTestCase endOf: '') equals: 'its log is empty'
