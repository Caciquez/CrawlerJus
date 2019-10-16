import React, { Fragment } from 'react'
import ProcessSearchContext from '../context/Context'

class SearchSelectOptions extends React.Component {
  static contextType = ProcessSearchContext

  render() {
    const { context } = this
    return (
      <Fragment>
        <div className="input-field col s12">
          <select
            required
            className="select-options"
            defaultValue={'DEFAULT'}
            onChange={(evt) => context.handleUrlParams('court_id', evt)}
          >
            <option value="DEFAULT" disabled>Selecione o tribunal</option>
            {context.state.courts.map(court => (
              <option key={court.id} value={court.id}>
                {court.name} - {court.name_abbreviation}
              </option>
            ))}
          </select>
        </div>
      </Fragment>
    )
  }
}


export default SearchSelectOptions
