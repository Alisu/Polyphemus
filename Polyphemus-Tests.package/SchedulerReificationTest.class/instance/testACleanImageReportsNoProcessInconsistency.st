tests
testACleanImageReportsNoProcessInconsistency

	"Every check must stay quiet on a healthy image, or the report is noise."

	self assert: reifiedMemory processInconsistencies isEmpty
