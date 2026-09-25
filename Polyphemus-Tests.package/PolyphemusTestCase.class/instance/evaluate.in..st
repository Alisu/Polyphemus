helpers
evaluate: anExpression in: anImage

	"What a virtual machine answers for that expression in that image, run headless. The
	answer goes to a file of this class's own: classes run side by side."

	| out |
	self putSourcesBeside: anImage.
	out := FileLocator temp / ('polyphemus-eval-' , self class name , '.txt').
	out ensureDelete.
	LibC system: Smalltalk vm fullPath , ' --headless ' , anImage fullName , ' eval "'
		, anExpression , '" > ' , out fullName , ' 2>&1'.
	^ out exists
		  ifTrue: [ out contents trimBoth ]
		  ifFalse: [ '' ]
