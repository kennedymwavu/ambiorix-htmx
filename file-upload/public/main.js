// Update the progress bar when uploading a file
function update_upload_progress(progress_id) {
  htmx.on("#form", "htmx:xhr:progress", function (evt) {
    const loaded = evt.detail.loaded;
    const total = evt.detail.total;
    const pct = total > 0 ? (loaded / total) * 100 : 100;
    const progress_container = "#" + progress_id;
    const progress_bar = progress_container + ">.progress-bar";
    htmx.find(progress_container).setAttribute("aria-valuenow", pct);
    htmx.find(progress_bar).style.width = pct + "%";
    htmx.find(progress_bar).textContent = pct.toFixed(0) + "%";
  });
}
