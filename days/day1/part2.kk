import part1
import std/text/regex

fun fix-digits(s : string) : string
  var digits-spelled-out : list<string> :=
    ["zero", "one", "two","three","four","five","six","seven","eight","nine"]
  var digits-regex := 
    regex("zero|one|two|three|four|five|six|seven|eight|nine")
  var digit-pairs : list<(string,string)> :=
    digits-spelled-out.map( fn(x) -> 
       "DIGIT:" ++ x
      ).zip(
        list(0,9).map(show)
      )
  s.replace-all(digits-regex, "DIGIT:$&")
  digit-pairs.foldl(
    s,
    fn (cur-str,(str,v)) -> cur-str.replace-all(str,v)
  )

fun day1-part2(lines : list<string>)
  var preprocess := lines.map(fix-digits)
  day1-part1(preprocess)
