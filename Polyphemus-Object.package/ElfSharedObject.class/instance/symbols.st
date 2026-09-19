accessing
symbols

	"Name to value of every defined symbol of the full table (type 2), or of the dynamic
	one (type 11) when the file was stripped."

	^ symbols ifNil: [
		  | tables |
		  tables := OrderedCollection new.
		  self sectionsDo: [ :type :offset :size :link |
			  tables add: { type. offset. size. link } ].
		  symbols := Dictionary new.
		  (tables detect: [ :each | each first = 2 ] ifNone: [
			   tables detect: [ :each | each first = 11 ] ifNone: [ nil ] ]) ifNotNil: [ :table |
			  self readSymbols: table strings: (tables at: (table at: 4) + 1) ].
		  symbols ]
