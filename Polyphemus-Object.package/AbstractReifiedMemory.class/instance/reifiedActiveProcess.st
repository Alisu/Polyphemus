scheduler
reifiedActiveProcess

	"The process that was running when the image was written. Its suspended context
	is the top of that process' stack: a snapshot holds no frames, the VM turned them
	all into contexts before writing."

	^ self reifiedScheduler reifiedSlotAt: self activeProcessSlot
