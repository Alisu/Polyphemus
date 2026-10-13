testing
isPharoVirtualMachine

	^ self mappedFiles anySatisfy: [ :each | each path endsWith: '/libPharoVMCore.dylib' ]
