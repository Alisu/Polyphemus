running
setUp

	| dll |
	super setUp.
	dll := Smalltalk vm directory asFileReference / 'PharoVMCore.dll'.
	dll exists ifFalse: [ ^ self skip: 'no PharoVMCore.dll here: not a Windows host' ].
	library := PeSharedObject on: dll fullName
