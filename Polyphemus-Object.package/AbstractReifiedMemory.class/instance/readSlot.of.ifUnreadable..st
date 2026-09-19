reading damaged images
readSlot: anIndex of: anObject ifUnreadable: aBlock

	"Read a slot of an image we did not write. A bad word answers aBlock instead of raising
	from deep inside reification."

	^ [ anObject reifiedSlotAt: anIndex ] on: Error do: [ :e | aBlock value ]
