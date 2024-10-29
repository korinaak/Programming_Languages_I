type point = {
  x : int;
  y : int;
  cars : int;
  parent : point option;
  direction : string;
}

let directions = [|
  (0, 1, "E"); (1, 0, "S"); (0, -1, "W"); (-1, 0, "N");
  (-1, 1, "NE"); (1, 1, "SE"); (-1, -1, "NW"); (1, -1, "SW")
|]

let read_grid filename =
  let file = open_in filename in
  let n = int_of_string (input_line file) in
  let grid = Array.make_matrix n n 0 in
  for i = 0 to n - 1 do
    let line = input_line file in
    let values = List.map int_of_string (String.split_on_char ' ' line) in
    List.iteri (fun j v -> grid.(i).(j) <- v) values
  done;
  close_in file;
  (n, grid)

let construct_path end_point =
  let rec aux point acc =
    match point.parent with
    | None -> acc
    | Some parent -> aux parent (point.direction :: acc)
  in
  let path = aux end_point [] in
  "[" ^ (String.concat "," path) ^ "]"

module PriorityQueue = struct
  type t = point list ref
  
  let create () = ref []
  
  let add pq point =
    let rec insert sorted point = match sorted with
      | [] -> [point]
      | hd :: tl ->
          if point.cars < hd.cars then
            point :: sorted
          else
            hd :: (insert tl point)
    in
    pq := insert !pq point
  
  let pop pq =
    match !pq with
    | [] -> raise Not_found
    | hd :: tl ->
        pq := tl;
        hd
  
  let is_empty pq =
    !pq = []
end

let find_shortest_path grid n =
  let visited = Array.make_matrix n n false in
  let queue = PriorityQueue.create () in
  PriorityQueue.add queue { x = 0; y = 0; cars = grid.(0).(0); parent = None; direction = "" };

  let rec bfs () =
    if PriorityQueue.is_empty queue then
      "IMPOSSIBLE"
    else
      let current = PriorityQueue.pop queue in
      let cx, cy = current.x, current.y in
      if visited.(cx).(cy) then
        bfs ()
      else begin
        visited.(cx).(cy) <- true;
        if cx = n - 1 && cy = n - 1 then
          construct_path current
        else begin
          for i = 0 to Array.length directions - 1 do
            let (dx, dy, dir) = directions.(i) in
            let nx, ny = cx + dx, cy + dy in
            if nx >= 0 && nx < n && ny >= 0 && ny < n && not visited.(nx).(ny) && grid.(nx).(ny) < current.cars then
              PriorityQueue.add queue { x = nx; y = ny; cars = grid.(nx).(ny); parent = Some current; direction = dir }
          done;
          bfs ()
        end
      end
  in
  bfs ()

let () =
  if Array.length Sys.argv <> 2 then
    Printf.eprintf "Usage: %s <input_file>\n" Sys.argv.(0)
  else
    let (n, grid) = read_grid Sys.argv.(1) in
    let result = find_shortest_path grid n in
    print_endline result