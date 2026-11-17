tools
addressOf: anObject

	"Where to inspect it, or nil for an immediate (a SmallInteger, a Character), which is its own value."

	^ anObject isImmediateOop
		  ifTrue: [ nil ]
		  ifFalse: [ anObject address ]
