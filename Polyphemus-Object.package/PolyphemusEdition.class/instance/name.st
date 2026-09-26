accessing
name

	"Made from what the edition checks, so the name cannot say something else."

	^ 'Polyphemus-Pharo' , host pharo printString , '-' , host os , '-' , host cpu , '-for-Pharo'
	  , ('-' join: (targets collect: [ :each | each printString ]))
