running
setUp

	"The subject is the block of the first context found running one, with its process."

	super setUp.
	reifiedMemory allReifiedProcesses do: [ :each |
		(reifiedMemory contextsOfProcess: each) do: [ :aContext |
			aContext compiledCode isCompiledBlockOop ifTrue: [
				process := each.
				context := aContext.
				subject := aContext compiledCode.
				^ self ] ] ].
	self fail: 'no context of the image runs a block'
