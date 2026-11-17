accessing
fixMethodOf: aContext to: aString notifying: aNotifier

	"Put that source where the context's method is: in the image held, or through the fix. Answers
	whether it was done; the save tells whoever asked what stopped it, and where."

	^ self fixMethodOf: aContext to: aString with: (MethodSave of: aString notifying: aNotifier)
