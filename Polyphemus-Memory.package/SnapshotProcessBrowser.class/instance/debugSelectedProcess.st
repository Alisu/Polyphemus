actions
debugSelectedProcess

	"Pharo's debugger, post mortem, on the stack of the process selected; nil when none is."

	^ processList selectedItem ifNotNil: [ :process | Polyphemus debugProcess: process in: reifiedMemory ]
