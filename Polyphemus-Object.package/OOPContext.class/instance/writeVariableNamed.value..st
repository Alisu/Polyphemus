context protocol
writeVariableNamed: aName value: aValue

	"How Pharo 10's code pane assigns a frame's variables: refused as from later ones (#115)."

	^ self tempAt: 0 put: aValue
