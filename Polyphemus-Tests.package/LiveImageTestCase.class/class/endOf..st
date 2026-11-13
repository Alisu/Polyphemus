restarting
endOf: aLog

	"What a target's log says of how it ended, on one line: its start and its end when it is long (#190)."

	| line |
	aLog ifNil: [ ^ 'it left no log' ].
	line := ' / ' join: ((aLog lines collect: [ :each | each trimBoth ]) reject: [ :each | each isEmpty ]).
	line isEmpty ifTrue: [ ^ 'its log is empty' ].
	line size > 1300 ifTrue: [ line := (line first: 600) , ' [...] ' , (line last: 600) ].
	^ 'its log: ' , line
