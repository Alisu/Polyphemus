tests
testTheCensusListsTheHeaviestClassesFirst

	"Arrays are the heaviest class of the pinned Pharo 10 image (13.4 MB, #69)."

	| result rows |
	result := self call: 'census' with: (Dictionary new at: 'top' put: 5; yourself).
	rows := (result at: 'structuredContent') at: 'classes'.
	self assert: rows size equals: 5.
	self assert: (rows first at: 'name') equals: 'Array'.
	self assert: ((rows first at: 'bytes') >= (rows last at: 'bytes'))
