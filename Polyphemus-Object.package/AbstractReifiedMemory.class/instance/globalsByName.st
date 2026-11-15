globals
globalsByName

	"The globals of the image being read, indexed by name and built once; the first binding for
	a name wins. An entry that does not read, or whose name is no string, is passed over and
	counted. Where the globals themselves do not read, refused by name, each time (#118)."

	| globals found passedOver |
	globalsByName ifNotNil: [ ^ globalsByName ].
	globals := [ self reifiedGlobals allReifiedSlots ] on: PolyphemusError do: [ :refusal |
		           ^ NotInTheReading signal: 'the globals of this image do not read: ' , refusal messageText asString ].
	found := Dictionary new.
	passedOver := 0.
	globals do: [ :binding |
		binding isNilOop ifFalse: [
			| name |
			name := binding isUnreadableSlot ifFalse: [
				        [ binding reifiedSlotAt: 1 ] on: PolyphemusError do: [ :refusal | nil ] ].
			(name notNil and: [ name isStringOop ])
				ifTrue: [ found at: name asString ifAbsentPut: [ binding ] ]
				ifFalse: [ passedOver := passedOver + 1 ] ] ].
	globalsPassedOver := passedOver.
	^ globalsByName := found
