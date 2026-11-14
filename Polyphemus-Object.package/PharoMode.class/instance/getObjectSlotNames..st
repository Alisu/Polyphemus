mode
getObjectSlotNames: aClassOop

	"A class's instance variable names, from its layout's scope; none where the layout has no scope
	(bytes, compiled methods). An entry that does not read keeps its place as '(unreadable name)',
	so that each later name still names its own slot (#118)."

	| res scope |
	res := OrderedCollection new.
	scope := [
	         | layout |
	         layout := aClassOop reifiedSlotAt: 4.
	         layout oopNumberOfSlots < 2
		         ifTrue: [ nil ]
		         ifFalse: [ layout reifiedSlotAt: 2 ] ]
		         on: PolyphemusError
		         do: [ :e | nil ].
	scope ifNil: [ ^ res ].
	2 to: ([ scope oopNumberOfSlots ] on: PolyphemusError do: [ :e | 1 ]) do: [ :anIndex |
		[ res add: ((scope reifiedSlotAt: anIndex) reifiedSlotAt: 1) ]
			on: PolyphemusError
			do: [ :e | res add: '(unreadable name)' ] ].
	^ res
