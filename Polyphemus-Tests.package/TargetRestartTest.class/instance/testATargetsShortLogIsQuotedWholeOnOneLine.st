tests
testATargetsShortLogIsQuotedWholeOnOneLine

	"A result is one line: the log's line ends would cut it (#190)."

	self
		assert: (LiveImageTestCase endOf: 'pharo-vm starting' , String lf , 'Segmentation fault' , String cr)
		equals: 'its log: pharo-vm starting / Segmentation fault'
