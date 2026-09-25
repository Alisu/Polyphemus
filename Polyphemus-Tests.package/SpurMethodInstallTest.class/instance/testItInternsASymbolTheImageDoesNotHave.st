tests
testItInternsASymbolTheImageDoesNotHave

	"The last of #25's rungs: a method under a name the image never held. The symbol is made
	and put where Symbol class>>lookup: looks, so the image finds the same one -- asking for
	it by name in the written image answers ours, not a second symbol beside it."

	| integer name compilation install answer |
	integer := reading oopClassNamed: 'Integer'.
	name := 'polyphemusZork'.
	self assert: ((SpurMethodInstall on: reading) scanTheSymbolTableFor: name) key isNil.
	compilation := (reading compileHostSource: name , ' ^ 42' for: integer) first.
	install := SpurMethodInstall on: reading.

	install install: compilation named: name in: integer.
	install memory writeTo: written.

	answer := self
		          evaluate: '{ 3 ' , name , '. (Integer >> #' , name , ') selector == #' , name , ' }'
		          in: written.
	self assert: (answer includesSubstring: '#(42 true)') description: 'the machine answered ' , answer
