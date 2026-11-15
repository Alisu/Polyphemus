printing
oopName

	"Its name as the image has it, or a placeholder where that is no string that reads."

	| className |
	className := [ self classNameObject ] on: PolyphemusError do: [ :refusal | ^ 'Invalid ClassName' ].
	className isStringOop ifFalse: [ ^ 'Invalid ClassName' ].
	^ className printString
