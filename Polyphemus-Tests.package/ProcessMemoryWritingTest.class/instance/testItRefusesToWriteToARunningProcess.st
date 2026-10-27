tests
testItRefusesToWriteToARunningProcess

	"A word set under a running VM lands in the middle of whatever it was doing with it (#24)."

	process run.
	self
		should: [ process storeBytes: #[ 1 2 3 ] at: 16r10010 ]
		raise: Error
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'running') ].
	self assert: (process bytesAt: 16r10010 count: 3) asArray equals: #( 0 0 0 )
