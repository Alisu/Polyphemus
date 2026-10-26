debugging
ast

	"Pharo puts its breakpoints in a method's tree, in the image the debugger runs in; a method read
	from another image is not there, and the observer may have its own of that name (#115)."

	^ NotOnAReading signalFor: #breakOnStack
