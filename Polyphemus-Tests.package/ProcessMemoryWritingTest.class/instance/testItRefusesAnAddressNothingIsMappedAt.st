tests
testItRefusesAnAddressNothingIsMappedAt

	self
		should: [ process storeBytes: #[ 1 2 3 ] at: 16r20000 ]
		raise: Error
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'nothing is mapped at') ]
