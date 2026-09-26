editing
store: aValue inSlot: anIndex ofObjectShown: aReifiedObject

	"Set, stopped, a slot of an object the last reading shows."

	self whileStillWhereRead: aReifiedObject do: [ :memory |
		(SpurEdit on: memory reading: reading)
			store: aValue
			inSlot: anIndex
			ofObjectShown: aReifiedObject ]
