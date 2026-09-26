tests
testAJittedFrameIsJustAfterTheSendOfTheFrameAboveIt

	"Mapped through Cog's own map by VMMaker's Cogit. Checked without Cog: a frame is just after
	the send of the frame above -- its selector, a value... for a block, or perform/executeMethod.
	28 jitted frames and 12 checked in the VM 9 dump, 14 and 9 in the VM 10 one."

	| jitted checked |
	jitted := 0.
	checked := 0.
	memory allReifiedProcesses do: [ :process |
		| stack |
		stack := memory activationsOfProcess: process.
		stack doWithIndex: [ :each :index |
			(each isStackFrame and: [ each isMachineCodeFrame ]) ifTrue: [
				jitted := jitted + 1.
				self assert: each pc notNil.
				(index > 1 and: [ (stack at: index - 1) isStackFrame ]) ifTrue: [
					| callee sent |
					callee := stack at: index - 1.
					sent := self selectorSentJustBefore: each.
					self assert: ((sent beginsWith: 'perform') or: [
							 (sent endsWith: 'executeMethod:') or: [
								 callee isBlockContext
									 ifTrue: [ sent beginsWith: 'value' ]
									 ifFalse: [ sent = callee selector ] ] ]).
					checked := checked + 1 ] ] ] ].

	self assert: jitted >= 10.
	self assert: checked >= 8
