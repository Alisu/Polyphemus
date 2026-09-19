globals
globalsByName

	"The globals of the image being read, indexed by name and built once. Unreadable entries
	are skipped; the first binding for a name wins."

	| globals |
	globalsByName ifNotNil: [ ^ globalsByName ].

	globalsByName := Dictionary new.
	globals := [ self reifiedGlobals ] on: Error do: [ :e | nil ].
	globals ifNil: [ ^ globalsByName ].

	1 to: ([ globals oopNumberOfSlots ] on: Error do: [ :e | 0 ]) do: [ :index |
		[
		| binding |
		binding := globals reifiedSlotAt: index.
		binding isNilOop ifFalse: [
			globalsByName
				at: (binding reifiedSlotAt: 1) asString
				ifAbsentPut: [ binding ] ] ]
			on: Error
			do: [ :e | "unreadable entry: skip it" ] ].

	^ globalsByName
