fixing
compilationOf: aReifiedMethod for: aReifiedClass

	"The method as this image compiles it from its own source, answered only when the image
	holds exactly that -- what is written over it has to be written over something known."

	| source compiled |
	source := [ aReifiedMethod getSourceFromFile ] on: Error do: [ :e | nil ].
	(source isNil or: [ source isEmpty ]) ifTrue: [
		^ CannotWriteThere signal: 'that image has no source for the method being fixed' ].
	compiled := (reading compileHostSource: source for: aReifiedClass) ifNil: [
		            ^ CannotWriteThere signal: 'the method''s own source does not compile here' ].
	(reading host: compiled first matchesOop: aReifiedMethod) ifFalse: [
		^ NotInTheReading signal: 'the image does not hold what its source says it does' ].
	^ compiled
