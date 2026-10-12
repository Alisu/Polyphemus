results
failure: aString

	^ Dictionary new
		  at: 'content' put: { (Dictionary new at: 'type' put: 'text'; at: 'text' put: aString; yourself) };
		  at: 'isError' put: true;
		  yourself
