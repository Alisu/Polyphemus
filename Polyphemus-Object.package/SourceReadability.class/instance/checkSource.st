checking
checkSource

	"nil when a sources file is there and some sampled method reads as its own source."

	| sample |
	([ memory retrieveSourceFiles sourcesFileStream ] on: Error do: [ :e | nil ]) ifNil: [
		^ #noSourcesFile ].
	sample := self sampleMethods.
	sample ifEmpty: [ ^ nil ].
	^ (sample anySatisfy: [ :each | self readsAsItsOwnSource: each ])
		  ifTrue: [ nil ]
		  ifFalse: [ #itsMethodsDoNotReadAsTheirSource ]
