accessing
fixMethodOf: aContext to: aString with: aMethodSave

	"Put that source where the context's method is, as aMethodSave says: in the image held, or
	through the fix. Answers whether it was done."

	(fix isNil and: [ held isNil ]) ifTrue: [ ^ aMethodSave refuse: 'this image is open for reading only' ].
	^ aMethodSave writeWith: [
		  held
			  ifNil: [ fix apply: aString to: aContext homeMethod ]
			  ifNotNil: [
				  [ held fix: aContext homeMethod to: aString restartingAt: (self depthOf: aContext) ]
					  on: PartlySaved
					  do: [ :partly |
						  self updateContextTo: held context.
						  partly pass ].
				  self updateContextTo: held context ] ]
