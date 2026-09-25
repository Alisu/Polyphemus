tests
testAVirtualMachineRunsTheMethodThatWasInstalled

	"What an installed method is for: a machine runs it. The search lands on Integer>>*, so a
	wrong install would not survive one multiplication, small or large."

	| found install answer |
	found := self aMethodThatCanBeLengthenedIn: (reading oopClassNamed: 'Integer').
	found ifNil: [ ^ self fail: 'no method of Integer takes a statement that does nothing' ].
	install := SpurMethodInstall on: reading.
	install
		install: found third
		as: found first
		of: (reading oopClassNamed: 'Integer')
		insteadOf: found second.
	install memory writeTo: written.

	answer := self evaluate: '6 * 7 * 1000000000000 * 1000000000000' in: written.

	self
		assert: (answer includesSubstring: '42000000000000000000000000')
		description: 'the machine answered ' , answer
