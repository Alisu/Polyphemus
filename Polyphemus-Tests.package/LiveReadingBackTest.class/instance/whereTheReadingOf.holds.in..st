helpers
whereTheReadingOf: aHeldProcess holds: anAddress in: aPid

	"For a failure: the piece of the reading that holds the address, old space as the reading has
	it, what a reading reads that falls in that piece, and the process's own map around it (#185)."

	^ [
	  | piece raw near reads hex |
	  hex := [ :stretch | stretch key printStringHex , '-' , stretch value printStringHex ].
	  raw := aHeldProcess dumped raw.
	  piece := raw space pieceHolding: anAddress.
	  reads := (SpurRawHeap on: (LinuxProcessMemory on: aPid)) stretchesAReadingReads.
	  near := (('/proc/' , aPid printString , '/maps') asFileReference contents lines select: [ :line |
		           | range from to |
		           range := (line substrings: ' ') first substrings: '-'.
		           from := Number readFrom: range first base: 16.
		           to := Number readFrom: range second base: 16.
		           from - 67108864 <= anAddress and: [ anAddress <= (to + 67108864) ] ]) collect: [ :line |
		          (line substrings: ' ') first , ' ' , (line substrings: ' ') second ].
	  'the reading holds 16r' , anAddress printStringHex , ' in a piece from 16r' , piece baseAddress printStringHex
	  , ' of ' , piece size printString , ' bytes; its old space 16r' , raw mappingStart printStringHex , ' to 16r'
	  , raw mappingLimit printStringHex , '; of the ' , reads size printString , ' stretches a reading reads, in that piece: '
	  , (' ' join: ((reads select: [ :each |
				     each key < (piece baseAddress + piece size) and: [ each value > piece baseAddress ] ]) collect: hex))
	  , '; the first five: ' , (' ' join: ((reads first: (5 min: reads size)) collect: hex)) , '; the map within 64 MB: '
	  , (', ' join: near) ]
		  on: Error
		  do: [ :error | 'the reading holds the address; where could not be said: ' , error messageText asString ]
