instance creation
on: aProcessMemory

	"An editor for that running image. It writes only while the process is stopped, which the
	reader itself refuses to do otherwise."

	^ self new
		  setProcess: aProcessMemory;
		  yourself
