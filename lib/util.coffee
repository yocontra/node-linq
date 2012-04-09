module.exports =
  isFunction: (o) -> toString.call(o) is "[object Function]"
