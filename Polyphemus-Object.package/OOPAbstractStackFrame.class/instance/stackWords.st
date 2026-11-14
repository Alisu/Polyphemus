accessing
stackWords

	"The words of this frame's temporaries and operand stack, in the order a context holds
	them. Words, because not all of them are objects. Refused by name where one did not read."

	whyNoStack ifNotNil: [ ^ self refuseItsStack ].
	^ stackWords ifNil: [ #(  ) ]
