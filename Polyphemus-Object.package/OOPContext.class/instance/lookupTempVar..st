context protocol
lookupTempVar: aName

	"The variable named here, when it is one this frame holds. Answers nil for anything
	else, so that asking for a name that is not a temporary is not an error."

	| var |
	var := self lookupVar: aName.
	var ifNil: [ ^ nil ].
	^ ([ var isLocalVariable ] on: Error do: [ :e | false ])
		  ifTrue: [ var ]
		  ifFalse: [ nil ]
