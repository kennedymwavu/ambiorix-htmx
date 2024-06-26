# File Upload

This example shows how you can parse, save & render file uploads.

For simplicity, it sticks to csv files. 

Also, the uploaded files are written to the working directory. Ideally, you 
should write to a database and perform any operations from there (searching, 
filtering, column selection etc.)

# Exhibits

- Before upload

![Before upload](./demos/file-upload-before.png)

- After upload

![After upload](./demos/file-upload-after.png)

# Installation

1. Clone this repo and `cd` into the `todolist/` directory.
    ```bash
    git clone git@github.com:kennedymwavu/ambiorix-htmx.git
    cd ambiorix-htmx/file-upload/
    ```
1. Add an env file (`.Renviron`) at the root dir of the project with the following content.
    ```r
    HOST = 127.0.0.1
    PORT = 8000
    RENV_CONFIG_SANDBOX_ENABLED = FALSE
    ```
    You can change the values of the variables to suit your environment.
1. Install the dependencies.
    ```r
    renv::restore()
    ```

# Start app

`index.R` is the entry point of the app. Run the following command to start the app.
```bash
Rscript index.R
```
