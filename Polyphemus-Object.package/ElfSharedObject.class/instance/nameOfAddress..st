accessing
nameOfAddress: anOffset

	"The symbol whose extent (its value, for its size) holds an address relative to where the
	file is loaded. nil when none does: a stripped library hides its own functions."

	| low high |
	byAddress ifNil: [
		byAddress := ((self symbols associations reject: [ :each | each value = 0 ])
			              collect: [ :each | each value -> each key ]) asSortedCollection: [ :a :b | a key <= b key ].
		byAddress := byAddress asArray ].
	(byAddress isEmpty or: [ anOffset < byAddress first key ]) ifTrue: [ ^ nil ].
	low := 1.
	high := byAddress size.
	[ low < high ] whileTrue: [
		| middle |
		middle := low + high + 1 // 2.
		(byAddress at: middle) key <= anOffset
			ifTrue: [ low := middle ]
			ifFalse: [ high := middle - 1 ] ].
	^ ((byAddress at: low) key + ((sizes at: (byAddress at: low) value ifAbsent: [ 0 ]) max: 1)) > anOffset
		  ifTrue: [ (byAddress at: low) value ]
		  ifFalse: [ nil ]
