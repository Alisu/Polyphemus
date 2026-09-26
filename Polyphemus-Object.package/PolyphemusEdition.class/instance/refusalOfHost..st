checking
refusalOfHost: aHost

	"Why this edition should not run there, or nil."

	aHost = host ifTrue: [ ^ nil ].
	^ 'this is ' , self name , ', made to run on ' , host description , ': this host is '
	  , aHost description
