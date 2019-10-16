import React from 'react';
import { render } from 'react-dom';
import App from './App';

export default function () {
  const container = document.querySelector('#search-page');
  if (container) {
    render(<App />, container);
  }
}
