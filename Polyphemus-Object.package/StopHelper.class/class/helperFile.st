accessing
helperFile

	"The helper, or nil where it cannot be built: looked for once per session, as every stop asks."

	session == Smalltalk session ifFalse: [
		helper := self buildTheHelper.
		session := Smalltalk session ].
	^ helper
