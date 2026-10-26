context protocol
tempAt: anIndex put: aValue

	"The code pane assigns a frame's variables through this; a frame read from another image is
	not changed from here, not yet (#115)."

	^ NotOnAReading signalFor: #frameVariable
