{ALINQ} = require '../'
should = require 'should'
require 'mocha'

describe 'indexes', ->
  describe 'Count()', ->
    it 'should return 5', (done) ->
      l = new ALINQ [1, 2, 3, 4, 5]
      l.Count().Execute (val) ->
        val.should.equal 5
        done()
    it 'should return 0', (done) ->
      l = new ALINQ []
      l.Count().Execute (val) ->
        val.should.equal 0
        done()

  describe 'ElementAt()', ->
    it 'should return 3', (done) ->
      l = new ALINQ [1, 2, 3, 4]
      l.ElementAt(2).Execute (val) ->
        val.should.equal 3
        done()

  describe 'ElementAtOrDefault()', ->
    it 'should return 3', (done) ->
      l = new ALINQ [1, 2, 3, 4]
      l.ElementAtOrDefault(2).Execute (val) ->
        val.should.equal 3
        done()
    it 'should return 7', (done) ->
      l = new ALINQ [1, 2, 3, 4]
      l.ElementAtOrDefault(9001, 7).Execute (val) ->
        val.should.equal 7
        done()

  describe 'Single()', ->
    it 'should return 3', (done) ->
      l = new ALINQ [3]
      l.Single().Execute (val) ->
        val.should.equal 3
        done()

  describe 'SingleOrDefault()', ->
    it 'should return 3', (done) ->
      l = new ALINQ [3]
      l.SingleOrDefault(7).Execute (val) ->
        val.should.equal 3
        done()
    it 'should return 7', (done) ->
      l = new ALINQ []
      l.SingleOrDefault(7).Execute (val) ->
        val.should.equal 7
        done()

  describe 'First()', ->
    it 'should return 3', (done) ->
      l = new ALINQ [3, 4, 5]
      l.First().Execute (val) ->
        val.should.equal 3
        done()

  describe 'FirstOrDefault()', ->
    it 'should return 3', (done) ->
      l = new ALINQ [3, 4, 5]
      l.FirstOrDefault(7).Execute (val) ->
        val.should.equal 3
        done()
    it 'should return 7', (done) ->
      l = new ALINQ []
      l.FirstOrDefault(7).Execute (val) ->
        val.should.equal 7
        done()

  describe 'Last()', ->
    it 'should return 3', (done) ->
      l = new ALINQ [3, 4, 5]
      l.Last().Execute (val) ->
        val.should.equal 5
        done()

  describe 'LastOrDefault()', ->
    it 'should return 3', (done) ->
      l = new ALINQ [3, 4, 5]
      l.LastOrDefault(7).Execute (val) ->
        val.should.equal 5
        done()
    it 'should return 7', (done) ->
      l = new ALINQ []
      l.LastOrDefault(7).Execute (val) ->
        val.should.equal 7
        done()

  describe 'DefaultIfEmpty()', ->
    it 'should return 3', (done) ->
      l = new ALINQ [3, 4, 5]
      l.DefaultIfEmpty(7).Execute (val) ->
        val.should.eql [3, 4, 5]
        done()
    it 'should return 7', (done) ->
      l = new ALINQ []
      l.DefaultIfEmpty(7).Execute (val) ->
        val.should.equal 7
        done()

