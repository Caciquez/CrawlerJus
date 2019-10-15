import React, { Component } from 'react';
import PropTypes from 'prop-types';

import SearchHeader from './search_process/components/SearchHeader';
import DisplayProcess from './display_process/components/DisplayProcess';

export default class App extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <>
        <SearchHeader />
        <DisplayProcess />
      </>
    );
  }
}
