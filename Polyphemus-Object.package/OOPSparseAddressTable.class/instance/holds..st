private
holds: anAddress

	^ ranges anySatisfy: [ :each | anAddress >= each key and: [ anAddress < each value ] ]
