tests
testADefectReadingAnActivationIsNotALineSayingItIsUnreadable

	"#118: a bug of our own reading an activation's code, receiver or selector gave a stack line
	saying the image's was unreadable."

	| stacks context |
	stacks := self memory stacks.
	context := self context.

	#( #compiledCode #receiver ) do: [ :each |
		self
			should: [ stacks descriptionOfContext: (self defective: context in: each) ]
			raise: ZeroDivide
			description: 'a defect in ' , each ].
	self
		should: [
			stacks descriptionOfContext: ((DefectiveReadDouble of: context)
					 when: #compiledCode
					 answer: [ self defective: context compiledCode in: #oopSelector ]) ]
		raise: ZeroDivide
		description: 'a defect reading its selector'
