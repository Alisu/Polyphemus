tests
testItReadsTheVMsStackPagesAsVMMakerDescribesThem

	"The VM's page records, read through VMMaker's own CogStackPageSurrogate64: every page
	has its stack in the stack memory, and a page in use has its frames there too."

	| pages low high |
	pages := variables stackPages.
	low := (variables at: 'stackBasePlus1') - 1.
	high := low + ((variables at: 'numStackPages') * (variables at: 'bytesPerPage')).

	self assert: pages size equals: (variables at: 'numStackPages').
	pages do: [ :each |
		self assert: (each baseAddress between: low and: high).
		each baseFP ~= 0 ifTrue: [
			self assert: (each headFP between: each headSP and: each baseFP).
			self assert: (each baseFP between: low and: each baseAddress) ] ]
