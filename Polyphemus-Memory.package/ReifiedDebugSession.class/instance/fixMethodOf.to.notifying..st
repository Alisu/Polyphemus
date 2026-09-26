accessing
fixMethodOf: aContext to: aString notifying: aNotifier

	"Put that source where the context's method is: in the image held, or through the fix. Answers
	whether it was done, telling whoever asked what stopped it when it was not."

	(fix isNil and: [ held isNil ]) ifTrue: [
		^ self tell: aNotifier that: 'this image is open for reading only' ].
	^ [
	  held
		  ifNil: [ fix apply: aString to: aContext homeMethod ]
		  ifNotNil: [
			  held fix: aContext homeMethod to: aString.
			  self updateContextTo: held context ].
	  true ]
		  on: Error
		  do: [ :error | self tell: aNotifier that: error messageText ]
