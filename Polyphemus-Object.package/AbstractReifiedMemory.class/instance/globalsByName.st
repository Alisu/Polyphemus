globals
globalsByName

	"The globals of the image being read, indexed by name.

	Read one at a time it is a walk over thirteen thousand bindings, each one reified and
	its key turned into a string, and that is fine for a question asked once. It is not
	fine for the compiler: analysing a single method asks for a dozen names, and naming
	the temporaries of a stack analyses every frame of it. Reading the array once turned
	a minute of work into a second.

	Entries that cannot be read are skipped rather than raising -- a corrupted image does
	not owe us a well formed dictionary -- and the first binding for a name wins, which is
	what walking the array in order used to answer."

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
