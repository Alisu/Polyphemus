reading
descriptor: aNumber in: aTaskDirectory

	"Its number and what /proc links it to: a path, a pipe, a socket; the number alone if it is gone."

	^ 'descriptor ' , aNumber printString
	  , ((self class linkTargetOf: (aTaskDirectory / 'fd' / aNumber printString) fullName)
			   ifNil: [ '' ]
			   ifNotNil: [ :target | ': ' , target ])
