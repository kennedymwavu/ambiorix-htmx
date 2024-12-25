# show progress when using async

- [`{future}`](https://future.futureverse.org/)
- sqlite (temp db)
- htmx polling

## demo

<video controls width="100%" height="360">
  <source src="./show-progress-async.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## installation

1. clone this repo and `cd` into the `show-progress-async/` directory.

    ```bash
    git clone git@github.com:kennedymwavu/ambiorix-htmx.git
    cd ambiorix-htmx/show-progress-async/
    ```

1. fire up R and install the dependencies.

    ```r
    renv::restore()
    ```

## start app

`index.R` is the entry point of the app. run the following command to start the app.

```bash
Rscript index.R
```
