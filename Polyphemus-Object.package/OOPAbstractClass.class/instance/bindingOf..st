variables
bindingOf: aName

	"The binding of aName in the image being read, as a GlobalVariable of this image (the
	highlighter asks #isGlobalVariable), kept so one name is one object. nil when absent."

	| binding |
	binding := memory globalNamed: aName.
	binding ifNil: [ ^ nil ].
	^ memory
		  wrappedVariableAt: 'global.' , aName asString
		  ifAbsentPut: [
			  GlobalVariable
				  key: aName asString asSymbol
				  value: ([ binding reifiedSlotAt: 2 ] on: Error do: [ :e | binding ]) ]
