{LINQ} = require '../'
should = require 'should'
require 'mocha'

describe 'indexes', ->
  describe 'Count()', ->
    it 'should return 5', (done) ->
      l = new LINQ [1, 2, 3, 4, 5]
      l.Count().should.equal 5
      done()
    it 'should return 0', (done) ->
      l = new LINQ []
      l.Count().should.equal 0
      done()

  describe 'ElementAt()', ->
    it 'should return 3', (done) ->
      l = new LINQ [1, 2, 3, 4]
      l.ElementAt(2).should.equal 3
      done()

  describe 'ElementAtOrDefault()', ->
    it 'should return 3', (done) ->
      l = new LINQ [1, 2, 3, 4]
      l.ElementAtOrDefault(2).should.equal 3
      done()
    it 'should return 7', (done) ->
      l = new LINQ [1, 2, 3, 4]
      l.ElementAtOrDefault(9001, 7).should.equal 7
      done()

  describe 'Single()', ->
    it 'should return 3', (done) ->
      l = new LINQ [3]
      l.Single().should.equal 3
      done()

  describe 'SingleOrDefault()', ->
    it 'should return 3', (done) ->
      l = new LINQ [3]
      l.SingleOrDefault().should.equal 3
      done()
    it 'should return 7', (done) ->
      l = new LINQ []
      l.SingleOrDefault(7).should.equal 7
      done()

  describe 'First()', ->
    it 'should return 3', (done) ->
      l = new LINQ [3, 4, 5]
      l.First().should.equal 3
      done()

  describe 'FirstOrDefault()', ->
    it 'should return 3', (done) ->
      l = new LINQ [3, 4, 5]
      l.FirstOrDefault().should.equal 3
      done()
    it 'should return 7', (done) ->
      l = new LINQ []
      l.FirstOrDefault(7).should.equal 7
      done()

  describe 'Last()', ->
    it 'should return 3', (done) ->
      l = new LINQ [3, 4, 5]
      l.Last().should.equal 5
      done()

  describe 'LastOrDefault()', ->
    it 'should return 3', (done) ->
      l = new LINQ [3, 4, 5]
      l.LastOrDefault().should.equal 5
      done()
    it 'should return 7', (done) ->
      l = new LINQ []
      l.LastOrDefault(7).should.equal 7
      done()

  describe 'DefaultIfEmpty()', ->
    it 'should return 3', (done) ->
      l = new LINQ [3, 4, 5]
      l.DefaultIfEmpty().should.equal l
      done()
    it 'should return 7', (done) ->
      l = new LINQ []
      l.DefaultIfEmpty(7).should.equal 7
      done()

