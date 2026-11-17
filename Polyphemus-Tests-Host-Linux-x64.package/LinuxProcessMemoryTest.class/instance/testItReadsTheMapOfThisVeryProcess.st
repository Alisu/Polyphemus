tests
testItReadsTheMapOfThisVeryProcess

	"Every mapped region, from a text file the kernel writes."

	self assert: memory segments size > 10.
	self assert: (memory segments allSatisfy: [ :each | each sizeInFile > 0 ]).
	self assert: (memory segments allSatisfy: [ :each | each isLoadable ])
