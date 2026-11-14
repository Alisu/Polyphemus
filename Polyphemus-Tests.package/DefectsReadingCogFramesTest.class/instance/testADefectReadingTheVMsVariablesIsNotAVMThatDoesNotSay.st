tests
testADefectReadingTheVMsVariablesIsNotAVMThatDoesNotSay

	"#118: where the VM does not say where a page ends or what a code address is, the frames are
	read without; a bug of our own on the way was taken for that."

	| framePointer |
	framePointer := (memory activationsOfProcess: process) first framePointer.
	self assert: (memory stacks isMarriedContext: context).

	self
		should: [ (self layoutWhoseVariablesFailIn: #pageWithHeadFP:) framesFromContext: context ]
		raise: ZeroDivide.
	self
		should: [ (self layoutWhoseVariablesFailIn: #stackPages) framesFrom: framePointer stackTop: nil ]
		raise: ZeroDivide.
	self
		should: [ (self layoutWhoseVariablesFailIn: #nameOfCodeAddress:) nameOfCodeAddress: framePointer ]
		raise: ZeroDivide
