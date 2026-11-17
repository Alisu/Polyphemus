tools
sessionOn: aProcess in: aReifiedMemory

	"A post mortem session on that process's stack (ReifiedDebugSession class>>onProcess:in:)."

	^ ReifiedDebugSession onProcess: aProcess in: aReifiedMemory