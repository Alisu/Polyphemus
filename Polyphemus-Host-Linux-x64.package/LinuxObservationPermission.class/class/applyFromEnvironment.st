granting
applyFromEnvironment

	"Grant what POLYPHEMUS_OBSERVER asks: 'any' or a pid; anything else grants nothing.
	bin/pharo-debuggable does the same before the VM starts."

	| asked |
	asked := (OSEnvironment current at: 'POLYPHEMUS_OBSERVER' ifAbsent: [ '' ])
		         trimBoth.
	asked isEmpty ifTrue: [ ^ nil ].
	asked = 'any' ifTrue: [ ^ self allowAnyObserver ].
	^ asked isAllDigits
		  ifTrue: [ self allowObserver: asked asNumber ]
		  ifFalse: [ nil ]
