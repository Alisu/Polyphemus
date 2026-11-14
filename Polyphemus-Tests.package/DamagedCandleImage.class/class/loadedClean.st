reading
loadedClean

	"The clean Candle image open in the simulator and not read yet: the test case whose memory it
	is, for a test to make or damage objects in before or after it sends postImageLoad to read it."

	| loaded |
	loaded := AbstractInspectorsTest new.
	loaded imagePath: self cleanFile fullName.
	loaded setUpUsingImageMarrying: false.
	^ loaded
