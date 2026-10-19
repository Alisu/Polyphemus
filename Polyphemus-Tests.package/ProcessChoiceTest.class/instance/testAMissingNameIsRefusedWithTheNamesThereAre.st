tests
testAMissingNameIsRefusedWithTheNamesThereAre

	self
		should: [ Polyphemus processNamed: 'no such process' in: memory ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'no such process').
			self assert: (error messageText includesSubstring: 'Morphic UI Process') ]
