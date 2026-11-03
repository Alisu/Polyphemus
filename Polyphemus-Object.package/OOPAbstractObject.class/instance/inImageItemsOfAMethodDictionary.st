inspection
inImageItemsOfAMethodDictionary

	"Its selectors are its indexed slots, their methods the same places of its array; by selector."

	| named values items |
	named := self oopClass allOopSlotNames size.
	values := self oopSlotNamed: 'array'.
	items := OrderedCollection new.
	named + 1 to: self oopNumberOfSlots do: [ :index |
		| key |
		key := self reifiedSlotAt: index.
		key isNilInImage ifFalse: [
			items add: key inImageDescription -> (values reifiedSlotAt: index - named) ] ].
	^ items asSortedCollection: [ :a :b | a key <= b key ]
