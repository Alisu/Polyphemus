reading
readingPokedWith: aBlock

	"A reading of the Candle image damaged once loaded, as a dump's memory is: given the clean
	reading, aBlock answers the words to overwrite, each as address -> word. Nothing shifts them."

	| clean loaded |
	clean := self readingOf: self cleanFile.
	loaded := self loadedClean.
	(aBlock value: clean) do: [ :each | (loaded instVarNamed: 'memory') long64At: each key put: each value ].
	loaded postImageLoad.
	^ loaded instVarNamed: 'reifiedMemory'
