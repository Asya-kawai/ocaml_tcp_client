(* #require "unix" *)

(* How to build:
   ocamlfind ocamlopt -package unix -linkpkg -thread client.ml -o client
*)

let open_connection sockaddr =
  let domain = Unix.domain_of_sockaddr sockaddr in
  let sock = Unix.socket domain Unix.SOCK_STREAM 0 in
  try
    (* --- *)
    Unix.setsockopt_float sock Unix.SO_RCVTIMEO 1.0 ;
    Unix.setsockopt_float sock Unix.SO_SNDTIMEO 1.0 ;
    (* --- *)
    Unix.connect sock sockaddr ;
    (Unix.in_channel_of_descr sock, Unix.out_channel_of_descr sock)
  with
  | e -> Unix.close sock ; raise e

let close_connection in_chan =
  Unix.shutdown (Unix.descr_of_in_channel in_chan) Unix.SHUTDOWN_SEND

let main_client client_fun =
  let command = Sys.argv.(0) in
  if Array.length Sys.argv < 3 then
    Printf.eprintf "usge: %s server port\n" command
  else
    let server = Sys.argv.(1) in
    let server_addr =
      try
        Unix.inet_addr_of_string server
      with
      | Failure e ->
         match e with
         | "inet_addr_of_string" ->
            begin
              try
                let host_entry = Unix.gethostbyname server in
                host_entry.Unix.h_addr_list.(0)
              with
              | Not_found ->
                 Printf.eprintf "%s: Unknown server %s\n" command server ;
                 exit 2
              | _ ->
                 Printf.eprintf "%s: Unknown error occurred when parse host_entry \n" command ;
                 exit 255
            end
         | _ ->
            Printf.eprintf "%s: Unknown error %s\n" command e ;
            exit 255
    in
    try
      let port = int_of_string (Sys.argv.(2)) in
      let sockaddr = Unix.ADDR_INET(server_addr, port) in
      let in_chan, out_chan = open_connection sockaddr in
      client_fun in_chan out_chan ;
      close_connection in_chan
    with
    | Failure e ->
       match e with
       | "int_of_string" ->
          Printf.eprintf "%s: Bad port number %s\n" command Sys.argv.(2) ;
          exit 2
       | _ ->
          Printf.eprintf "%s: Unknown error %s\n" command e


let retry_max = 3
let retry_interval = 1.0
exception Retry
exception ServerError
let rec send_message out_chan msg retry_count =  
  if retry_count > retry_max then raise Retry
  else
    try
      Unix.sleep retry_count ;
      output_string out_chan msg ;
      flush out_chan ;
      (* --- *)
      (* Simulates the response from the server to fail. *)
      raise ServerError;
      (* --- *)
    with
    | e ->
       match e with
       | ServerError ->
          Printf.eprintf "Timeout(count %d) ...\n" retry_count ;
          flush stderr ;
          send_message out_chan msg (retry_count + 1)
       | _ -> raise e
    
let rec show_response_client in_chan out_chan =
      try
        while true do
          print_string "Request: " ;
          flush stdout ;
          let msg = (input_line stdin) ^ "\n" in
          send_message out_chan msg 0 ;
          let r = input_line in_chan in
          Printf.printf "Response: %s\n\n" r ;
          if r = "END" then
            begin
              close_connection in_chan ;
              raise Exit
            end
        done
      with
      | Exit -> exit 0
      | e ->
         close_connection in_chan ;
         match e with
         | Retry ->
            raise e
         | Sys_blocked_io -> Printf.eprintf "Timeout...\n" ; raise e
         | _ -> close_connection in_chan ; raise e

let () =
  main_client show_response_client
