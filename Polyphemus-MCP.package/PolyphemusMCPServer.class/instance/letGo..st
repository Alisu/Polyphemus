tools
letGo: someArguments

	"The held image runs on, and its handle is forgotten: once it is let go, not before (#180)."

	| session |
	session := self sessionAt: someArguments.
	session letTheImageGo.
	self images removeKey: (someArguments at: 'handle').
	^ self text: 'Let go: the image runs on.' structured: (Dictionary new at: 'handle' put: (someArguments at: 'handle'); yourself)
