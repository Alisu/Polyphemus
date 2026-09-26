tests
testEachEditionKeepsItsOwnDumpImageCache

	"#50: two hosts on one box printed their code differently, so each took the other's cached
	image for a stale one and deleted it. Each edition's cache is under its own name."

	self assert: (SpurImageFromDumpTest cacheDirectory fullName includesSubstring:
			 PolyphemusEdition current name)
