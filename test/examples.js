var assert = require("assert"),
	LINQ = require("../").LINQ;


describe('Synchronous (LINQ)', function(){
	it('Simple Where, OrderBy and ToArray', function(){
		var files = ['test.txt', 'choni.txt', 'legacy.zip', 'secrets.txt', 'etc.rar'];

		var arr = new LINQ(files)
			.Where(function(file) { return file.match('.txt$')=='.txt'; })
			.OrderBy(function(file) { return file;})
			.ToArray();
			
		assert.equal(3, arr.length, "There should be the correct number of items in the final array.");
		assert.equal('choni.txt', arr[0], "The first item must be the alphabetically sorted correctly.");
		assert.equal('secrets.txt', arr[1], "The second item must be the alphabetically sorted correctly.");
		assert.equal('test.txt', arr[2], "The third item must be the alphabetically sorted correctly.");
    });
	
	it('Simple OrderBy, Select and ToArray', function() {
		var users = [
			{name: 'Bob', joined: new Date('12/27/1993')},
			{name: 'Tom', joined: new Date('12/25/1993')},
			{name: 'Bill', joined: new Date('11/10/1992')},
		];
		
		var arr = new LINQ(users)
			.OrderBy(function(user) {return user.joined;})
			.Select(function(user) {return user.name;})
			.ToArray();
			
		assert.equal(3, arr.length,  "There should be the correct number of items in the final array.");
		assert.equal('Bill', arr[0], "The first item must be the alphabetically sorted correctly.");
		assert.equal('Tom', arr[1], "The second item must be the alphabetically sorted correctly.");
		assert.equal('Bob', arr[2], "The third item must be the alphabetically sorted correctly.");
	});
});

