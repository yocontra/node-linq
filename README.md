![status](https://secure.travis-ci.org/wearefractal/node-linq.png?branch=master)

## Information

<table>
<tr> 
<td>Package</td><td>node-linq</td>
</tr>
<tr>
<td>Description</td>
<td>LINQ implementation for node</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.4</td>
</tr>
</table>

Got an idea for something cool? Open an issue!

This library has not been tested or optimized for performance.

## Usage

These functions can be chained for synchronous and asynchronous queries

```coffee-script
.Where(fn)
.Distinct()
.Except(arr)
.OfType(type)
.Map(fn)
.Cast(type)
.Select(fn)
.SelectMany(fn) 
.Reverse()
.OrderBy(fn)
.OrderByDescending(fn)
.GroupBy(fn)

.Concat(arr)
.Intersect(arr, [fn])
```

These functions return a value (for use at the end of a chain)

```coffee-script
.Contains(val)
.ContainsAll(arr)
.Any(fn)
.All(fn)
.Max()
.Min()
.Sum([fn])
.Average([fn])

.ElementAt(idx)
.ElementAtOrDefault(idx, default)
.First([fn])
.FirstOrDefault(default, [fn])
.Last([fn])
.LastOrDefault(default, [fn])
.Single([fn])
.SingleOrDefault(d, [fn])
.DefaultIfEmpty(d)

.Count()
```
## Examples

These suck. If you have more practical examples pull requests are appreciated.

### Sorting .txt files alphabetically by name
Synchronous (LINQ)

####Javascript:
```javascript
var LINQ = require('node-linq').LINQ;
var path = require('path');
var files = ['test.txt', 'choni.txt', 'legacy.zip', 'secrets.txt', 'etc.rar'];
var arr = new LINQ(files)
  .Where(function(file) { return path.extname(file) === 'txt'; })
  .OrderBy(function(file) { return file;})
  .ToArray();

//arr is now [ 'choni.txt',  'secrets.txt', 'text.txt' ]
```

####CoffeeScript:
```coffee-script
{LINQ} = require 'node-linq'
{extname} = require 'path'

files = ['test.txt', 'choni.txt', 'legacy.zip', 'secrets.txt', 'etc.rar']

arr = new LINQ(files)
.Where((file) -> extname(file) is 'txt')
.OrderBy((file) -> file)
.ToArray()

# arr ==  [ 'choni.txt',  'secrets.txt', 'text.txt' ]
```

Asynchronous (ALINQ)
####CoffeeScript:
```coffee-script
{ALINQ} = require 'node-linq'
fs = require 'fs'
{extname} = require 'path'

files = ['test.txt', 'choni.txt', 'legacy.zip', 'secrets.txt', 'etc.rar']

q = new ALINQ files

q.Where (file, cb) -> 
  cb extname(file) is 'txt'

q.OrderBy (file, cb) -> 
  fs.lstat file, (err, stat) ->
    cb stat.mtime

q.Execute (arr) ->
  # arr == [ choni.txt',  'text.txt', 'secrets.txt']
```

### Sorting users by registration date and then only returning the name
Synchronous (LINQ)

####Javascript:
```javascript
var LINQ = require("node-linq").LINQ;

var users = [
	{name: 'Bob', joined: new Date('12/27/1993')},
	{name: 'Tom', joined: new Date('12/25/1993')},
	{name: 'Bill', joined: new Date('11/10/1992')},
];

var arr = new LINQ(users)
	.OrderBy(function(user) {return user.joined;})
	.Select(function(user) {return user.name;})
	.ToArray();
  
//arr is now [ 'Bill','Tom','Bob' ]
```
####CoffeeScript:
```coffee-script
{LINQ} = require 'node-linq'

users = [
  {name: 'Bob', joined: new Date('12/27/1993')},
  {name: 'Tom', joined: new Date('12/25/1993')},
  {name: 'Bill', joined: new Date('11/10/1992')},
]
arr = new LINQ(users)
.OrderBy((user) -> user.joined)
.Select((user) -> user.name)
.ToArray()

# arr == ['Bill', 'Tom', 'Bob']
```

Asynchronous (ALINQ)

####CoffeeScript:
```coffee-script
{ALINQ} = require 'node-linq'

users = [
  {name: 'Bob', joined: new Date('12/27/1993')},
  {name: 'Tom', joined: new Date('12/25/1993')},
  {name: 'Bill', joined: new Date('11/10/1992')},
]
q = new ALINQ users
q.OrderBy (user, cb) ->  cb user.joined
q.Select (user, cb) -> cb user.name

q.Execute (arr) ->
  # arr == ['Bill', 'Tom', 'Bob']
```

## LICENSE

(MIT License)

Copyright (c) 2012 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
