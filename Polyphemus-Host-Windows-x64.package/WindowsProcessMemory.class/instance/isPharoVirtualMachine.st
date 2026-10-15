testing
isPharoVirtualMachine

	^ self mappedFiles anySatisfy: [ :each | VMVariables isTheVMLibrary: each path ]
