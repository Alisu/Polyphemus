accessing
helperPid

	"The helper's own pid, from its state file; nil before it wrote it."

	| lines |
	lines := self class linesIn: state.
	^ lines size < 2 ifTrue: [ nil ] ifFalse: [ lines second trimBoth asNumber ]
