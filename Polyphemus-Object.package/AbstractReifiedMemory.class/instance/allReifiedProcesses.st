scheduler
allReifiedProcesses

	"Every process in the image. The scheduler only knows the queued ones, so find
	them by class identity instead: the class of the process that was running. Not by
	class name, which is PCProcess in a bootstrap image and Process elsewhere.

	#instancesOop hands back objects that are already reified."

	^ self reifiedActiveProcess oopClass instancesOop
