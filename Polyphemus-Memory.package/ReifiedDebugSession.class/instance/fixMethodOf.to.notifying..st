accessing
fixMethodOf: aContext to: aString notifying: aNotifier

	"Put that source where the context's method is: in the image held, or through the fix. Answers
	whether it was done, telling whoever asked what stopped it, and where, when it was not."

	(fix isNil and: [ held isNil ]) ifTrue: [
		^ self tell: aNotifier that: 'this image is open for reading only' at: 1 in: aString ].
	(self parseErrorIn: aString) ifNotNil: [ :error |
		^ self tell: aNotifier that: error errorMessage at: error start in: aString ].
	^ [
	  held
		  ifNil: [ fix apply: aString to: aContext homeMethod ]
		  ifNotNil: [
			  held fix: aContext homeMethod to: aString restartingAt: (self depthOf: aContext).
			  self updateContextTo: held context ].
	  true ]
		  on: Error
		  do: [ :error | self tell: aNotifier that: error messageText at: 1 in: aString ]
