stepping
holding: aHeldImage

	"Step the process the held image's debugger is on, run it until a method, and let it go
	when proceeded."

	image := aHeldImage.
	held := aHeldImage process.
	self releaseWith: [ aHeldImage letGo ]
