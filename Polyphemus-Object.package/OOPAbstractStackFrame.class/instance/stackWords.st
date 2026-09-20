accessing
stackWords

	"The words of this frame's temporaries and operand stack, in the order a context holds
	them. Words, because not all of them are objects."

	^ stackWords ifNil: [ #(  ) ]
