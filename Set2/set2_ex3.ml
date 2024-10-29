(* Utility function to check if a number can be represented as repeated symbols in a given base *)
let rec is_repeated_symbol n b =
  let rec helper n b digit =
    if n = 0 then true
    else if n mod b <> digit then false
    else helper (n / b) b digit
  in
  helper n b (n mod b)

(* Function to find the minimum base for a number *)
let find_min_base n =
  let rec find_base b =
    if is_repeated_symbol n b then b
    else find_base (b + 1)
  in
  find_base 2

(* Function to read numbers from a file *)
let read_numbers_from_file filename =
  let in_channel = open_in filename in
  let count = int_of_string (input_line in_channel) in
  let rec read_lines n acc =
    if n = 0 then List.rev acc
    else read_lines (n - 1) ((int_of_string (input_line in_channel)) :: acc)
  in
  let numbers = read_lines count [] in
  close_in in_channel;
  numbers

(* Main function *)
let () =
  if Array.length Sys.argv <> 2 then
    Printf.eprintf "Usage: %s <input_file>\n" Sys.argv.(0)
  else
    let input_file = Sys.argv.(1) in
    let numbers = read_numbers_from_file input_file in
    let bases = List.map find_min_base numbers in
    List.iter (fun base -> Printf.printf "%d\n" base) bases