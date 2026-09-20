reading
close

	stream ifNotNil: [ stream close. stream := nil ].
	writeStream ifNotNil: [ writeStream close. writeStream := nil ]
