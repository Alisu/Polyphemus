mode
getObjectSlotNames: aClassOop

	"A class's instance variable names, read from its layout. An entry that does not read keeps
	its place as '(unreadable name)', so that each later name still names its own slot (#118)."

	| res layout |
	res := OrderedCollection new.
	layout := [ (aClassOop reifiedSlotAt: 4) reifiedSlotAt: 2 ]
		          on: Error
		          do: [ :e | nil ].
	layout ifNil: [ ^ res ].
	2 to: ([ layout oopNumberOfSlots ] on: Error do: [ :e | 1 ]) do: [ :anIndex |
		[ res add: ((layout reifiedSlotAt: anIndex) reifiedSlotAt: 1) ]
			on: Error
			do: [ :e | res add: '(unreadable name)' ] ].
	^ res
