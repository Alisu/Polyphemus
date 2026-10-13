tests
testTheBaselineNamesThisHostForMetacello

	"Metacello offers no attribute for the operating system: the baseline adds one, from
	OSPlatform before anything of Polyphemus is loaded, so it must name the host as
	PolyphemusHost does."

	self assert: (BaselineOfPolyphemus new customProjectAttributes includes: PolyphemusHost current metacelloAttribute).
	self assert: (#( #'linux-x64' #'macos-arm64' #'windows-x64' #'linux-arm64' #'macos-x64' ) includes: PolyphemusHost current metacelloAttribute)
