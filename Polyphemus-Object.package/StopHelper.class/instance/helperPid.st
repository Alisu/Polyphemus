accessing
helperPid

	"The helper's own pid, from its state file; nil before it wrote it, and nil for what names no
	process of a helper's: -1 is every process this user may signal (#179)."

	| lines pid |
	lines := self class linesIn: state.
	lines size < 2 ifTrue: [ ^ nil ].
	pid := lines second trimBoth.
	^ (pid notEmpty and: [ (pid allSatisfy: [ :each | each isDigit ]) and: [ pid asNumber > 1 ] ])
		  ifTrue: [ pid asNumber ]
