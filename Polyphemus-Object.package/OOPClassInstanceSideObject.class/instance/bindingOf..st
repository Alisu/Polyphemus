variables
bindingOf: aName

	"A name that is not an instance variable: look it up in the globals of the image
	being read. Answering nil when it is not there is the honest result; falling back
	to our own globals would bind a name to a class of this image that only shares a
	name with the one in the file."

	^ (self innerBindingOf: aName asString asSymbol) ifNil: [
		  memory globalNamed: aName ]
