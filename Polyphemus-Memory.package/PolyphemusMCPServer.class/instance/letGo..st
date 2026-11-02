tools
letGo: someArguments

	"The held image runs on, and its handle is forgotten."

	| handle session |
	handle := someArguments at: 'handle' ifAbsent: [ self error: 'let_go needs the handle hold answered' ].
	session := (self images at: handle ifAbsent: [ self error: 'Nothing held as ' , handle printString ])
		           at: #session
		           ifAbsent: [ self error: handle , ' is a reading, not a held image: there is nothing to let go' ].
	self images removeKey: handle.
	session letTheImageGo.
	^ self text: 'Let go: the image runs on.' structured: (Dictionary new at: 'handle' put: handle; yourself)
