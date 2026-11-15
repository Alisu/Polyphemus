checking
checkSource

	"nil when the methods the processes run can be sampled, a sources file is there and some
	sampled method reads as its own source; nil too where no process runs a method to ask."

	| sample |
	sample := [ self sampleMethods ] on: PolyphemusError do: [ :refusal | ^ #itsRunningMethodsDoNotRead ].
	memory retrieveSourceFiles sourcesFileStream ifNil: [ ^ #noSourcesFile ].
	sample ifEmpty: [ ^ nil ].
	^ (sample anySatisfy: [ :each | self readsAsItsOwnSource: each ])
		  ifTrue: [ nil ]
		  ifFalse: [ #itsMethodsDoNotReadAsTheirSource ]
