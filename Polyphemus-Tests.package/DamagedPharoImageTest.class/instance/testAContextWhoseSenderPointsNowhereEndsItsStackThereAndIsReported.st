tests
testAContextWhoseSenderPointsNowhereEndsItsStackThereAndIsReported

	"#196: the stack of its process and both reports of the image raised."

	| stacks process context |
	stacks := reifiedMemory stacks.
	process := DamagedPharoImageResource process: 'MorphicRenderLoop>>doOneCycleWhile:' in: reifiedMemory.
	context := (reifiedMemory contextsOfProcess: process) first.

	self assert: (reifiedMemory contextsOfProcess: process) size equals: 1.
	self assert: (stacks activationsOfProcess: process) size equals: 1.
	self assert: (stacks contextsFrom: context) size equals: 1.
	self assert: (stacks stackFrom: context ofSize: 10) size equals: 1.
	self deny: (stacks isMarriedContext: context).
	self deny: (stacks marriedContexts includes: context).
	self should: [ context sender ] raise: NotInTheReading.
	self assert: (stacks contextInconsistencies includes: context -> #senderIsUnreadable)
