highlighting
compileHostSource: aString for: aReifiedClass

	"That source compiled here as the image's own compiler would, with its tree: {method.
	tree}. Nothing when it does not compile."

	^ self compileHostSource: aString for: aReifiedClass doIt: false
