# ocaml_tcp_client

Sample programs for TCP clients written by OCaml.

## tcp_client_with_retry.

TCP client has ability of re-send data to the server.

### How to build the client.

When using dune:

```
cd tcp_client_with_retry/
dune build bin/main.exe
```
Or in manually:

```
cd tcp_client_with_retry/bin/
ocamlfind ocamlopt -package unix -linkpkg -thread main.ml -o client
```

### How to build the server.

Prepare the server.

When using dune:

```
cd tcp_server/
dune build bin/main.exe
```

Or in manually:

```
cd tcp_server/bin/
ocamlfind ocamlopt -package unix -linkpkg -thread main.ml -o server
```

### How to run the server.

When using dune for build:

```
cd tcp_server
dune exec bin/main.exe 8080
```

or when manually biuld:

```
cd tcp_server/bin/
./server localhost 8080
```

### How to run the client.

```
cd tcp-client-with-retry/
./client 'server-name' 'port'
```

Example:

```
./client localhost 8080
```

