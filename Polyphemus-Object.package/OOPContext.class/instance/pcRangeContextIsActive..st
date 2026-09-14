context protocol
pcRangeContextIsActive: aBoolean

	"Which part of the source the debugger should highlight. Mapping a pc back to a
	source range needs the method's syntax tree, which stage one does not build yet,
	so highlight nothing rather than the wrong thing."

	^ 1 to: 0
