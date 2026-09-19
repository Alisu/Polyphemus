tests
testAJittedFrameIsJustAfterTheSendOfTheFrameAboveIt

	"Its pc comes from its machine code pc through Cog's own map, read by VMMaker's Cogit.
	Checked without Cog: a frame below another is just after the send that made it -- of its
	method's selector, of a value... when it runs a block, or of a send that runs a method
	under another name (perform..., withArgs:executeMethod:)."

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

	self assert: jitted >= 28.
	self assert: checked >= 12
