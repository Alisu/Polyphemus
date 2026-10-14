helpers
withoutStartupNoise: anOutput

	"The output without the line the Windows VM prints as it starts, an error that says
	'No error' (docs/patch-notes.md); the rest as it was written."

	^ String streamContents: [ :stream |
		  (anOutput lines reject: [ :each |
			   (each includesSubstring: 'sqMakeMemoryNotExecutableFromTo') and: [ each endsWith: 'No error' ] ])
			  do: [ :each | stream nextPutAll: each ]
			  separatedBy: [ stream lf ].
		  (anOutput notEmpty and: [ anOutput last = Character lf ]) ifTrue: [ stream lf ] ]
