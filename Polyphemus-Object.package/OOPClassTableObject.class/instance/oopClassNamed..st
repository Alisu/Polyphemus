accessing-classes
oopClassNamed: aString

	"The class of that name in the image read. Refused by name where there is none: said absent,
	or not to be told where some classes do not say their name (#118). Never the nil object."

	| unnamed |
	unnamed := 0.
	self classOopsDo: [ :each |
		each oopName = aString ifTrue: [ ^ each ].
		each hasAReadableName ifFalse: [ unnamed := unnamed + 1 ] ].
	^ NotInTheReading signal: (unnamed > 0
			   ifTrue: [ unnamed printString , ' of its classes do not say their name: whether this image has ' , aString , ' cannot be told' ]
			   ifFalse: [ 'no class named ' , aString , ' in this image' ])
