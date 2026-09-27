accessing
cacheKey

	"What the written image depends on: the dump -- its size and date -- and every class and
	method that reads, reifies or writes it (methodsTheWrittenImageDependsOn). A change to the
	live-image or editing code, which is most of them, keeps the image."

	| dump code |
	dump := SpurDumpedMemoryTest new dumpFile.
	code := String streamContents: [ :stream |
		        (self classesTheWrittenImageDependsOn asSortedCollection: [ :a :b | a name <= b name ])
			        do: [ :each | stream nextPutAll: each definitionString ].
		        (self methodsTheWrittenImageDependsOn asSortedCollection: [ :a :b |
			         a printString <= b printString ]) do: [ :each |
			        stream
				        nextPutAll: each printString;
				        nextPutAll: each sourceCode ] ].
	^ dump size printString , '-' , dump modificationTime asUnixTime printString , '-'
	  , code size printString , '-' , code hash printString
