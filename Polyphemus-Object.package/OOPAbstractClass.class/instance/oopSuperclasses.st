accessing
oopSuperclasses

	"Its superclasses, nearest first. A chain that leads back on itself, as only a damaged image
	has, is refused by name, and so is one that leads to what is no class (#205)."

	| chain current |
	chain := OrderedCollection new.
	current := self oopSuperclass.
	[ current isNilOop ] whileFalse: [
		(current = self or: [ chain includes: current ]) ifTrue: [
			^ NotInTheReading signal: 'the superclasses of the class at ' , (address printStringRadix: 16)
				  , ' go round: ' , current whatItReadsAs , ' comes twice' ].
		chain add: current.
		current := current oopSuperclass ].
	^ chain
