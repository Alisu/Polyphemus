helpers
aFileElsewhere

	"A file that is not the helper's to touch, closed to others: what a link planted among the
	locks would point at (#179)."

	| file |
	file := directory parent / ('stop-helper-elsewhere-' , UUID new asString).
	file writeStreamDo: [ :stream | stream nextPutAll: 'mine' ].
	LibC system: 'chmod 600 ''' , file fullName , ''''.
	^ file
