editing
store: aString inItemKeyed: aKey

	"What the Oop tab does with a value typed in a slot's row: stored by the reading's editor,
	where the reading came from. The reading itself still shows what was read."

	memory editor ifNil: [ ^ self error: 'this memory is only read: nothing typed here is stored' ].
	memory editor
		store: (self valueTyped: aString)
		inSlot: (self slotIndexOfItemKeyed: aKey)
		ofObjectShown: self
