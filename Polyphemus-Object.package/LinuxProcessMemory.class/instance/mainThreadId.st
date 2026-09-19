accessing
mainThreadId

	"The main thread's id is the process id; /proc/self names itself, so ask it."

	^ ((self pathFor: 'stat') asFileReference contents substrings: ' ') first
