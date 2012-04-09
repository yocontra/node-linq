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

## Usage

These functions can be chained.

```coffee-script
.Where(fn)
.Distinct()
.Except(arr, [fn])
.OfType(type)
.Cast(type)
.Select(fn)
.SelectMany(fn) 
.Reverse()
.OrderBy(fn)
.OrderByDescending(fn)

.Concat(arr)
.Intersect(arr, [fn])
```

These functions return a value

```coffee-script
.Contains(val)
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
.ToArray()
```
## Example

```coffee-script
LINQ = require 'node-linq'
dogs = [
  {name: 'Toby', age: 2, type: 'Yorkie'},
  {name: 'Max', age: 3, type: 'Labrador'},
  {name: 'Lil Billy', age: 4, type: 'Labrador'},
  {name: 'Choni', age: 5, type: 'Poodle'}
]
puppies = [
  {name: 'T-Bone', age: 1, type: 'Yorkie'},
  {name: 'Lil Chili', age: 1, type: 'Labrador'}
]

arr = new LINQ(dogs)
.Concat(puppies)
.Where((dog) -> dog.type is 'Labrador')
.OrderBy((dog) -> dog.age)
.Select((dog) -> dog.name)
.ToArray()

# arr == [ 'Lil Chili', 'Max', 'Lil Billy' ]
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
