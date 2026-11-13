vm variables
statedFrom: aName to: anotherName

	"A stretch the VM keeps in two variables, start -> limit, or nil where it does not say both."

	^ self class whereTheVMSays: [ (self vmVariables at: aName) -> (self vmVariables at: anotherName) ]
