accessing
buildId

	^ buildId ifNil: [ buildId := self buildIdIn: (self bytes first: 4096) ]
