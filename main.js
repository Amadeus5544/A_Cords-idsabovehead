function masolas(str) {
  const el = document.createElement('textarea');
  el.value = str;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
}

window.addEventListener('message', function(event) {
  if (event.data.type === 'clipboard') {
    masolas(event.data.data);
  }
});
