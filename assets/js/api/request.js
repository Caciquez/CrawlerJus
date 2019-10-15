const request = async (path, method, params = {}) => {
  const response = await fetch(path, {
    method,
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
    },
    credentials: 'same-origin',
    ...params,
  });

  if (!response.ok) {
    const errors = await response.json();
    throw errors;
  }

  return response.json();
};

export default {
  get(path) {
    return request(path, 'GET');
  },
};
