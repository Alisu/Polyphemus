printing
nativeDebuggerCommand

	"The command showing the main thread's C stack: it attaches, stops the process that moment,
	and lets it go (#18)."

	^ 'gdb -p ' , pid printString , ' -batch -ex bt'
