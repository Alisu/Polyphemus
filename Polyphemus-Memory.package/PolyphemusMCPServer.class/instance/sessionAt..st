tools
sessionAt: someArguments

	"The debug session of the image held as the handle given, which steps it."

	| handle |
	handle := someArguments at: 'handle' ifAbsent: [ self error: 'This tool needs the handle hold answered' ].
	^ (self images at: handle ifAbsent: [ self error: 'Nothing held as ' , handle printString , '; hold one with hold' ])
		  at: #session
		  ifAbsent: [ self error: handle , ' is a reading, not a held image: hold one with hold' ]
