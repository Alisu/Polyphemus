reifying
addObjectHandler: aClass

	"Adding a handler makes every remembered answer suspect, so they are forgotten."

	objectHandlers add: aClass.
	handlerCache := nil
