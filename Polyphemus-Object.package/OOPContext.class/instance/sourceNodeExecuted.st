context protocol
sourceNodeExecuted

	"Which node a frame stopped at needs the method's syntax tree and its pc map,
	which stage one does not build. Answer the method node parsed from the source, so
	the debugger has something structural without pretending to know the exact node."

	^ [ RBParser parseMethod: self sourceCode ] on: Error do: [ :e | nil ]
