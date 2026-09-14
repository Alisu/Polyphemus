globals
wrappedVariableAt: aKey ifAbsentPut: aBlock

	"Variable objects of this image standing in for variables of the one being read, kept
	so that the same variable is always the same object.

	In a real image a name has one binding, and code referring to it twice refers to that
	one object. Wrapping it fresh on every lookup gives the compiler two objects for one
	name, so it lays down two literals where the image has one, and every literal index
	after that shifts: code compiled from the image's own source stopped matching the code
	in the image, at exactly the second mention of a repeated global."

	wrappedVariables ifNil: [ wrappedVariables := Dictionary new ].
	^ wrappedVariables at: aKey ifAbsentPut: aBlock
