# ocaml_tcp_client

Sample program for TCP clients written by OCaml.

## tcp-client-with-retry

TCP client has ability of re-send data to the server.

### How to build

```
cd tcp-client-with-retry/
ocamlfind ocamlopt -package unix -linkpkg -thread client.ml -o client
```

### How to run

Prepare the server.
```
cd uppercase-server/
ocamlfind ocamlopt -package unix -linkpkg -thread server.ml -o server
```

Run the server.
```
./server 'server-name' 'port'
```

Example:
```
./server localhost 8080
```

Run the client.
```
cd tcp-client-with-retry/
./client 'server-name' 'port'
```

Example:

```
./client localhost 8080
```

## tcp-client-with-timeout

TCP client has ability of timeout when sending data to the server.

### How to build

```
cd tcp-client-with-timeout
ocamlfind ocamlopt -package unix -linkpkg -thread client.ml -o client
```

### How to run

Prepare the server.
```
cd uppercase-server/
ocamlfind ocamlopt -package unix -linkpkg -thread server.ml -o server
```

Run the server.
```
./server 'server-name' 'port'
```

Example:
```
./server localhost 8080
```

Run the client.
```
cd tcp-client-with-timeout
./client 'server-name' 'port'
```

Example:

```
./client localhost 8080
```

