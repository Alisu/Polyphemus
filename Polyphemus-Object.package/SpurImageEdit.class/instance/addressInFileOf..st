editing
addressInFileOf: aReifiedObject

	"Where that object is in the file, which is not where the reading has it. An immediate is
	its own value and is shifted by nothing."

	aReifiedObject isImmediateOop ifTrue: [ ^ aReifiedObject address ].
	^ aReifiedObject address - shift
