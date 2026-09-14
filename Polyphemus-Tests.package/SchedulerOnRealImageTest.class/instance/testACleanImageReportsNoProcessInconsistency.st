tests
testACleanImageReportsNoProcessInconsistency

	"The image was written by a working VM: every queue must agree with every process
	sitting in it. If this fails on a healthy image the checks are wrong, not the image."

	self assert: reifiedMemory processInconsistencies isEmpty
