inspection
oopClassChainNames

	"The names of this object's class and its superclasses, as the image has them."

	| names class |
	names := OrderedCollection new.
	class := self oopClass.
	[ class isKindOf: OOPAbstractClass ] whileTrue: [
		names add: class name asString.
		class := class oopSuperclass ].
	^ names
