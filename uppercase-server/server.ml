(* #require "unix" *)

(* How to build:
   ocamlfind ocamlopt -package unix -linkpkg -thread server.ml -o server
*)

(*
  Reference: https://caml.inria.fr/pub/docs/oreilly-book/html/book-ora187.html
 *)

let establish_server server_fun sockaddr =
  let domain = Unix.domain_of_sockaddr sockaddr in
  let sock = Unix.socket domain Unix.SOCK_STREAM 0 in
  begin
    Unix.bind sock sockaddr ;
    Unix.listen sock 3 ;
    while true do
      let (s, caller) = Unix.accept sock in
      match Unix.fork() with
      | 0 -> begin
          if Unix.fork() <> 0 then exit 0;
          let in_chan = Unix.in_channel_of_descr s and
              out_chan = Unix.out_channel_of_descr s in
          server_fun in_chan out_chan ;
          close_in in_chan ;
          close_out out_chan ;
          exit 0
        end
      | id -> begin
          Unix.close s ;
          ignore(Unix.waitpid [] id)
        end
    done
  end

let main_server server_fun =
  let command = Sys.argv.(0) in
  if Array.length Sys.argv < 2 then
    Printf.eprintf "usage: %s port\n" command
  else try
      let port = int_of_string Sys.argv.(1) in
      let my_address =
        let host_entry = Unix.gethostbyname (Unix.gethostname()) in
        host_entry.Unix.h_addr_list.(0) in
      establish_server server_fun (Unix.ADDR_INET(my_address, port))
    with
    | Failure e -> 
       match e with
       | "int_of_string" ->
          Printf.eprintf "%s: Bad port number %s\n" command Sys.argv.(1)
       | _ ->
          Printf.eprintf "%s: Unknown error %s\n" command e

let uppercase_server in_chan out_chan =
   try
     while true do
       let s = input_line in_chan in
       let r = String.uppercase_ascii s in
       output_string out_chan (r^"\n") ;
       flush out_chan
     done
   with _ ->
     Printf.printf "End of text\n" ;
     flush stdout ;
     exit 0

let () =
  Unix.handle_unix_error main_server  uppercase_server
