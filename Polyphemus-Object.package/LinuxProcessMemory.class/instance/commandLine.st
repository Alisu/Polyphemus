accessing
commandLine

	"How the process was started. The kernel separates the arguments with zero bytes."

	^ [
	  ((self pathFor: 'cmdline') asFileReference binaryReadStream upToEnd collect: [
		   :each |
		   each = 0
			   ifTrue: [ 32 ]
			   ifFalse: [ each ] ]) asString trimBoth ]
		  on: Error
		  do: [ :e | '' ]
