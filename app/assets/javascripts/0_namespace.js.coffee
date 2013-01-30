namespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top
namespace '', (exports, root) -> root.namespace = namespace

window.stringToFunction = (str) ->
  arr = str.split(".")
  fn = (window or this)
  i = 0
  len = arr.length

  while i < len
    fn = fn[arr[i]]
    i++
  fn
