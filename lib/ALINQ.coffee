util = require './util'
async = require 'async'

# TODO: Break out every fn so they can be reused within others - DRY
# Example: Using Map within SelectMany without inducing queue side-effects
# Sum() within Average() etc.
# TODO: GroupBy, ContainsAll

defSel = (item) -> return item

class ALINQ
  constructor: (@items) ->
    throw 'ArgumentNullException' unless @items?
    throw 'InvalidCastException: Data not Array' unless Array.isArray @items
    @queue = []

  addTo: (fn) -> 
    @queue.push fn
    return @

  Execute: (cb) ->
    fn = (memo, item, cb) ->
      item memo, (val) -> cb null, val
    async.reduce @queue, @items, fn, (err, res) -> cb res

  # Indexes
  Count: (fn) ->
    return @Where(fn).Count() if fn
    @addTo (items, cb) ->
      cb items.length

  ElementAt: (idx) -> 
    @addTo (items, cb) ->
      cb items[idx]
  ElementAtOrDefault: (idx, d) -> 
    @addTo (items, cb) -> 
      cb items[idx] or d

  Single: (fn) -> @First fn
  SingleOrDefault: (d, fn) -> @FirstOrDefault d, fn

  First: (fn) ->
    return @Where(fn).First() if fn
    return @ElementAt 0
  FirstOrDefault: (d, fn) ->
    @addTo (items, cb) -> 
      cb items[0] or d

  Last: (fn) ->
    return @Where(fn).Last() if fn
    @addTo (items, cb) ->
      cb items[items.length-1]
  LastOrDefault: (d, fn) ->
    @addTo (items, cb) ->
      cb items[items.length-1] or d

  DefaultIfEmpty: (d) -> 
    @addTo (items, cb) ->
      cb if items.length is 0 then d else items

  # Selects
  Where: (fn) -> 
    @addTo (items, cb) ->
      async.filter items, fn, cb

  Distinct: ->
    temp = []
    @Where (item, cb) -> 
      if item in temp
        cb false
      else
        temp.push item
        cb true

  Except: (arr, fn=defSel) -> @Where (item, cb) -> cb !(fn(item) in arr)
  OfType: (type) -> @Where (item, cb) -> cb typeof item is type
  Map: (fn) ->
    @addTo (items, cb) ->
      wrap = (item, cb) ->
        fn item, (res) -> cb null, res
      async.map items, wrap, (err, res) -> cb res

  Cast: (type) ->
    @Map (item, cb) -> 
      cb (if util.isFunction(type) then type(item) else new type(item))

  Select: (fn) -> @Map fn
  SelectMany: (fn) ->
    @addTo (items, cb) ->
      wrap = (item, cb) ->
        fn item, (res) -> cb null, res
      async.concat items, wrap, (err, res) -> cb res

  # Computation
  Max: -> @addTo (items, cb) -> cb Math.max items...
  Min: -> @addTo (items, cb) -> cb Math.min items...
  Average: (fn) -> 
    @addTo (items, cb) ->
      fn ?= (num, cb) -> cb num
      sum = 0
      wrap = (item, cb) ->
        fn item, (res) -> cb null, sum += res
      async.map items, wrap, -> cb sum/items.length

  Sum: (fn) ->
    @addTo (items, cb) ->
      fn ?= (num, cb) -> cb num
      sum = 0
      wrap = (item, cb) ->
        fn item, (res) -> cb null, sum += res
      async.map items, wrap, -> cb sum

  # Ordering
  Reverse: -> 
    @addTo (items, cb) -> 
      cb items.reverse()
  OrderBy: (fn) ->
    @addTo (items, cb) -> 
      wrap = (item, cb) ->
        fn item, (res) -> cb null, res
      async.sortBy items, wrap, (err, res) -> cb res

  OrderByDescending: (fn) ->
    @addTo (items, cb) -> 
      wrap = (item, cb) ->
        fn item, (res) -> cb null, res
      async.sortBy items, wrap, (err, res) -> cb res.reverse()

  # Conditions
  Contains: (val, fn) -> @addTo (items, cb) -> cb val in items
  Any: (fn) ->
    @addTo (items, cb) ->
      async.some items, fn, cb
  All: (fn) ->
    @addTo (items, cb) ->
      async.every items, fn, cb

  # Modifications
  Concat: (arr) ->
    @addTo (items, cb) ->
      cb items.concat arr.items or arr
  Intersect: (arr, fn) ->
    @addTo (items, cb) ->
      fn ?= (item, item2) -> item is item2
      arr = arr.items or arr
      out = []
      check = (item, cb) ->
        check2 = (item2, cb) ->
          out.push item if fn(item, item2) is true
          cb()
        async.map arr, check2, cb
      async.map items, check, -> cb out

module.exports = ALINQ