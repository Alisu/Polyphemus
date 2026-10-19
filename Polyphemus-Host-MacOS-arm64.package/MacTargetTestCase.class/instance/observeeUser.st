helpers
observeeUser

	"Who the target runs as: under sudo, the user who called it, as an observee started by its
	owner would; otherwise nil, the target then running as we do. Root and the target as root
	could not show #90: what root made, root could use."

	| user |
	(LibC resultOfCommand: 'id -u') trimBoth = '0' ifFalse: [ ^ nil ].
	user := Smalltalk os environment at: 'SUDO_USER' ifAbsent: [ nil ].
	^ (user isNil or: [ user isEmpty or: [ user = 'root' ] ])
		  ifTrue: [ nil ]
		  ifFalse: [ user ]
