import std/os/file
import std/os/path
import days/day1/part1
//import days/day1/part2
import days/day2/part1

fun main()
  var input-file-string := read-text-file(cwd()/"days"/"day1"/"input1.txt")
  var lines := split(input-file-string, "\n")
  day1-part1(lines)
  //day1-part2(lines)

  var input-file-string := read-text-file(cwd()/"days"/"day2"/"input1.txt")
  var lines := split(input-file-string, "\n")
  day2-part1(lines)
  day2-part2(lines)
