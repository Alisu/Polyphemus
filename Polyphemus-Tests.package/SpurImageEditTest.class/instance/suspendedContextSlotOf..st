helpers
suspendedContextSlotOf: aWritableImageFile

	"The running process and the index, counting from one, of its suspendedContext slot, reached through the
	special objects array: SchedulerAssociation value activeProcess."

	| scanner association scheduler process |
	scanner := aWritableImageFile raw scanner.
	association := scanner slotOf: aWritableImageFile raw specialObjectsOop at: 4.
	scheduler := scanner slotOf: association at: 2.
	process := scanner slotOf: scheduler at: 2.
	^ process -> 2
