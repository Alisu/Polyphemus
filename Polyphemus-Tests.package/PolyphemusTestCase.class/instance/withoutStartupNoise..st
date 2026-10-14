helpers
withoutStartupNoise: anOutput

	"The output without the line the Windows VM prints as it starts, an error that says
	'No error' (docs/patch-notes.md)."

	^ String cr join: (anOutput lines reject: [ :each |
			   (each includesSubstring: 'sqMakeMemoryNotExecutableFromTo') and: [ each endsWith: 'No error' ] ])
