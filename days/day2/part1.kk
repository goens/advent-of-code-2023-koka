type color
  Red
  Green
  Blue

value struct game
  identifier : int
  sets : list<list<(color,int)>>

fun parse-value(value : string) : maybe<(color,int)>
  match value.split(" ")
    [v,color] -> 
      var c := match color
        "red" -> Just(Red)
        "green" -> Just(Green)
        "blue" -> Just(Blue)
        _ -> Nothing
      var n := parse-int(v)
      match (c,n)
        (Just(c), Just(n)) -> Just((c,n))
        _ -> Nothing
    _ -> Nothing

fun parse-set(set : string) : list<(color,int)>
  var set-strings : list<string> := set.split(", ")
  set-strings.map(parse-value).concat-maybe()
  
// Here I kind of want do-notation
fun parse-game(game : string) : maybe<game>
  var game-strings : list<string> := game.split(": ")
  match game-strings
    [game-id-string,sets] ->
      var game-id-string-split := game-id-string.split(" ")
      match game-id-string-split
        ["Game", id-string] ->
          match parse-int(id-string)
            Just(id) -> Just(Game(id,sets.split("; ").map(parse-set)))
            Nothing -> Nothing
        _ -> Nothing
    _ -> Nothing
  

fun draw-possible(given-set : list<(color,int)>, (c,n) : (color,int)) : bool
  var maybe-n := given-set.find(
      fn ((c',_)) -> c == c' 
      )
  match maybe-n
    Just((_,n')) -> n' >= n
    Nothing -> False // if not in given set, then you can't draw them either

fun set-possible(given-set : list<(color,int)>, drawn-set : list<(color,int)>) : bool
  drawn-set.all(fn (x) -> draw-possible(given-set,x))
  
fun game-possible(given-set : list<(color,int)>, g : game) : bool
  g.sets.all( fn (x) -> set-possible(given-set,x))
    
fun day2-part1( input : list<string>)
  var games : list<game> := input.map(parse-game).concat-maybe()
  var given-set := [(Red,12),(Green,13),(Blue,14)]
  //println("gll games: " ++ show(games))
  var possible-games : list<game> := games.filter(fn(x) -> game-possible(given-set,x))
  //println("possible games: " ++ show(possible-games))
  var identifiers : list<int> := possible-games.map(identifier)
  println("Sum identifiers: " ++ show(sum(identifiers)))

// fun minimum-set(set : list<(color,int)>) : list<(color,int)>
//   [Red,Green,Blue].map(
//     fn(c) -> match set.filter(
//       fn((c',_)) -> c == c')
//         [(_,i)] -> (c,i)
//         [] -> (c,0)
//         _ -> (c,-1) // this should ideally throw an error
//   )

fun min-game(g : game) : list<(color,int)>
  //var minima : list<(color,int)> := g.sets.map(minimum-set).flatten()
  var draws : list<(color,int)> := g.sets.concat()
  [Red,Green,Blue].map(
    fn (c) -> 
    /*
     term         :       var m := draws.filter(
                    ...
                          (c,m)
     inferred type: () -> <local<$h>|_e> (color, int)
     hint         : give a higher-rank type annotation to a function parameter?
    */
    /*
      var m : int := draws.filter(
        fn((c',_)) -> c == c').map(
          fn((_,i)) -> i).minimum()
      (c,m)
      */
     // This is much less readable IMO:
      (c, draws.filter(
        fn((c',_)) -> c == c').map(
          fn((_,i)) -> i).maximum(default=1))
  )

fun power-game(g : game) : int
   min-game(g).map(
    fn((_,i)) -> i
   ).foldl(1,(*))

fun day2-part2( input : list<string>)
  var games : list<game> := input.map(parse-game).concat-maybe()
  var powers : list<int> := games.map(power-game)
  println("powers: " ++ show(powers))
  println("power sum of games:" ++ show(sum(powers)))

// Here: missing derivation/polymorphic versions of these
fun show(c : color) : string 
  match c
    Red -> "red"
    Green -> "green"
    Blue -> "blue"

fun show((c,i) : (color,int)) : string
  "(" ++ show(c) ++ ", " ++ show(i) ++ ")"

fun show(xs : list<(color,int)>) : string
  show-list(xs,show)

fun show(maybe-val : maybe<(color,int)>) : string
  match maybe-val
    Just(v) -> "Just(" ++ show(v) ++ ")"
    Nothing -> "Nothing"

fun show(xs : list<list<(color,int)>>) : string
  show-list(xs,show)

fun show(g : game) : string
  "Game " ++ show(g.identifier) ++ ": " ++ show(g.sets)

fun show(maybe-g : maybe<game>) : string
  match maybe-g
    Just(g) -> "Just(" ++ show(g) ++ ")"
    Nothing -> "Nothing"

fun (==)(c1 : color, c2 : color) : bool
  match (c1, c2)
    (Red, Red) -> True
    (Green, Green) -> True
    (Blue, Blue) -> True
    _ -> False
    
fun show(mb : maybe<bool>) : string
  match mb
    Just(b) -> "Just(" ++ show(b) ++ ")"
    Nothing -> "Nothing"
  
fun show(games : list<game>) : string
  show-list(games,show)
