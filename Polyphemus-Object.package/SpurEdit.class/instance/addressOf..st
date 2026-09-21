editing
addressOf: aReifiedObject

	"Where that object is here, which need not be where the reading has it. An immediate is
	its own value and is shifted by nothing."

	aReifiedObject isImmediateOop ifTrue: [ ^ aReifiedObject address ].
	^ aReifiedObject address - shift
