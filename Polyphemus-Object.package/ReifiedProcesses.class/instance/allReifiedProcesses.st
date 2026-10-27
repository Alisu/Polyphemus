scheduler
allReifiedProcesses

	"Every process, found by the class of the one that was running -- the scheduler only knows
	the queued ones, and the class name differs (PCProcess, Process). Already reified."

	^ self reifiedActiveProcess oopClass instancesOop
