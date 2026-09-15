naming
lookupTempVar: aName in: anActivation

	"The variable named here, when it is one this activation holds. Answers nil for anything
	else, so that asking for a name that is not a temporary is not an error."

	| var |
	var := self lookupVar: aName in: anActivation.
	var ifNil: [ ^ nil ].
	^ ([ var isLocalVariable ] on: Error do: [ :e | false ])
		  ifTrue: [ var ]
		  ifFalse: [ nil ]
