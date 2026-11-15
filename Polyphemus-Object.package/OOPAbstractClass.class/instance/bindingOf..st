variables
bindingOf: aName

	"The binding of aName in the image being read, as a GlobalVariable of this image (the
	highlighter asks #isGlobalVariable), kept so one name is one object. nil when absent or when
	the globals do not tell; a value that does not read is an OOPUnreadableSlot saying why."

	| binding |
	binding := [ memory globalNamed: aName ] on: PolyphemusError do: [ :refusal | nil ].
	binding ifNil: [ ^ nil ].
	^ memory
		  wrappedVariableAt: 'global.' , aName asString
		  ifAbsentPut: [
			  GlobalVariable
				  key: aName asString asSymbol
				  value: ([ binding reifiedSlotAt: 2 ]
						   on: PolyphemusError
						   do: [ :refusal | OOPUnreadableSlot named: aName asString because: refusal messageText asString on: memory ]) ]
