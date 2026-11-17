tools
rows: someLines

	^ (someLines collect: [ :each |
		   Dictionary new
			   at: 'name' put: each name;
			   at: 'objects' put: each count;
			   at: 'bytes' put: each bytes;
			   yourself ]) asArray
