accessing
buildIdInMemory

	"The build of the library as loaded, as its format records it (an ELF note, a Mach-O UUID)."

	^ self library buildIdInMemory: memory at: self base
