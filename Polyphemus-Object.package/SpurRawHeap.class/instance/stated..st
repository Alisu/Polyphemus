vm variables
stated: aName

	"The VM's variable aName, or nil where the VM does not say."

	^ self class whereTheVMSays: [ self vmVariables at: aName ]
