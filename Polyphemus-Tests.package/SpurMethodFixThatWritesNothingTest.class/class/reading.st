accessing
reading

	^ Reading ifNil: [ Reading := Polyphemus readImageFile: PharoImageAccessor pathToPharo10 ]
