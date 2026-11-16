literals
bindingFor: aBinding

	"The image's own association for that name. A literal binding points at the image's
	global, so it is found there and never copied; refused where the globals do not tell."

	| name |
	name := aBinding key asString.
	^ (reading globalNamed: name)
		  ifNil: [ NotInTheReading signal: 'this image has no global named ' , name ]
		  ifNotNil: [ :global | global address ]
