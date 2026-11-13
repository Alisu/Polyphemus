tests
testEachFrameBelowTheTopExecutesTheSendThatMadeTheFrameAboveIt

	"#184: a frame's executedPC was its pc, the bytecode after the send it waits in; a context's is
	pc - 1, as Pharo's Context answers, inside that send. Checked where the host reproduces the code."

	| frames checked |
	frames := stackPages mostRecentlyUsedPage frames.
	self assert: frames size >= 3.
	checked := 0.
	1 to: frames size - 1 do: [ :index |
		| node |
		node := (frames at: index + 1) sourceNodeExecuted.
		(node isKindOf: OOPUnknownSourceNode) ifFalse: [
			self assert: node isMessage.
			self assert: node selector equals: (frames at: index) selector.
			checked := checked + 1 ] ].
	self assert: checked > 0