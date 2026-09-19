private
hexValueOf: aString

	"0x7ffe80c468c8 -> its value."

	^ Number readFrom: ((aString beginsWith: '0x') ifTrue: [ aString allButFirst: 2 ] ifFalse: [ aString ]) base: 16
