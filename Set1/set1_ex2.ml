type tree = Empty | Node of int * tree * tree

let read_tree filename =
  let ic = open_in filename in
  let _ = input_line ic in  
  let line = input_line ic in
  let tokens = line |> String.split_on_char ' ' |> List.map int_of_string in
  let rec build_tree tokens = match tokens with
    | 0 :: rest -> (Empty, rest)
    | x :: rest ->
        let (left_tree, rest_after_left) = build_tree rest in
        let (right_tree, rest_after_right) = build_tree rest_after_left in
        (Node (x, left_tree, right_tree), rest_after_right)
    | [] -> failwith "Unexpected end of input"
  in
  let (tree, _) = build_tree tokens in
  close_in ic;
  tree

let rec compare_lists a b = match (a, b) with
  | [], [] -> 0
  | _, [] -> 1
  | [], _ -> -1
  | ha::ta, hb::tb ->
    let c = compare ha hb in
    if c = 0 then compare_lists ta tb else c

let rec minimal_inorder tree =
  match tree with
  | Empty -> []
  | Node (v, left, right) ->
      let left_inorder = minimal_inorder left in
      let right_inorder = minimal_inorder right in
      let normal_order = left_inorder @ [v] @ right_inorder in
      let swapped_order = right_inorder @ [v] @ left_inorder in
      if compare_lists swapped_order normal_order < 0 then
        swapped_order
      else
        normal_order

let arrange filename =
  let tree = read_tree filename in
  let result = minimal_inorder tree in
  List.iter (fun x -> print_int x; print_string " ") result;
  print_newline ()

let () =
  if Array.length Sys.argv > 1 then
    arrange Sys.argv.(1)
  else
    print_endline "Usage: arrange <filename>"