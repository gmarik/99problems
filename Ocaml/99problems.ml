(*
 *
 * P01 [+] Find the last box of a list.
 * Example:
 * (my-last '(a b c d))
 * (D)
 *)

let rec last l = match l with
  | []    -> None
  | [a]   -> Some a
  | _::b  -> last b
;;

assert (last [`a; `b; `c; `d] = Some `d) ;;
assert (last [] = None) ;;

(* 
 * or using exceptions: which isn't a good idea here 
 *)
let rec last_ex l = match l with
  | []    -> raise (Failure "empty list")
  | [a]   -> a
  | _::b  -> last_ex b
;;

assert (last_ex [`a; `b; `c; `d] = `d) ;;

try
  assert (last_ex [] == [`never_happens])
with
| Failure "empty list" -> assert true
;;



(*
 *
 * P02 [+] Find the last but one box of a list.
 * Example:
 * (my-but-last '(a b c d))
 * (C)
 *)

let rec last_but_one l = match l with
| [] | [_] -> None
| [x;_]    -> Some x
| _::t     -> last_but_one t
;;

assert (last_but_one [1;2;3;4] = Some 3);;
assert (last_but_one [1;2] = Some 1);;
assert (last_but_one [1] = None);;
assert (last_but_one [] = None);;






 (* 
 * P03: Find the K'th element of a list.
 *
 * Example:
 *      kth  [1; 2; 3; 4] 3
 *      4
 *)

let rec kth l i = match l with
| []   -> None
| a::b -> if 1 = i then Some a  else kth b (i-1);;

assert ((kth [1; 2] 2) = Some 2);;
assert ((kth [1; 2] 3) = None);;





(* P04 Find the number of elements of a list.
 *)
let rec len l = match l with
| []    -> 0
| _::t  -> 1 + (len t)
;;

assert (len []        = 0);;
assert (len [`a]      = 1);;
assert (len [1;2;3]   = 3);;






(*
 * P05 Reverse a list.
 *)

let rec reverse l = match l with
| []  -> []
| h::t  -> (reverse t) @ [h]
;;

assert (reverse [1; 2; 3] = [3; 2; 1]);;
assert (reverse [] = []);;

(* above example isn't tail recusive optimized *)
(* optimized version: *)

let reverse l =
  let rec aux acc l = match l with
    | []    -> acc
    | h::t  -> aux (h::acc) t
  in aux [] l
;;

assert (reverse [1; 2; 3] = [3; 2; 1]);;
assert (reverse [] = []);;






(*
 * P06 Find out whether a list is a palindrome.
 * A palindrome can be read forward or backward; e.g. (x a m a x).
 *)

let is_palindrome = function s ->
  s = (reverse s)
;;

assert (is_palindrome ["l"; "o"; "l"]);;
assert (not (is_palindrome ["l"; "o"; "l"; "o"]));;






(* P07 Flatten a nested list structure.
 * Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).
 * 
 * Example:
 * flatten (a (b (c d) e))
 * (a b c d e)
 * 
 * Hint: Use the predefined functions list and append.
 *)

type 'a node = One of 'a | Many of 'a node list;;

(* unoptimized version *)
let rec _flatten l = match l with
| []        -> []
| One x::t  -> x :: _flatten t
| Many x::t -> (_flatten x) @ (_flatten t)
;;

(* tail recursive opmtimized *)
let rec flatten l = 
  let rec aux acc l = match l with
  | []        -> acc
  | One x::t  -> [ x ] @ aux acc t
  | Many x::t -> aux [] x @ aux acc t
in
  aux [] l
;;

let e07 = [One `a; Many [One `b; Many [One `c; One `d]; One `e]];;
let r07 = [`a; `b; `c; `d; `e];;

assert (_flatten e07 = r07);;
assert ( flatten e07 = r07);;




(* P08 [**] Eliminate consecutive duplicates of list elements.
 * If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.
 * 
 * Example:
 * (compress '(a a a a b c c a a d e e e e))
 * (a b c a d e)
 *)


let rec _compress l = match l with
| a::b::t    -> (if a = b then [] else [a]) @ _compress (b::t)
(* | z -> z *)
| [a] -> [a]
| [] -> []
;;

let e08 = [`a; `a; `a; `a; `b; `c; `c; `a; `a; `d; `e; `e; `e; `e];;
let r08 = [`a; `b; `c; `a; `d; `e];;

assert (_compress e08 = r08);;





(*
 * P09 [**] Pack consecutive duplicates of list elements into sublists.
 * If a list contains repeated elements they should be placed in separate sublists.
 * 
 * Example:
 * (pack '(a a a a b c c a a d e e e e))
 * ((a a a a) (b) (c c) (a a) (d) (e e e e))
 *)

let _pack = function l ->
  let rec aux acc l = match l with
  | a::b::t    -> (if a = b then (aux (a::acc) (b::t)) else (a::acc)::(aux [] (b::t))) 
  | [a] -> [a::acc]
  | [] -> []
in 
  aux [] l
;;

let pack = function l ->
  let rec aux q acc l = match l with
  | a::b::t    -> (if a = b then (aux (a::q) acc (b::t)) else (aux [] (acc @ [a::q] ) (b::t))) 
  | [a] -> acc @ [a::q]
  | [] -> []
in 
  aux [] [] l
;;

let e09 = [`a; `a; `a; `a; `b; `c; `c; `a; `a; `d; `e; `e; `e; `e];;
let r09= [[`a; `a; `a; `a]; [`b]; [`c; `c]; [`a; `a]; [`d]; [`e; `e; `e; `e]];;

assert (_pack e09 = r09);;
assert (pack e09 = r09);;






(*
 * P10  Run-length encoding of a list.
 * Use the result of problem P09 to implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as lists (N E) where N is the number of duplicates of the element E.
 * 
 * Example:
 * (encode '(a a a a b c c a a d e e e e))
 * ((4 a) (1 b) (2 c) (2 a) (1 d)(4 e))
 *)

let encode = function l ->
  let rec count cnt l = match l with
    | h::t  -> count (cnt + 1) t
    | [] -> cnt
  in
  let rec aux acc l = match l with
  | (a::_ as h)::t    -> aux (acc @ [((count 0 h), a)]) t
  | []::t    -> aux (acc) t
  | []    -> acc
in 
  aux [] (pack l)
;;

let e10 = [`a; `a; `a; `a; `b; `c; `c; `a; `a; `d; `e; `e; `e; `e];;
let r10 = [(4, `a); (1, `b); (2, `c); (2, `a); (1, `d); (4, `e)];;

assert (encode e10 = r10);;






(*
 * P11 Modified run-length encoding.
 * Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.
 * 
 * Example:
 * * (encode-modified '(a a a a b c c a a d e e e e))
 * ((4 A) B (2 C) (2 A) D (4 E))
 *)
type 'a entry = Single of 'a | Pair of (int * 'a);;

let encode_mod = function l ->
  let mk_entry q a = if q = 1 then Single a else Pair(q,a)
  in
  let rec aux acc l = match l with
  | (c,a)::t    -> (aux (acc @ [mk_entry c a]) t) 
  | [] -> acc
in 
  aux [] (encode l)
;;

let e11 = [`a; `a; `a; `a; `b; `c; `c; `a; `a; `d; `e; `e; `e; `e];;
let r11 = [Pair (4, `a); Single `b; Pair (2, `c); Pair (2, `a); Single `d; Pair (4, `e)];;

assert (encode_mod e11 = r11);;





(*
 * P12 Decode a run-length encoded list.
 * Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.
 *)

let decode l = 
  let rec mul acc n c = match n with
    | 0 -> acc
    | n -> mul (c::acc) (n - 1) c
  in
  let rec aux acc l = match l with
  | Pair(i, a)::t -> aux (acc @ (mul [] i a)) t
  | Single(a) ::t  -> aux (acc @ [a]) t
  | []            -> acc
in
  aux [] l
;;

let e12 = [`a; `a; `a; `a; `b; `c; `c; `a; `a; `d; `e; `e; `e; `e];;

assert (decode (encode_mod e12) = e12);;





(*
 * P13 [**] Run-length encoding of a list (direct solution).
 * Implement the so-called run-length encoding data compression method directly.
 * I.e. don't explicitly create the sublists containing the duplicates, as in
 * problem P09, but only count them.  As in problem P11, simplify the result list by replacing the singleton lists (1 X) by X.
 * 
 * Example:
 * * (encode-direct '(a a a a b c c a a d e e e e))
 * ((4 A) B (2 C) (2 A) D (4 E))
 *)

type 'a entry = Single of 'a | Pair of (int * 'a);;

let encode_direct = function l ->
  let mk_entry q a = if q = 1 then Single a else Pair(q,a)
  in
  let rec aux q acc l = match l with
  | a::b::t    -> (if a = b then (aux (q+1) acc (b::t)) else (aux 0 (acc @ [(mk_entry (q+1) a)]) (b::t))) 
  | [a] -> acc @ [(mk_entry (q+1) a)]
  | [] -> []
in 
  aux 0 [] l
;;

let e13 = [`a; `a; `a; `a; `b; `c; `c; `a; `a; `d; `e; `e; `e; `e];;
let r13 = [Pair (4, `a); Single `b; Pair (2, `c); Pair (2, `a); Single `d; Pair (4, `e)];;

assert (encode_direct e13 = r13);;







 (* P14 [**] Duplicate the elements of a list.
 * Example:
 * * (dupli '(a b c c d))
 * (A A B B C C C C D D)
 *)

let dupli = function l ->
  let rec aux acc t = match t with
  | h::t  -> aux (acc @ [h; h]) t
  | []    -> acc
  in
  aux [] l
;;

let e14 = [`a; `b; `c; `c; `d];;
let r14 = [`a; `a; `b; `b; `c; `c; `c; `c; `d; `d];;

assert (dupli e14 = r14);;






 (*
 * P15 [**] Replicate the elements of a list a given number of times.
 * Example:
 * * (repli '(a b c) 3)
 * (A A A B B B C C C)
 *)

let repli list n = 
  let rec mul acc n c = match n with
    | 0 -> acc
    | n -> mul (c::acc) (n - 1) c
  in
  let rec aux acc list n = match list with
  | h::t  -> aux (acc @ (mul [] n h)) t n
  | []    -> acc
  in
  aux [] list n
;;

let e15 = [`a; `b; `c];;
let r15 = [`a; `a; `b; `b; `c; `c];;

assert (repli e15 2 = r15);;






(* P16 [**] Drop every N'th element from a list.
* Example:
* * (drop '(a b c d e f g h i k) 3)
* (A B D E G H K)
*)

let drop list n = 
  let rec aux acc c list = match list with
  | []  -> acc
  | h::t  -> if c == n then aux acc 1 t else aux (acc @ [h]) (c + 1) t
  in
  aux [] 1 list
;;
assert ((drop [1; 2; 3; 4; 5] 2) = [1; 3; 5]);;






 (* P17 [**] Split a list into two parts; the length of the first part is given.
 * Do not use any predefined predicates.
 * 
 * Example:
 * * (split '(a b c d e f g h i k) 3)
 * ( (A B C) (D E F G H I K))
 *)
let split l n = 
  let rec aux acc n l = match l with
  | h::t    -> if n > 0 then aux (acc @ [h]) (n-1) t else [acc; l]
  | []      -> [acc]
  in
  aux [] n l
;;
let e17 = [1;2;3;4];;
let r17 = [[1; 2; 3]; [4]];;
assert ((split e17 3 ) = r17);;






 (* P18 [**] Extract a slice from a list.
 * Given two indices, I and K, the slice is the list containing the elements
 * between the I'th and K'th element of the original list (both limits
 * included). Start counting the elements with 1.
 * 
 * Example:
 * * (slice '(a b c d e f g h i k) 3 7)
 * (C D E F G)
 *)

let slice list n k =
  let rec aux acc count l = match l with
  |h::t     -> if count >= n && count <= k then aux (acc @ [h]) (count + 1) t else aux acc (count + 1) t
  | []      -> acc
in
  aux [] 1 list
;;

let e18 = [`a; `b; `c; `d; `e; `f; `g; `h; `i; `k];;
let r18 = [`c; `d; `e; `f; `g];;

assert ((slice e18 3 7) = r18);;






 (* P19 [**] Rotate a list N places to the left.
 * Examples:
 * * (rotate '(a b c d e f g h) 3)
 * (D E F G H A B C)
 * * (rotate '(a b c d e f g h) -2)
 * (G H A B C D E F)
 * 
 * Hint: Use the predefined functions length and append, as well as the result of problem P17.
 *)

let rotate l c = 
  let count = 
    if c >= 0 
    then c 
    else (List.length l) + c
  in
  let [a;b] = (split l count)
in b @ a
;;

(* TODO: how do I fix warning?
 *
 *  File "99problems.ml", line 475, characters 6-11:
 *  Warning 8: this pattern-matching is not exhaustive.
 *  Here is an example of a value that is not matched:
 *  []
 *
 *)

let e19 = [`a; `b; `c; `d; `e; `f; `g; `h];;
let r19 = [`d; `e; `f; `g; `h; `a; `b; `c];;

assert ((rotate e19 0) = e19);;
assert ((rotate e19 3) = r19);;
assert ((rotate e19 (-5)) = r19);;






 (* P20 [*] Remove the K'th element from a list.
 * Example:
 * * (remove-at '(a b c d) 2)
 * (A C D)
 *)

let remove_at l i = 
  let rec aux acc l i = match l with
    | []   -> (None, acc)
    | h::t -> 
        if 1 == i 
        then (Some h, (acc @ t))
        else aux (acc @ [h]) t (i - 1)
  in
    let idx = 
      if i < 0 
      then (List.length l) + i + 1
      else i
  in
    aux [] l idx
;;

let e20 = [`a; `b; `c; `d];;
let r20 = [`a; `b; `d];;

assert ((remove_at e20 1000) = (None, e20));;
assert ((remove_at e20 3)    = (Some `c, r20));;
assert ((remove_at e20 (-2)) = (Some `c, r20));;






 (*
 * P21 [*] Insert an element at a given position into a list.
 * Example:
 * * (insert-at 'alfa '(a b c d) 2)
 * (A ALFA B C D)
 *)
 (* TODO: REFACTOR *)
let insert_at el list at = 
  let idx = 
    if at < 0 
    then (List.length list) + at + 1
    else at - 1
  in
  let rec aux acc el list at = match list with
  |[] -> 
      if (List.length acc) = idx
      then (acc @ [el])
      else acc
  |h::(_ as t) -> 
      if (List.length acc) = idx
      then (acc @ [el] @ h::t) 
      else aux (acc @ [h]) el t at
  in
  aux [] el list at
;;

let e21 = [`a; `b; `c; `d];;
let r21 = [`a; `alfa; `b; `c; `d];;

assert ((insert_at `alfa e21 2) = r21);;
assert ((insert_at `alfa e21 (-4)) = r21);;


(*
 * P22 [*] Create a list containing all integers within a given range.
 * If first argument is smaller than second, produce a list in decreasing order.
 * Example:
 * * (range 4 9)
 * (4 5 6 7 8 9)
 *)

let range a b = 
  let (inc, r) = 
    if a > b 
    then (-1, a - b)
    else (1, b - a)
  in
  let rec aux acc count a = match count with
    | 0 -> acc
    | _   -> aux (acc @ [a + inc]) (count - 1) (a+inc)
  in
  aux [a] r a
;;

let r22 = [4; 5; 6; 7; 8; 9];;

assert ((range 4 9 = r22));;


(*
 * P23 [**] Extract a given number of randomly selected elements from a list.
 * The selected items shall be returned in a list.
 * Example:
 * * (rnd-select '(a b c d e f g h) 3)
 * (E D A)
 * 
 * Hint: Use the built-in random number generator and the result of problem P20.
 *)

(* random generator  *)
(* let random n = (1 + Random.int n);; *)
(* pseudo random generator. For testing  *)
let random n = n / 2 + 1;;

let rnd_select list count = 
  let rec aux acc list count = 
    let len = List.length list 
    in
    if count = 0 then acc
    else 
      match (remove_at list (random len)) with
      | None    ,rest    -> raise (Failure "Opps failed to pick an element")
      | Some el ,rest    -> aux (el::acc) rest (count - 1)
  in
  aux [] list count 
;;
let e23 = [`a; `b; `c; `d; `e; `f; `g; `h];;
let r23 = [`b; `a];;

assert ((rnd_select e23 2) = [`d; `e]);;


 (* P24 [*] Lotto: Draw N different random numbers from the set 1..M.
 * The selected numbers shall be returned in a list.
 * Example:
 * * (lotto-select 6 49)
 * (23 1 17 33 21 37)
 * 
 * Hint: Combine the solutions of problems P22 and P23.
 *)

let lotto_select count max =
  rnd_select (range 1 max) count;;

(* results are predictable since rnd_select uses pseudo randome generator  *)
assert ((lotto_select 6 49) = [28; 23; 27; 24; 26; 25]);;

 (*
 * P25 [*] Generate a random permutation of the elements of a list.
 * Example:
 * * (rnd-permu '(a b c d e f))
 * (B A D C E F)
 * 
 * Hint: Use the solution of problem P23.
 *)

let rnd_permu list = 
  let rec aux acc list = 
    let len = List.length list in
    match remove_at list (random len) with
    | None    ,[] -> acc
    | None    ,rest  -> raise (Failure "oops")
    | Some el ,rest  -> aux (el::acc) rest
  in

  aux [] list
  (* we could use rnd_select here too  *)
;;
let e25 = [`a;`b;`c;`d;`e;`f];;
let r25 = [`a;`f;`b;`e;`c;`d];;

assert ((rnd_permu e25) = r25);;






(* P26 [**] Generate the combinations of K distinct objects chosen from the N elements of a list
 * In how many ways can a committee of 3 be chosen from a group of 12 people? We all know that there are C(12,3) = 220 possibilities (C(N,K) denotes the well-known binomial coefficients). For pure mathematicians, this result may be great. But we want to really generate all the possibilities in a list.
 * 
 * Example:
 * * (combination 3 '(a b c d e f))
 * ((A B C) (A B D) (A B E) ... )
 * P27 [**] Group the elements of a set into disjoint subsets.
 * a) In how many ways can a group of 9 people work in 3 disjoint subgroups of 2, 3 and 4 persons? Write a function that generates all the possibilities and returns them in a list.
 * 
 * Example:
 * * (group3 '(aldo beat carla david evi flip gary hugo ida))
 * ( ( (ALDO BEAT) (CARLA DAVID EVI) (FLIP GARY HUGO IDA) )
 * ... )
 * 
 * b) Generalize the above predicate in a way that we can specify a list of group sizes and the predicate will return a list of groups.
 * 
 * Example:
 * * (group '(aldo beat carla david evi flip gary hugo ida) '(2 2 5))
 * ( ( (ALDO BEAT) (CARLA DAVID) (EVI FLIP GARY HUGO IDA) )
 * ... )
 * 
 * Note that we do not want permutations of the group members; i.e. ((ALDO BEAT) ...) is the same solution as ((BEAT ALDO) ...). However, we make a difference between ((ALDO BEAT) (CARLA DAVID) ...) and ((CARLA DAVID) (ALDO BEAT) ...).
 * 
 * You may find more about this combinatorial problem in a good book on discrete mathematics under the term "multinomial coefficients".
 * P28 [**] Sorting a list of lists according to length of sublists
 * a) We suppose that a list contains elements that are lists themselves. The objective is to sort the elements of this list according to their length. E.g. short lists first, longer lists later, or vice versa.
 * 
 * Example:
 * * (lsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))
 * ((O) (D E) (D E) (M N) (A B C) (F G H) (I J K L))
 * 
 * b) Again, we suppose that a list contains elements that are lists themselves. But this time the objective is to sort the elements of this list according to their length frequency; i.e., in the default, where sorting is done ascendingly, lists with rare lengths are placed first, others with a more frequent length come later.
 * 
 * Example:
 * * (lfsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))
 * ((i j k l) (o) (a b c) (f g h) (d e) (d e) (m n))
 * 
 * Note that in the above example, the first two lists in the result have length 4 and 1, both lengths appear just once. The third and forth list have length 3 which appears twice (there are two list of this length). And finally, the last three lists have length 2. This is the most frequent length.
 * Arithmetic

 *
 *
 *
 * *)


