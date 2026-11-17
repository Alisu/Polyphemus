telling
titleMarked: aTitle

	"aTitle with this session's marks in front, each once."

	| bare |
	marks ifNil: [ ^ aTitle ].
	bare := aTitle.
	marks do: [ :each | (bare beginsWith: '[' , each , '] ') ifTrue: [ bare := bare allButFirst: each size + 3 ] ].
	^ String streamContents: [ :stream |
		  marks do: [ :each | stream nextPut: $[; nextPutAll: each; nextPutAll: '] ' ].
		  stream nextPutAll: bare ]
