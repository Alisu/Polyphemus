running
whatIsAsked

	"What a reading is asked of its scheduler and of a process, by name."

	^ {
		  ('allReifiedProcesses' -> [ reifiedMemory allReifiedProcesses ]).
		  ('reifiedActiveProcess' -> [ reifiedMemory processes reifiedActiveProcess ]).
		  ('reifiedScheduler' -> [ reifiedMemory processes reifiedScheduler ]).
		  ('reifiedProcessLists' -> [ reifiedMemory processes reifiedProcessLists ]).
		  ('runnableProcesses' -> [ reifiedMemory processes runnableProcesses ]).
		  ('contextsOfProcess:' -> [ reifiedMemory contextsOfProcess: process ]).
		  ('activationsOfProcess:' -> [ reifiedMemory activationsOfProcess: process ]) }
