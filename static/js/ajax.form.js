const form = document.getElementById('page-form')

const renderErrors = errors => {
  const html = errors.reduce(e => `<span class="d-block">${e}</span>`)
  form.insertAdjacentHTML('beforebegin', `<div class="alert alert-danger message">${html}</div>`)
};

const formToJson = () => {
  const data = {};
  const inputs = form.querySelectorAll('input');
  inputs.forEach(i => data[i.name] = i.value);
  return data;
}

const clearMessages = () => document.querySelectorAll('.message').forEach(e => e.remove());

const renderSuccess = (message) => {
  const redirect = form.getAttribute('redirect-to');
  redirect && (location.href = redirect);
  form.getAttribute('reset') == "true" && form.reset();
  form.insertAdjacentHTML('beforebegin', `<div class="alert alert-success message">${message}</div>`)
}

const handleSubmit = async e => {
  e.preventDefault();
  clearMessages();
  const method = form.method || 'GET';
  const body = new FormData(form);
  console.log(formToJson());
  try {
    const data = await fetch(form.action, { method, body, headers: {
      "Accept": "application/json"
    } });
    const json = await data.json();
    const { errors, success } = json;
    errors && renderErrors(errors);
    success && renderSuccess(success);
  } catch (err) {
    alert('Some unknown error occurred!')
    console.log(err);
  }
}

form?.addEventListener('submit', handleSubmit);