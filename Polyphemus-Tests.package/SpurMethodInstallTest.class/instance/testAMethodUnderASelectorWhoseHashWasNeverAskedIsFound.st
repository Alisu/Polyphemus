tests
testAMethodUnderASelectorWhoseHashWasNeverAskedIsFound

	"#163: a symbol whose hash was never asked has none, and the machine gives it one at the first
	send. Placed by the hash it had not, the method was in a slot no lookup goes to."

	| integer symbol compilation install answer |
	integer := reading oopClassNamed: 'Integer'.
	compilation := (reading compileHostSource: 'neverAskedItsHash ^ 42' for: integer) first.
	install := SpurMethodInstall on: reading.
	symbol := install intern: 'neverAskedItsHash'.
	install memory setHashBitsOf: symbol to: 0.

	install install: compilation under: symbol in: integer.
	self deny: (install memory hashBitsOf: symbol) equals: 0.
	install memory writeTo: written.

	answer := self evaluate: '3 neverAskedItsHash' in: written.
	self
		assert: (answer includesSubstring: '42')
		description: 'asked for neverAskedItsHash, the machine answered ' , answer