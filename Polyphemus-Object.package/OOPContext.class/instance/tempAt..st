context protocol
tempAt: anIndex

	"Temporaries follow the six fixed slots of a context."

	^ self reifiedSlotAt: anIndex + memory contextReceiverSlot
