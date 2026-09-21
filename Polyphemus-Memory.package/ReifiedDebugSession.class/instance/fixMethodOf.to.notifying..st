accessing
fixMethodOf: aContext to: aString notifying: aNotifier

	"Put that source where the context's method is. Answers whether it was done, telling
	whoever asked what stopped it when it was not."

	fix ifNil: [
		^ self tell: aNotifier that: 'this image is open for reading only' ].
	^ [
	  fix apply: aString to: aContext homeMethod.
	  true ]
		  on: Error
		  do: [ :error | self tell: aNotifier that: error messageText ]
