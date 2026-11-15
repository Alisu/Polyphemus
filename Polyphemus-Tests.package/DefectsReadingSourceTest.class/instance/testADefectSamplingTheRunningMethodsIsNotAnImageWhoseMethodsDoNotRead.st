tests
testADefectSamplingTheRunningMethodsIsNotAnImageWhoseMethodsDoNotRead

	"#118: a context whose method does not read is left out of the sample, and an image whose
	processes do not read says its running methods do not. A bug of our own on either way is
	neither."

	self
		should: [ (SourceReadability of: (self defective: self memory in: #stacks)) sampleMethods ]
		raise: ZeroDivide.
	self
		should: [ (SourceReadability of: (self defective: self memory in: #allReifiedProcesses)) checkSource ]
		raise: ZeroDivide
