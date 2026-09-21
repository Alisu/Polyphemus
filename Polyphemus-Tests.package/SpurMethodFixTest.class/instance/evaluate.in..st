helpers
evaluate: anExpression in: anImage

	"What a virtual machine answers for that expression in that image, run headless."

	| out |
	out := FileLocator temp / 'polyphemus-fixed-eval.txt'.
	out ensureDelete.
	LibC system: Smalltalk vm fullPath , ' --headless ' , anImage fullName , ' eval "'
		, anExpression , '" > ' , out fullName , ' 2>&1'.
	^ out exists
		  ifTrue: [ out contents trimBoth ]
		  ifFalse: [ '' ]
