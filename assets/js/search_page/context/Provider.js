import React from 'react'
import PropTypes from 'prop-types'
import SearchHeader from '../search_process/SearchHeader'
import DisplayProcess from '../display_process/DisplayProcess'
import ProcessSearchContext from './Context'
import request from '../../api/request'
import { throws } from 'assert'

class ProcessSearchProvider extends React.Component {
  static propTypes = {
    courts: PropTypes.array
  }
  state = {
    ...this.props,
    process_data: null,
    process_code: null,
    court_id: null,
    errors: null
  }

  invalidParameters = () => {
    if (court_id && process_code) {
      return false
    }
    return true
  }

  handleSubmit = async evt => {
    evt.preventDefault()

    try {

      const path = `/search-process?court_id=${this.state.court_id}&process_code=${this.state.process_code}`
      const result = await request.get(path)

      this.setState({ process_data: result.data.process_data })
    } catch (errors) {
      window.scrollTo(0, 0)

      if (errors instanceof Error) {
        this.setState({ errors: errors.message })
      } else {
        this.setState({ errors })
      }
    }
  }


  handleUrlParams = (key, event) => {
    if (key == 'court_id') {
      return this.setState({ court_id: event.target.value })
    }

    if (key == 'process_code') {
      return this.setState({ process_code: event.target.value })
    }
  }

  render() {
    return (
      <ProcessSearchContext.Provider
        value={{
          state: this.state,
          handleSubmit: this.handleSubmit,
          handleUrlParams: this.handleUrlParams
        }}
      >
        <SearchHeader />
        <DisplayProcess />
      </ProcessSearchContext.Provider>
    )
  }

}

export default ProcessSearchProvider
