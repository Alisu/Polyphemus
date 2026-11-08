tests
testANativeDebuggerGoesOnWithLldb

	"#18: on macOS the command that goes on in C is lldb's, on the same process."

	| report |
	report := MacStuckReport basicNew.
	report instVarNamed: #pid put: 4242.

	self assert: report nativeDebuggerCommand equals: 'lldb -p 4242 --batch -o ''thread backtrace'''
