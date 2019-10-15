import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import ProcessSearchContext from '../context/Context'

class SearchButton extends React.Component {
  static contextType = ProcessSearchContext

  render() {
    const { context } = this
    return (
      <Fragment>
        <div className="input-field col s12">
          <button
            className="btn waves-effect waves-light"
            type="button"
            onClick={(evt) => context.handleSubmit(evt)}
          > Buscar </button>
        </div>
      </Fragment>
    )
  }
}

export default SearchButton
