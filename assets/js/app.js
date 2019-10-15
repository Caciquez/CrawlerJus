// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss';

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import 'phoenix_html';
import 'react-phoenix';
import 'materialize-css/js/global';
import 'materialize-css/js/cash';
import 'materialize-css/js/forms';
import 'materialize-loader';

import M from 'materialize-css';
import 'babel-polyfill';
// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import ProcessSearchProvider from './search_page/context/Provider';

window.Components = {
  ProcessSearchProvider,
};

M.AutoInit();

document.addEventListener('DOMContentLoaded', () => {
  const elems = document.querySelectorAll('.select-options');
  M.FormSelect.init(elems, {});
});
