globals
globalNamed: aName

	"The binding of a global in the image being read, or nil. Resolving against our own
	globals instead would answer this image's Object, this image's Smalltalk, and any
	class the two images happen to share by name but not by content."

	| globals wanted |
	wanted := aName asString.
	globals := [ self reifiedGlobals ] on: Error do: [ :e | nil ].
	globals ifNil: [ ^ nil ].
	1 to: ([ globals oopNumberOfSlots ] on: Error do: [ :e | 0 ]) do: [ :index |
		[ | binding |
		  binding := globals reifiedSlotAt: index.
		  binding isNilOop ifFalse: [
			  (binding reifiedSlotAt: 1) asString = wanted ifTrue: [ ^ binding ] ] ]
			on: Error
			do: [ :e | "unreadable entry: keep looking" ] ].
	^ nil
