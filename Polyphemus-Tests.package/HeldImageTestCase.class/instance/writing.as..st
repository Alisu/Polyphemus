targets
writing: anExpression as: aName

	"Statements writing anExpression's value to the file aName, renamed in place so that a reader
	never sees it half written."

	^ '(dir / ''' , aName , '.part'') ensureDelete; writeStreamDo: [ :s | s print: ' , anExpression , ' ].
    (dir / ''' , aName , ''') ensureDelete.
    (dir / ''' , aName , '.part'') renameTo: ''' , aName , '''.'
