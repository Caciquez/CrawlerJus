import React, { Component } from 'react';

import SearchHeader from './search_process/components/SearchHeader';
import DisplayProcess from './display_process/components/DisplayProcess';

export default class App extends Component {
  render() {
    return (
      <>
        <SearchHeader />
        <DisplayProcess />
      </>
    );
  }
}
