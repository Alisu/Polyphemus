mode
getObjectSlotNames: aClassOop

	"The instance variable names of a class, read out of its layout.

	Defensive: a snapshot can hold a class whose layout is not shaped the way this
	expects, and losing every name because one entry is odd is worse than losing that
	entry. Which layouts those are is worth its own look."

	| res layout |
	res := OrderedCollection new.
	layout := [ (aClassOop reifiedSlotAt: 4) reifiedSlotAt: 2 ]
		          on: Error
		          do: [ :e | nil ].
	layout ifNil: [ ^ res ].
	2 to: ([ layout oopNumberOfSlots ] on: Error do: [ :e | 1 ]) do: [ :anIndex |
		[ res add: ((layout reifiedSlotAt: anIndex) reifiedSlotAt: 1) ]
			on: Error
			do: [ :e | "unreadable slot: skip it" ] ].
	^ res
