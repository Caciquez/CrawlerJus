import React, { Component, Fragment } from 'react'
import SearchSelectOptions from './SearchSelectOptions'
import SearchTextInput from './SearchTextInput'
import SearchButton from './SearchButton'

class SearchHeader extends Component {
  render = () => {
    return (
      <Fragment>
        <h5>Buscar</h5>
        <p> Selecione um tribunal para listar os processos ou buscar pelo número unificado.</p>
        <div className="row">
          <div className="col s12 m8 l8">
            <SearchSelectOptions />
          </div>

          <div className="col s12 m8 l8">
            <SearchTextInput />
          </div>

          <div className="col s12 m2 l2">
            <SearchButton />
          </div>
        </div>
      </Fragment>
    )
  }
}

export default SearchHeader
