library
selfTask

	"mach_task_self() is a macro over this variable."

	^ (ExternalAddress loadSymbol: 'mach_task_self_' from: self ffiLibraryName) unsignedLongAt: 1
