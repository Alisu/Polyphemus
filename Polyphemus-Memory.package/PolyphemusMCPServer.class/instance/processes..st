tools
processes: someArguments

	| image reified rows |
	image := self imageAt: someArguments.
	reified := self reifiedOf: image.
	rows := (self processesOf: image) withIndexCollect: [ :each :i | self rowOfProcess: each numbered: i in: reified ].
	^ self
		  text: (String lf join: (rows collect: [ :each |
					    (each at: 'process') printString , '  ' , (each at: 'state') , '  priority '
					    , (each at: 'priority') printString , '  ' , ((each at: 'name') ifNil: [ '' ]) , '  '
					    , (each at: 'depth') printString , ' frames  ' , ((each at: 'top') ifNil: [ '-' ])
					    , ((each at: 'ends') ifNil: [ '' ] ifNotNil: [ :ends | '  (its stack ends there: ' , ends , ')' ]) ]))
		  structured: (Dictionary new at: 'processes' put: rows asArray; yourself)
