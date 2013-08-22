util = require './util'
# TODO: http://msdn.microsoft.com/en-us/library/bb341635.aspx
# TODO: allow strings instead of fns (use f lib parser)
# TODO: stop returning new classes on each load (wtf why is this happening)
  
defSel = (item) -> return item

class LINQ
  constructor: (@items) ->
    throw 'ArgumentNullException' unless @items?
    throw 'InvalidCastException: Data not Array' unless Array.isArray @items

  ToArray: -> @items
  GetTemporary: -> (item for item in @items)

  # Indexes
  Count: (fn) -> (if fn then @Where(fn) else @).items.length

  ElementAt: (idx) -> @items[idx]
  ElementAtOrDefault: (idx, d) -> @ElementAt(idx) or d

  Single: (fn) ->
    return @Where(fn).Single() if fn
    throw 'More than one element' if @Count() > 1
    return @ElementAt 0
  SingleOrDefault: (d, fn) -> @Single(fn) or d

  First: (fn) ->
    return @Where(fn).First() if fn
    return @ElementAt 0
  FirstOrDefault: (d, fn) -> @First(fn) or d

  Last: (fn) ->
    return @Where(fn).Last() if fn
    return @ElementAt @items.length-1
  LastOrDefault: (d, fn) -> @Last(fn) or d

  DefaultIfEmpty: (d) -> (if @items.length is 0 then d else @)

  # Selects
  Where: (fn) -> new LINQ (item for item, idx in @items when fn(item) is true)
  Distinct: -> new LINQ (item for item in @items when !(item in _results))
  Except: (arr, fn=defSel) -> @Where (item) -> !(fn(item) in arr)
  OfType: (type) -> @Where (item) -> typeof item is type
  Cast: (type) -> new LINQ ((if util.isFunction(type) then type(item) else new type(item)) for item in @items)
  Map: (fn) -> new LINQ (fn(item) for item in @items)
  Select: (fn) -> new LINQ (fn(item) for item in @items)
  SelectMany: (fn) ->
    temp = []
    # TODO: Throw err if res of fn isnt arr?
    temp = temp.concat fn(item) for item in @items
    new LINQ temp

  # Computation
  Max: -> Math.max @items...
  Min: -> Math.min @items...
  Average: (fn) -> @Sum(fn)/@Count()
  Sum: (fn) ->
    sum = 0
    sum += (if fn then fn item else item) for item in @items
    return sum

  # Ordering
  Reverse: -> new LINQ @GetTemporary().reverse()
  OrderBy: (fn) ->
    new LINQ @GetTemporary().sort (a, b) ->
      x = fn a
      y = fn b
      return -1 if x < y
      return 1 if x > y
      return 0

  OrderByDescending: (fn) ->
    new LINQ @GetTemporary().sort (a, b) ->
      x = fn b
      y = fn a
      return -1 if x < y
      return 1 if x > y
      return 0

  GroupBy: (fn) ->
    out = {}
    @items.forEach (val, idx) -> (out[fn(val, idx)]?=[]).push val
    return out

  # Conditions
  Contains: (val) -> val in @items
  ContainsAll: (arr) -> new LINQ(arr).All (item) => item in @items

  Any: (fn) ->
    return true for item, idx in @items when fn(item) is true
    return false
  All: (fn) ->
    return false for item, idx in @items when fn(item) is false
    return true

  # Modifications
  Concat: (arr) -> new LINQ @items.concat arr.items or arr
  Intersect: (arr, fn) ->
    fn ?= (item, idx, item2, idx2) -> item is item2
    arr = arr.items or arr
    out = []
    for item, idx in @items
      for item2, idx2 in arr
        out.push item if fn(item, idx, item2, idx2) is true
    new LINQ out

module.exports = LINQ
