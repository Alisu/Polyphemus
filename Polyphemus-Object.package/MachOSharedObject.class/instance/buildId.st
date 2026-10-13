accessing
buildId

	^ buildId ifNil: [ buildId := self uuidIn: self bytes ]
