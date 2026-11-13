vm variables
statedText: aName

	"The text the VM keeps in its character array aName, or nil where the VM does not say."

	^ self class whereTheVMSays: [ self vmVariables stringAt: aName ]
