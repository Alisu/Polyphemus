private
keepStillSource

	"For the image: the held process out of its run queue while it is held, as Pharo's debugger keeps
	a process it debugs. The agent's spinning kept it from running only until a simulated wait made
	the agent itself wait (#103). One waiting on a semaphore is left: it would lose its wait."

	^ '((Processor instVarNamed: #quiescentProcessLists) includes: ((self at: #process) instVarNamed: #myList))
	ifTrue: [ (self at: #process) suspend. self at: #suspended put: true ].
'
