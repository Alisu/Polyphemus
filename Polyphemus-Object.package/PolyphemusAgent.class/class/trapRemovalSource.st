source
trapRemovalSource

	"Taking out a trap that never fired."

	^ '(Smalltalk globals at: #PolyphemusTrap ifAbsent: [ nil ]) ifNotNil: [ :link | link uninstall ].
Smalltalk globals removeKey: #PolyphemusTrap ifAbsent: [ ].
nil'
