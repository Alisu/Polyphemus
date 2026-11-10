where
pc

	"The pc the image's own debugger is at."

	^ (self request: '(self at: #session) interruptedContext pc') asNumber
