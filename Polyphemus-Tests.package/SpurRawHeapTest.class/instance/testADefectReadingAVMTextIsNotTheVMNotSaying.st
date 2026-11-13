tests
testADefectReadingAVMTextIsNotTheVMNotSaying

	"#118: any error reading the image's name from the VM read as 'the VM does not say'."

	<readsAnUnsoundHeap>
	| raw |
	raw := self rawHeapWith: DefectiveVMVariablesDouble new.

	self should: [ raw statedText: 'imageName' ] raise: ZeroDivide
