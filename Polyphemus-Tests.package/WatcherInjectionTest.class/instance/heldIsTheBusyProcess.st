helpers
heldIsTheBusyProcess

	"Asked of the held image: the process held is the spinning one, forked at 40, and has a
	stack. Not where its loop was: a hold may stop it on the loop's own backward jump."

	^ '| process | process := self at: #process. (process priority = 40 and: [ process suspendedContext notNil ])'
