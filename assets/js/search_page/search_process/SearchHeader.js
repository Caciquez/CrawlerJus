import React, { Component } from 'react'
import SearchSelectOptions from './SearchSelectOptions'
import SearchTextInput from './SearchTextInput'
import SearchButton from './SearchButton'

class SearchHeader extends Component {
  render = () => {
    return (
      <div className="row">
        <div className="col s12 m12 l12">
          <div className="card moviment-wrapper">
            <div className="card-content moviment-details">
              <span className="card-title"><b>Buscar</b></span>
              <p> Para ver os dados de um processo selecione um tribunal e digite o número unificado do mesmo.</p>
              <div className="row">
                <div className="col s12 m5 l5">
                  <SearchSelectOptions />
                </div>

                <div className="col s12 m5 l5">
                  <SearchTextInput />
                </div>

                <div className="col s12 m2 l2">
                  <SearchButton />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

export default SearchHeader
