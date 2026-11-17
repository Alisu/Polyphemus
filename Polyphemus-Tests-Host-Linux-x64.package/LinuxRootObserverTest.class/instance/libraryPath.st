helpers
libraryPath

	"Where the VM finds its library: ours, as sudo drops every LD_ variable and the VM did not
	start as the observee without it (libPharoVMCore.so not found)."

	^ OSEnvironment current
		  at: 'LD_LIBRARY_PATH'
		  ifAbsent: [ PharoImageAccessor pathToTargetVM asFileReference parent fullName ]
