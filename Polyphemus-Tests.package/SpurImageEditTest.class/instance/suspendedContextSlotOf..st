helpers
suspendedContextSlotOf: anEdit

	"The running process and the index of its suspendedContext slot, reached through the
	special objects array: SchedulerAssociation value activeProcess."

	| scanner association scheduler process |
	scanner := anEdit raw scanner.
	association := scanner slotOf: anEdit raw specialObjectsOop at: 4.
	scheduler := scanner slotOf: association at: 2.
	process := scanner slotOf: scheduler at: 2.
	^ process -> 2
