stepping
letGo

	"End the agent: the image goes on, and the held process with it, back in its run queue if the
	hold had taken it out (#103)."

	channel ask: '(self at: #suspended ifAbsent: [ false ]) ifTrue: [
	self removeKey: #suspended.
	(self at: #process) resume ].
nil'.
	channel letGo
