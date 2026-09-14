tests
testActiveProcessKeepsItsStackAsContexts

	"A snapshot holds no frames: before writing the image the VM turned every frame
	into a Context, and the process points at the top one."

	| context |
	context := reifiedMemory reifiedActiveProcess
		           reifiedSlotAt: reifiedMemory processSuspendedContextSlot.

	self assert: context oopClassName equals: 'Context'
