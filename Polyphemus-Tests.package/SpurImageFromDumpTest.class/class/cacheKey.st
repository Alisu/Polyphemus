accessing
cacheKey

	"What the written image depends on: the dump -- its size and date -- and every class
	definition and method of Polyphemus-Object, where the readers and the writer live. A
	change to either is a miss, and the writer runs again."

	| dump package code |
	dump := SpurDumpedMemoryTest new dumpFile.
	package := RPackageOrganizer default packageNamed: 'Polyphemus-Object'.
	code := String streamContents: [ :stream |
		        (package definedClasses asSortedCollection: [ :a :b | a name <= b name ]) do: [
			        :each | stream nextPutAll: each definitionString ].
		        (package methods asSortedCollection: [ :a :b | a printString <= b printString ])
			        do: [ :each |
				        stream
					        nextPutAll: each printString;
					        nextPutAll: each sourceCode ] ].
	^ dump size printString , '-' , dump modificationTime asUnixTime printString , '-'
	  , code size printString , '-' , code hash printString
