import React, { Component, Fragment } from 'react'
import ProcessSearchContext from '../context/Context'
import DisplayMovements from './DisplayMoviments'
import DisplayData from './DisplayData'
import DisplayProcessParts from './DisplayProcessParts'

class DisplayProcess extends Component {
  static contextType = ProcessSearchContext

  render = () => {
    const { context } = this

    if (context.state.process_data) {
      return (
        <Fragment>
          <h5>Processo n. {context.state.process_data.process_code} do {context.state.process_data.court.name_abbreviation}</h5>
          <h6>Distrubuido em {context.state.process_data.data.data_distribution}</h6>
          <div className="row">
            <div className="col s12 m8 l8">
              <DisplayMovements moviments={context.state.process_data.data.moviments} />
            </div>

            <div className="col s12 m4 l4">
              <DisplayData data={context.state.process_data.data} />
            </div>

            <div className="col s12 m4 l4">
              <div className="card">
                <div className="card-content">
                  <span className="card-title"><b>Partes envolvidas</b></span>
                  <DisplayProcessParts parts={context.state.process_data.data.process_parts} />
                </div>
              </div>
            </div>
          </div>
        </Fragment>
      )
    }

    if (context.state.errors) {
      return (
        <Fragment>
          <h4>{context.state.errors}</h4>
        </Fragment>
      )
    }
    return null
  }
}

export default DisplayProcess
