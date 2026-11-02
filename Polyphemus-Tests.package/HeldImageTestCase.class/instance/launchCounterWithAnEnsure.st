targets
launchCounterWithAnEnsure

	"A counter process whose loop is in an ensure block that leaves a file named ensured when it
	ends, writing its count to the file named n; its pid."

	^ self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	^ n + 1''.
[ [ | n | n := 0.
    [ n := cls new tick: n.
      ' , (self writing: 'n' as: 'n') , '
      (Delay forMilliseconds: 20) wait ] repeat ]
  ensure: [ (dir / ''ensured'') ensureCreateFile ] ] forkNamed: ''counter''.
'
