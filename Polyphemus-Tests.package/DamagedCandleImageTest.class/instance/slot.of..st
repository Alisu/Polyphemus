running
slot: anIndex of: anObject

	"Where that slot's word is in the memory read: past the object's header."

	^ anObject address + 8 + (anIndex - 1 * 8)
