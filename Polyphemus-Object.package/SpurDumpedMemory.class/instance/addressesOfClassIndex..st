reading
addressesOfClassIndex: anIndex

	"Where every object of that class is, by a walk over old space and new space that reifies
	nothing (#129)."

	| memory found |
	memory := self memory.
	found := OrderedCollection new.
	memory allOldSpaceObjectsDo: [ :oop | (memory classIndexOf: oop) = anIndex ifTrue: [ found add: oop ] ].
	raw youngObjectsDo: [ :oop | (memory classIndexOf: oop) = anIndex ifTrue: [ found add: oop ] ].
	^ found
