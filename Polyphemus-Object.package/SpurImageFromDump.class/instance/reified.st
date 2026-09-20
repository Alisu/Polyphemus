writing
reified

	"The dump's objects, read the way a dump is read: frames through Cog's layout. Every
	object of it, because the processes are found among them."

	^ reified ifNil: [ reified := dumped reifyEverything: dumped reifiedMemory ]
