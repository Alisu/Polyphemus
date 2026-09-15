reading objects
slotOf: anAddress at: anIndex

	"The oop in one slot of the object here, counting from one. The slots follow the header,
	and an overflow word sits in front of the address rather than after it, so this is the
	same arithmetic either way."

	^ space unsignedAt: anAddress + 8 + ((anIndex - 1) * 8) size: 8
