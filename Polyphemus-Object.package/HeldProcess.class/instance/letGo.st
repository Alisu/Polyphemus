stepping
letGo

	"The process back in its queue, and the image let go."

	channel ask: '(self at: #process) resume. nil'.
	channel letGo
