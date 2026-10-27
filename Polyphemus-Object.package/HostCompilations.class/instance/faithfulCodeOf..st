highlighting
faithfulCodeOf: anActivation

	"The code this activation is running, compiled here and checked against the file. For a
	block activation that is the compiled block, which is a separate object with its own
	numbering and needs checking on its own."

	| host |
	host := self hostMethodFor: anActivation.
	host ifNil: [ ^ nil ].
	^ ([ anActivation isBlockContext ] on: Error do: [ :e | false ])
		  ifTrue: [ self hostBlockOf: anActivation in: host ]
		  ifFalse: [ host ]
