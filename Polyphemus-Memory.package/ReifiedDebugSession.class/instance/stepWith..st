stepping
stepWith: aHeldProcess

	"Step by asking the held image to, and let it go when proceeded. Without one, a reading
	cannot be stepped and the step buttons do nothing, as for any post mortem stack."

	held := aHeldProcess.
	self releaseWith: [ aHeldProcess letGo ]
