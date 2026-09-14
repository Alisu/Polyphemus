tests
testDownloadNameForPharo10IsPinnedToABuild

	"The fixture must not move under us: 'latest-64' is whatever build is newest."

	| name |
	name := PharoImageAccessor downloadNameForPharo: 10.

	self deny: (name includesSubstring: 'latest').
	self assert: (name includesSubstring: 'build.527')
