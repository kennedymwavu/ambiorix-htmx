// add loading spinner immediately button is clicked,
// for better UI/UX
function add_loading_spinner(btn_id, loading_label = "Just a sec...") {
  const btn = document.getElementById(btn_id);

  btn.innerHTML = `
    <span class="spinner-border spinner-border-sm" aria-hidden="true"></span>
    <span role="status">${loading_label}</span>
  `;
}
