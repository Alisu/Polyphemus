helpers
drawEachFrameOf: aDebugger

	"Select each frame of aDebugger's stack and draw its window: each shows another method of
	another class, which the code pane colours (#89). Done by the UI process (#31)."

	1 to: aDebugger stackTable items size do: [ :index |
		self inUIProcess: [
			aDebugger stackTable selectIndex: index.
			self drawWindowOf: aDebugger ] ]