describe 'selects', ->
  describe 'Where()', ->
    it 'should return [3, 4, 5]', (done) ->
      l = new ALINQ [1, 2, 3, 4, 5]
      l.Where((num, cb) -> cb num > 2).Execute (val) ->
        val.should.eql [3, 4, 5]
        done()

  describe 'Distinct()', ->
    it 'should return [1, 2, 3, 4, 5]', (done) ->
      l = new ALINQ [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
      l.Distinct().Execute (val) ->
        val.should.eql [1, 2, 3, 4, 5]
        done()

  describe 'Except()', ->
    it 'should return [6]', (done) ->
      except = [1, 2, 3, 4, 5]
      l = new ALINQ [1, 2, 3, 4, 5, 6]
      l.Except(except).Execute (val) ->
        val.should.eql [6]
        done()

    it 'should return [6] with selector', (done) ->
      except = [1, 2, 3, 4, 5]
      l = new ALINQ [1, 2, 3, 4, 5, 6]
      sel = (i) -> i
      l.Except(except, sel).Execute (val) ->
        val.should.eql [6]
        done()

  describe 'OfType()', ->
    it 'should return [6]', (done) ->
      l = new ALINQ ['str', {}, null, 6]
      l.OfType('number').Execute (val) ->
        val.should.eql [6]
        done()

    it 'should return ["str"]', (done) ->
      l = new ALINQ ['str', {}, null, 6]
      l.OfType('string').Execute (val) ->
        val.should.eql ['str']
        done()

  describe 'Cast()', ->
    it 'should return [6, 6]', (done) ->
      l = new ALINQ ['6', 6]
      l.Cast(parseInt).Execute (val) ->
        val.should.eql [6, 6]
        done()
    it 'should return ["6", "6"]', (done) ->
      l = new ALINQ ['6', 6]
      l.Cast(String).Execute (val) ->
        val.should.eql ['6', '6']
        done()

  describe 'Select()', ->
    it 'should return ["Max", "Todd"]', (done) ->
      l = new ALINQ [{first: "Max", last: "Su"}, {first: "Todd", last: "Su"}]
      expected = ["Max", "Todd"]
      l.Select((item, cb) -> cb item.first).Execute (val) ->
        val.should.eql expected
        done()

  describe 'SelectMany()', ->
    it 'should return ["Max", "Todd"]', (done) ->
      l = new ALINQ [{first: "Max", last: "Su"}, {first: "Todd", last: "Su"}]
      expected = ["Max", "Su", "Todd", "Su"]
      l.SelectMany((item, cb) -> cb [item.first, item.last]).Execute (val) ->
        val.should.eql expected
        done()

describe 'computation', ->
  describe 'Max()', ->
    it 'should return 5', (done) ->
      l = new ALINQ [1, 2, 3, 4, 5]
      l.Max().Execute (val) ->
        val.should.equal 5
        done()
  describe 'Min()', ->
    it 'should return 1', (done) ->
      l = new ALINQ [1, 2, 3, 4, 5]
      l.Min().Execute (val) ->
        val.should.equal 1
        done()
  describe 'Sum()', ->
    it 'should return 6', (done) ->
      l = new ALINQ [1, 2, 3]
      l.Sum().Execute (val) ->
        val.should.equal 6
        done()
  describe 'Average()', ->
    it 'should return 2', (done) ->
      l = new ALINQ [1, 2, 3]
      l.Average().Execute (val) ->
        val.should.equal 2
        done()

describe 'ordering', ->
  describe 'Reverse()', ->
    it 'should return [3, 2, 1]', (done) ->
      l = new ALINQ [1, 2, 3]
      expected = [3, 2, 1]
      l.Reverse().Execute (val) ->
        val.should.eql expected
        done()
  describe 'OrderBy()', ->
    it 'should return ["Amanda", "Todd"]', (done) ->
      l = new ALINQ [{name: "Todd"}, {name: "Amanda"}]
      expected = [{name: "Amanda"}, {name: "Todd"}]
      l.OrderBy((item, cb) -> cb item.name).Execute (val) ->
        val.should.eql expected
        done()
  describe 'OrderByDescending()', ->
    it 'should return ["Todd", "Amanda"]', (done) ->
      l = new ALINQ [{name: "Amanda"}, {name: "Todd"}]
      expected = [{name: "Todd"}, {name: "Amanda"}]
      l.OrderByDescending((item, cb) -> cb item.name).Execute (val) ->
        val.should.eql expected
        done()

describe 'conditions', ->
  describe 'Contains()', ->
    it 'should return true', (done) ->
      l = new ALINQ [1, 2, 3]
      l.Contains(1).Execute (val) ->
        val.should.equal true
        done()

  describe 'Contains()', ->
    it 'should return false', (done) ->
      l = new ALINQ [1, 2, 3]
      l.Contains(4).Execute (val) ->
        val.should.equal false
        done()
  describe 'Any()', ->
    it 'should return true', (done) ->
      l = new ALINQ [1, 2, 3]
      l.Any((item, cb) -> cb item is 1).Execute (val) ->
        val.should.equal true
        done()
  describe 'Any()', ->
    it 'should return false', (done) ->
      l = new ALINQ [1, 2, 3]
      l.Any((item, cb) -> cb item is 4).Execute (val) ->
        val.should.equal false
        done()
  describe 'All()', ->
    it 'should return true', (done) ->
      l = new ALINQ [1, 2, 3]
      l.All((item, cb) -> cb item > 0).Execute (val) ->
        val.should.equal true
        done()
  describe 'All()', ->
    it 'should return false', (done) ->
      l = new ALINQ [1, 2, 3]
      l.All((item, cb) -> cb item > 10).Execute (val) ->
        val.should.equal false
        done()

describe 'modifications', ->
  describe 'Concat()', ->
    it 'should return true', (done) ->
      l = new ALINQ [1, 2, 3]
      l2 = new ALINQ [1, 2, 3]
      expected = [1, 2, 3, 1, 2, 3]
      l.Concat(l2).Execute (val) ->
        val.should.eql expected
        done()
  describe 'Intersect()', ->
    it 'should return true', (done) ->
      l = new ALINQ [1, 2, 3, 4]
      l2 = new ALINQ [1, 2, 3, 5]
      expected = [1, 2, 3]
      l.Intersect(l2).Execute (val) ->
        val.should.eql expected
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

      arr = new ALINQ(dogs)
      .Concat(puppies)
      .Where((dog, cb) -> cb dog.type is 'Labrador')
      .OrderBy((dog, cb) -> cb dog.age)
      .Select((dog, cb) -> cb dog.name)
      .Execute (arr) ->
        arr.should.eql [ 'Lil Chili', 'Max', 'Lil Billy' ]
        done()