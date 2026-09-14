debugger protocol
methodClass

	"The class this method is installed in, as reified out of the snapshot. The
	debugger compares it against classes of the running image, which can never match,
	and that is the point: these methods belong to another image."

	^ [ self oopMethodClass ] on: Error do: [ :e | nil ]
