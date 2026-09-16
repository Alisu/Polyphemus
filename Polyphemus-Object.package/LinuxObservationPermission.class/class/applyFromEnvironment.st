granting
applyFromEnvironment

	"Grant whatever `POLYPHEMUS_OBSERVER` asks for, so that an image can be made observable
	without changing it: `any`, or a process id. Anything else, including the variable being
	unset, grants nothing.

	Meant for a startup action. `bin/pharo-debuggable` reads the same variable and does the
	same thing one step earlier, before the virtual machine starts -- which is the only way
	to be observable during startup itself."

	| asked |
	asked := (Smalltalk os environment at: 'POLYPHEMUS_OBSERVER' ifAbsent: [ '' ])
		         trimBoth.
	asked isEmpty ifTrue: [ ^ nil ].
	asked = 'any' ifTrue: [ ^ self allowAnyObserver ].
	^ asked isAllDigits
		  ifTrue: [ self allowObserver: asked asNumber ]
		  ifFalse: [ nil ]
