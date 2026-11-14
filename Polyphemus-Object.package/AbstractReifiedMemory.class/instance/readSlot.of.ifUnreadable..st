reading damaged images
readSlot: anIndex of: anObject ifUnreadable: aBlock

	"Read a slot of an image we did not write. A bad word answers aBlock instead of raising
	from deep inside reification; a defect of our own is no bad word, and comes through."

	^ [ anObject reifiedSlotAt: anIndex ] on: PolyphemusError do: [ :e | aBlock value ]
