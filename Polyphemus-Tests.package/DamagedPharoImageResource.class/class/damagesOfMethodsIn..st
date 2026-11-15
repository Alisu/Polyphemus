damages
damagesOfMethodsIn: aCleanReading

	"In three methods of Interval (#206): the class binding of last pointing at the global
	Smalltalk's binding, the selector of size at collect:'s, the first literal of collect: a
	tagged word. No header that is no integer: VMMaker does not load such a file (#207)."

	| interval method pointingAt |
	interval := aCleanReading oopClassNamed: 'Interval'.
	method := [ :name | interval methodNamed: name ifAbsent: [ self error: 'no Interval>>' , name ] ].
	pointingAt := [ :object | [ :distance | object address - distance ] ].
	^ {
		  ((DamagedCandleImage slot: (method value: 'last') numberOfLiterals + 1 of: (method value: 'last'))
		   -> (pointingAt value: (aCleanReading globalNamed: #Smalltalk))).
		  ((DamagedCandleImage slot: (method value: 'size') numberOfLiterals of: (method value: 'size'))
		   -> (pointingAt value: (method value: 'collect:') oopSelector)).
		  ((DamagedCandleImage slot: 2 of: (method value: 'collect:')) -> self taggedWord) }
