import React, { Component, Fragment } from 'react'
import ProcessSearchContext from '../context/Context'

class DisplayProcess extends Component {
  static contextType = ProcessSearchContext

  render = () => {
    const { context } = this
    console.log(context.state.process_data)
    if (context.state.process_data) {
      return (
        <Fragment>
          <div className="row">
            <div className="col s12 m12">
              <h5>Processo n. {context.state.process_data.process_code} do {context.state.process_data.court.name_abbreviation}</h5>
              <div className="card">
                <div className="card-content">
                  <span className="card-title"><b>Movimentações</b></span>
                  {context.state.process_data.data.moviments.map(moviment => (
                    <Fragment>
                      <span key={moviment.id}>{moviment.data}</span>
                      <p>{moviment.moviment}</p>
                    </Fragment>
                  ))}
                </div>
              </div>
            </div>
          </div>

          <div className="row">
            <div className="col s12 m12">
              <div className="card">
                <div className="card-content">
                  <span className="card-title"><b>Dados do processo</b></span>
                  <p>I am a very simple card. I am good at containing small bits of information.
          I am convenient because I require little markup to use effectively.</p>
                </div>
              </div>
            </div>
          </div>

          <div className="row">
            <div className="col s12 m12">
              <div className="card">
                <div className="card-content">
                  <span className="card-title"><b>Partes envolvidas</b></span>
                  <p>I am a very simple card. I am good at containing small bits of information.
          I am convenient because I require little markup to use effectively.</p>
                </div>
              </div>
            </div>
          </div>
        </Fragment>
      )
    }
    return (
      <Fragment>
        <h4>Pesquise um processo.</h4>
      </Fragment>
    )
  }
}

export default DisplayProcess
