building
forget

	"Every byte changed: what it was is now only in a copy."

	regions do: [ :each | each bytes atAllPut: 0 ]
