testing
isTheVMLibrary: aPath

	"Whether a mapped file is the VM library, by its name on Linux, macOS or Windows."

	^ #( '/libPharoVMCore.so' '/libPharoVMCore.dylib' '\PharoVMCore.dll' ) anySatisfy: [ :each |
		  aPath asLowercase endsWith: each asLowercase ]
