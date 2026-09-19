accessing
loadableSegments

	"The pieces of the address space. The other program headers describe the dump itself."

	^ segments select: [ :each | each isLoadable ]
