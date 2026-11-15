scheduler
whyItsProcessesDoNotRead

	"nil where the processes of the image can be listed; else why not, in the refusal's words."

	^ [
	  self allReifiedProcesses.
	  nil ]
		  on: PolyphemusError
		  do: [ :refusal | refusal messageText asString ]
