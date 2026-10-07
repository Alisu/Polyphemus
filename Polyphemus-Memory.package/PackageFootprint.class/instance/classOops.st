reading
classOops

	"Every class of the class table, once (a pun index may repeat one)."

	| root classes |
	root := objectMemory classTableRootObj.
	classes := OrderedCollection new.
	0 to: objectMemory numClassTablePages - 1 do: [ :p |
		| page |
		page := objectMemory fetchPointer: p ofObject: root.
		0 to: (objectMemory numSlotsOf: page) - 1 do: [ :i |
			| each |
			each := objectMemory fetchPointer: i ofObject: page.
			((objectMemory isNonImmediate: each) and: [ each ~= objectMemory nilObject ]) ifTrue: [
				classes add: each ] ] ].
	^ (classes asIdentitySet) asOrderedCollection
