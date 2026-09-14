variables
bindingOf: aName

	"A name that is not an instance variable of the snapshot's class. Falling back to
	this image's environment is a cheat: it resolves Object or Smalltalk to ours, not
	to the ones in the file. Good enough to read source, wrong to act on."

	| aSymbol |
	aSymbol := aName asSymbol.
	^ (self innerBindingOf: aSymbol) ifNil: [
		  [ self class environment lookupVar: aSymbol ] on: Error do: [ :e | nil ] ]
