tests
testTheKeyCoversWritingAndNotTheLiveCode

	| classes |
	classes := SpurImageFromDumpTest classesTheWrittenImageDependsOn.
	self assert: (classes includes: SpurImageFromDump).
	self assert: (classes includes: SpurRawHeap).
	self assert: (classes includes: LazyReifiedMemory).
	self deny: (classes includes: HeldProcess).
	self deny: (classes includes: PolyphemusAgent).
	self deny: (classes includes: SpurMethodInstall)
