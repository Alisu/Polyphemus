tests
testADefectReadingAVMVariableIsNotTheVMNotSaying

	"#118: any error read as 'the VM does not say', and the heap was found by shape with no word of why."

	<readsAnUnsoundHeap>
	| raw |
	raw := self rawHeapWith: DefectiveVMVariablesDouble new.

	self should: [ raw statedEndOfMemory ] raise: ZeroDivide.
	self should: [ raw statedSpecialObjectsOop ] raise: ZeroDivide.
	self should: [ raw liveYoungRanges ] raise: ZeroDivide.
	self should: [ raw codeZone ] raise: ZeroDivide.
	self should: [ raw findYoungMapping ] raise: ZeroDivide.
	self should: [ SpurRawHeap statedHeapStartIn: RegionsDouble new variables: DefectiveVMVariablesDouble new ] raise: ZeroDivide
