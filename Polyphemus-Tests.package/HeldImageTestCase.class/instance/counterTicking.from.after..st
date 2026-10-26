targets
counterTicking: aTickSource from: aStart after: someStatements

	"A process named counter calling Counter>>tick: (compiled from aTickSource) every 20 ms on n,
	from aStart, someStatements after each call."

	^ 'cls compile: ' , aTickSource printString , '.
[ | n | n := ' , aStart printString , '.
  [ n := cls new tick: n.
    ' , someStatements , '
    (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.
'
