tests
testTheClassesAddUpToTheWholeHeap

	"Every live object of old space is in one class's line, the VM's own under their pun."

	| census |
	census := self census.
	self assert: (census lines inject: 0 into: [ :sum :each | sum + each count ]) equals: census objectCount.
	self assert: (census lines inject: 0 into: [ :sum :each | sum + each bytes ]) equals: census bytes.
	self assert: census objectCount > 843000.
	self assert: (census lines first bytes) >= (census lines second bytes)
