tests
testAStateThatNamesNoHelperSignalsNothing

	"#179: ending a stop signals the pid the state file names. One that names no process of a
	helper's (-1 is every process the user may signal, 1 the system's first) names none."

	| stop |
	stop := StopHelper on: target in: directory.
	#( '-1' '0' '1' 'x' ) do: [ :each |
		| state |
		state := directory / ('forged-' , each , '.state').
		state writeStreamDo: [ :stream | stream nextPutAll: 'stopped'; lf; nextPutAll: each; lf ].
		stop instVarNamed: #state put: state.
		self assert: stop helperPid isNil ]
