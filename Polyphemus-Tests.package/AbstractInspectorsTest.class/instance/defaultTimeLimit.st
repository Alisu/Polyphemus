configuring
defaultTimeLimit

	"These tests load an image into the simulator and walk its memory; SUnit's
	ten second default fires the watchdog in the middle of that, which surfaces as
	unrelated errors rather than as a timeout."

	^ 5 minutes
