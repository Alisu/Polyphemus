scheduler
reifiedScheduler

	"The one ProcessorScheduler of the image, reached through the association the
	special objects array keeps for it. Navigate by slot rather than by class name:
	a bootstrap image calls the class PCProcessorScheduler."

	^ (self reifiedSpecialObjectArray reifiedSlotAt: self schedulerAssociationSlot)
		  reifiedSlotAt: self associationValueSlot
