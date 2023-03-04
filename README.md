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

### How to run the client.

When using dune:

```
cd tcp-client-with-retry/
dune exec bin/main.exe localhost 8080
```

Or built in manually:

```
cd tcp-client-with-retry/bin
./client localhost 8080
```

## tcp_server

TCP server has ability to convert accepted words to uppercase and send back.

## How to build the server.

Prepare the server.

When using dune:

```
cd tcp_server/
dune build bin/main.exe
```

Or when built manually:

```
cd tcp_server/bin/
ocamlfind ocamlopt -package unix -linkpkg -thread main.ml -o server
```

## How to run the server.

When using dune for build:

```
cd tcp_server
dune exec bin/main.exe 8080
```

or when built manually:

```
cd tcp_server/bin/
./server localhost 8080
```



