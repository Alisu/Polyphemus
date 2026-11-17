tools
processes: someArguments

	"A list that a damaged object cut short says so, in its last line and in 'incomplete' (#211)."

	| image reified rows short structured |
	image := self imageAt: someArguments.
	reified := image reified.
	rows := image processes withIndexCollect: [ :each :i | self rowOfProcess: each numbered: i in: reified ].
	short := reified processes whyTheListMayBeShort.
	structured := Dictionary new at: 'processes' put: rows asArray; yourself.
	short ifNotNil: [ structured at: 'incomplete' put: short ].
	^ self
		  text: (String lf join: (rows collect: [ :each |
					    (each at: 'process') printString , '  ' , (each at: 'state') , '  priority '
					    , (each at: 'priority') printString , '  ' , ((each at: 'name') ifNil: [ '' ]) , '  '
					    , (each at: 'depth') printString , ' frames  ' , ((each at: 'top') ifNil: [ '-' ])
					    , ((each at: 'ends') ifNil: [ '' ] ifNotNil: [ :ends | '  (its stack ends there: ' , ends , ')' ]) ])
				   , (short ifNil: [ #(  ) ] ifNotNil: [ { '(' , short , ')' } ]))
		  structured: structured