describe 'selects', ->
  describe 'Where()', ->
    it 'should return [3, 4, 5]', (done) ->
      l = new LINQ [1, 2, 3, 4, 5]
      expected = new LINQ [3, 4, 5]
      l.Where((num) -> num > 2).should.eql expected
      done()

  describe 'Distinct()', ->
    it 'should return [1, 2, 3, 4, 5]', (done) ->
      l = new LINQ [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
      expected = new LINQ [1, 2, 3, 4, 5]
      l.Distinct().should.eql expected
      done()

  describe 'Except()', ->
    it 'should return [6]', (done) ->
      except = [1, 2, 3, 4, 5]
      l = new LINQ [1, 2, 3, 4, 5, 6]
      expected = new LINQ [6]
      l.Except(except).should.eql expected
      done()

    it 'should return [6] with selector', (done) ->
      except = [1, 2, 3, 4, 5]
      l = new LINQ [1, 2, 3, 4, 5, 6]
      expected = new LINQ [6]
      sel = (i) -> i
      l.Except(except, sel).should.eql expected
      done()

  describe 'OfType()', ->
    it 'should return [6]', (done) ->
      l = new LINQ ['str', {}, null, 6]
      expected = new LINQ [6]
      l.OfType('number').should.eql expected
      done()
    it 'should return ["str"]', (done) ->
      l = new LINQ ['str', {}, null, 6]
      expected = new LINQ ['str']
      l.OfType('string').should.eql expected
      done()

  describe 'Cast()', ->
    it 'should return [6, 6]', (done) ->
      l = new LINQ ['6', 6]
      expected = new LINQ [6, 6]
      l.Cast(parseInt).should.eql expected
      done()
    it 'should return ["6", "6"]', (done) ->
      l = new LINQ ['6', 6]
      expected = new LINQ ['6', '6']
      l.Cast(String).should.eql expected
      done()

  describe 'Select()', ->
    it 'should return ["Max", "Todd"]', (done) ->
      l = new LINQ [{first: "Max", last: "Su"}, {first: "Todd", last: "Su"}]
      expected = new LINQ ["Max", "Todd"]
      l.Select((item) -> item.first).should.eql expected
      done()

  describe 'SelectMany()', ->
    it 'should return ["Max", "Todd"]', (done) ->
      l = new LINQ [{first: "Max", last: "Su"}, {first: "Todd", last: "Su"}]
      expected = new LINQ ["Max", "Su", "Todd", "Su"]
      l.SelectMany((item) -> [item.first, item.last]).should.eql expected
      done()

describe 'computation', ->
  describe 'Max()', ->
    it 'should return 5', (done) ->
      l = new LINQ [1, 2, 3, 4, 5]
      l.Max().should.equal 5
      done()
  describe 'Min()', ->
    it 'should return 1', (done) ->
      l = new LINQ [1, 2, 3, 4, 5]
      l.Min().should.equal 1
      done()
  describe 'Sum()', ->
    it 'should return 6', (done) ->
      l = new LINQ [1, 2, 3]
      l.Sum().should.equal 6
      done()
  describe 'Average()', ->
    it 'should return 2', (done) ->
      l = new LINQ [1, 2, 3]
      l.Average().should.equal 2
      done()

describe 'ordering', ->
  describe 'Reverse()', ->
    it 'should return [3, 2, 1]', (done) ->
      l = new LINQ [1, 2, 3]
      expected = new LINQ [3, 2, 1]
      l.Reverse().should.eql expected
      done()
  describe 'OrderBy()', ->
    it 'should return ["Amanda", "Todd"]', (done) ->
      l = new LINQ [{name: "Todd"}, {name: "Amanda"}]
      expected = new LINQ [{name: "Amanda"}, {name: "Todd"}]
      l.OrderBy((item) -> item.name).should.eql expected
      done()
  describe 'OrderByDescending()', ->
    it 'should return ["Todd", "Amanda"]', (done) ->
      l = new LINQ [{name: "Amanda"}, {name: "Todd"}]
      expected = new LINQ [{name: "Todd"}, {name: "Amanda"}]
      l.OrderByDescending((item) -> item.name).should.eql expected
      done()
  describe 'GroupBy()', ->
    it 'should return ["Amanda", "Todd"]', (done) ->
      l = new LINQ [{name: "Todd"}, {name: "Amanda"}, {name: "Alan"}]
      expected = 
        T: [ name: 'Todd' ]
        A: [
          {name: 'Amanda'}
          {name: 'Alan'}
        ]
      l.GroupBy((item) -> item.name[0]).should.eql expected
      done()

describe 'conditions', ->
  describe 'Contains()', ->
    it 'should return true', (done) ->
      l = new LINQ [1, 2, 3]
      l.Contains(1).should.equal true
      done()
  describe 'Contains()', ->
    it 'should return false', (done) ->
      l = new LINQ [1, 2, 3]
      l.Contains(4).should.equal false
      done()
  describe 'ContainsAll()', ->
    it 'should return true', (done) ->
      l = new LINQ [1, 2, 3]
      l.ContainsAll([1, 2, 3]).should.equal true
      done()
  describe 'ContainsAll()', ->
    it 'should return false', (done) ->
      l = new LINQ [1, 2, 3]
      l.ContainsAll([1, 2, 3, 4]).should.equal false
      done()
  describe 'Any()', ->
    it 'should return true', (done) ->
      l = new LINQ [1, 2, 3]
      l.Any((item) -> item is 1).should.equal true
      done()
  describe 'Any()', ->
    it 'should return false', (done) ->
      l = new LINQ [1, 2, 3]
      l.Any((item) -> item is 4).should.equal false
      done()
  describe 'All()', ->
    it 'should return true', (done) ->
      l = new LINQ [1, 2, 3]
      l.All((item) -> item > 0).should.equal true
      done()
  describe 'All()', ->
    it 'should return false', (done) ->
      l = new LINQ [1, 2, 3]
      l.All((item) -> item > 10).should.equal false
      done()

describe 'modifications', ->
  describe 'Concat()', ->
    it 'should return true', (done) ->
      l = new LINQ [1, 2, 3]
      l2 = new LINQ [1, 2, 3]
      expected = new LINQ [1, 2, 3, 1, 2, 3]
      l.Concat(l2).should.eql expected
      done()
  describe 'Intersect()', ->
    it 'should return true', (done) ->
      l = new LINQ [1, 2, 3, 4]
      l2 = new LINQ [1, 2, 3, 5]
      expected = new LINQ [1, 2, 3]
      l.Intersect(l2).should.eql expected
      done()

describe 'chaining', ->
  describe 'dogs and puppies', ->
    it 'should return correct', (done) ->
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
      arr.should.eql [ 'Lil Chili', 'Max', 'Lil Billy' ]
      done()

