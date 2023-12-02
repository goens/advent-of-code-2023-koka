fun get-digits(s : string) : total list<int>
  var digits := list(s).filter(is-digit)
  digits.map(
    fn(x) -> string(x).parse-int()
    ).concat-maybe()

fun first-last-digit(s : string) : int
  var digits := get-digits(s)
  var first := match digits.head()
    Just(x) -> x
    Nothing -> 0
  var last := match digits.reverse().head()
    Just(x) -> x
    Nothing -> 0
  first * 10 + last

fun add-first-last-digits(lines : list<string>) : total int
  var values := lines.map(first-last-digit)
  values.sum()

fun day1-part1(lines : list<string>)
  var res := add-first-last-digits(lines)
  println("res: " ++ show(res))
