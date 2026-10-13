tests
testTheHostPackageLoadedIsThisHosts

	"The baseline loads one Polyphemus-Host package, chosen by that attribute; the edition is
	made for the host it names."

	| madeFor |
	madeFor := PolyphemusMadeFor current.
	self assert: madeFor os equals: PolyphemusHost current os.
	self assert: madeFor cpu equals: PolyphemusHost current cpu.
	self assert: PolyphemusEdition current host os equals: madeFor os
