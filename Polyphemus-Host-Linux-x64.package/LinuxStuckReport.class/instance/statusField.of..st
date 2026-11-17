reading
statusField: aName of: aProcess

	"A hexadecimal field of /proc/<pid>/status, such as SigCgt; 0 when absent."

	^ ((aProcess pathFor: 'status') asFileReference contents lines
		   detect: [ :each | each beginsWith: aName , ':' ]
		   ifNone: [ ^ 0 ]) in: [ :line | Number readFrom: (line copyAfter: $:) trimBoth base: 16 ]
