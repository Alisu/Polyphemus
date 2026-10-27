accessing
fixMethodOf: aContext to: aString notifying: aNotifier

	"Put that source where the context's method is: in the image held, or through the fix. Answers
	whether it was done; the save tells whoever asked what stopped it, and where."

	| save |
	save := MethodSave of: aString notifying: aNotifier.
	(fix isNil and: [ held isNil ]) ifTrue: [ ^ save refuse: 'this image is open for reading only' ].
	^ save writeWith: [
		  held
			  ifNil: [ fix apply: aString to: aContext homeMethod ]
			  ifNotNil: [
				  held fix: aContext homeMethod to: aString restartingAt: (self depthOf: aContext).
				  self updateContextTo: held context ] ]
