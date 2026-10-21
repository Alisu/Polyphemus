tests
testAnErrorProceededFromTheDebuggerDoesNothingMore

	"Let go before an error is shown, the process runs again: proceeding from that error in the
	debugger must not go on with the block, which would write into a running image (#103)."

	| lettings wrote |
	lettings := 0.
	wrote := false.
	[ [ self error: 'refused while held'. wrote := true ] valueThenLetGo: [ lettings := lettings + 1 ] ]
		on: Error
		do: [ :error | error resumeUnchecked: nil ].
	self deny: wrote description: 'the block went on after its process was let go'.
	self assert: lettings equals: 1
