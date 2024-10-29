let read_ints filename =
  let ins = open_in filename in
  try
    let _ = input_line ins in  
    let line = input_line ins in  
    let numbers = List.map int_of_string (String.split_on_char ' ' line) in
    numbers
  with End_of_file -> 
    close_in ins;
    []  

let fairseq filename =
  let numbers = read_ints filename in
  let total_sum = List.fold_left (+) 0 numbers in
  let target = total_sum / 2 in
  let dp = Array.make (target + 1) false in
  dp.(0) <- true;

  List.iter (fun x ->
    for i = target downto x do
      if dp.(i - x) then dp.(i) <- true
    done
  ) numbers;

  let closest_sum =
    let rec find_closest i =
      if i < 0 then 0
      else if dp.(i) then i
      else find_closest (i - 1)
    in
    find_closest target
  in

  let difference = abs (total_sum - 2 * closest_sum) in
  Printf.printf "%d\n" difference

let () =
  if Array.length Sys.argv > 1 then
    fairseq Sys.argv.(1)        