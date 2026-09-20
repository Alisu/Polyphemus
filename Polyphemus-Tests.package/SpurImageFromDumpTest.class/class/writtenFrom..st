accessing
writtenFrom: aDumpedMemory

	"The dump written out as an image file, once for the class."

	^ Written ifNil: [
		  Written := (SpurImageFromDump on: aDumpedMemory) writeTo:
			             FileLocator temp / 'polyphemus-from-dump.image' ]
