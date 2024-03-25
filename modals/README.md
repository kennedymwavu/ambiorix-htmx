# Modals (ambiorix + htmx)

A sample project that shows how to support modal forms with ambiorix + htmx.

Persistent storage has been implemented using MongoDB.

## Prerequisites

- An installation of the community edition of [MongoDB](https://www.mongodb.com/docs/manual/administration/install-community/)

## Installation

1. Clone this repo and `cd` into the `modals/` directory:
    ```r
    git clone git@github.com:kennedymwavu/ambiorix-htmx.git
    cd ambiorix-htmx/modals
    ```
1. Install R package dependencies:
    ```r
    Rscript install_deps.R
    ```
1. Add an env file (`.Renviron`) at the root dir of the project with these variables:
    ```r
    MONGO_DB = ambiorix-htmx
    MODALS_COLLECTION = modals
    HOST = 127.0.0.1
    PORT = 8000
    ```
    You can change the default values if you wish.

## Start app

`index.R` is the entry point.

```r
Rscript index.R
```
