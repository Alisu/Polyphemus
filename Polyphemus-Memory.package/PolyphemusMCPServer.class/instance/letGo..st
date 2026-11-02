tools
letGo: someArguments

	"The held image runs on, and its handle is forgotten."

	| session |
	session := self sessionAt: someArguments.
	self images removeKey: (someArguments at: 'handle').
	session letTheImageGo.
	^ self text: 'Let go: the image runs on.' structured: (Dictionary new at: 'handle' put: (someArguments at: 'handle'); yourself)
