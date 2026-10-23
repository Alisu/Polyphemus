context protocol
tempAt: anIndex put: aValue

	"The code pane assigns a frame's variables through this; a frame read from another image is
	not changed from here, not yet (#115)."

	^ NotOnAReading signal: 'Changing a variable of a frame read from another image is not supported yet'
