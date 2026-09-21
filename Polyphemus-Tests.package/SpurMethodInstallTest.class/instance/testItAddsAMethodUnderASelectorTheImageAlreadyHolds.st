tests
testItAddsAMethodUnderASelectorTheImageAlreadyHolds

	"Rung 3 of #25: a method the class never had at all. A virtual machine runs the written
	image and answers it -- the selector was not understood by any integer before."

	| integer selector compilation install answer |
	integer := reading oopClassNamed: 'Integer'.
	selector := self aUnarySelectorIntegersDoNotUnderstand.
	compilation := (reading
		                compileHostSource: selector asString , ' ^ 42'
		                for: integer) first.
	install := SpurMethodInstall on: reading.

	install install: compilation under: selector address in: integer.
	install writeTo: written.

	answer := self evaluate: '3 ' , selector asString in: written.
	self
		assert: (answer includesSubstring: '42')
		description: 'asked for ' , selector asString , ', the machine answered ' , answer
