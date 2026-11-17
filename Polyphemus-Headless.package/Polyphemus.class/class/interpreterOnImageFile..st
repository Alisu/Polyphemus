reading
interpreterOnImageFile: aPath

	"An image file opened in VMMaker's simulator and not started; what the loader raises is
	refused by name (SimulatorSetUp class>>interpreterOnImageFile:, #207)."

	^ SimulatorSetUp interpreterOnImageFile: aPath