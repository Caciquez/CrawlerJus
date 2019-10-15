import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import ProcessSearchContext from '../context/Context'

class SearchTextInput extends React.Component {
  static contextType = ProcessSearchContext

  render() {
    const { context } = this
    return (
      <Fragment>
        <div className="input-field col s12">
          <input
            placeholder="Número do Processo"
            type="text"
            className="validate"
            onChange={(evt) => context.handleUrlParams('process_code', evt)}
          />
        </div>
      </Fragment>
    )
  }
}

export default SearchTextInput
