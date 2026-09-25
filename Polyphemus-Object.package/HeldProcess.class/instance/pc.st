where
pc

	"The pc the image's own debugger is at."

	^ (channel ask: '(self at: #session) interruptedContext pc') asNumber
