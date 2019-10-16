import React from 'react'
import SearchHeader from '../search_process/SearchHeader'
import DisplayProcess from '../display_process/DisplayProcess'
import ProcessSearchContext from './Context'
import request from '../../api/request'

class ProcessSearchProvider extends React.Component {

  state = {
    ...this.props,
    process_data: null,
    process_code: "",
    court_id: "",
    errors: null,
    current_moviments_on_page: null
  }

  buildMovimentsPage = (page) => {
    const { moviments } = this.state.process_data.data
    return this.pageSlicer(moviments, page)
  }

  pageSlicer = (moviments, page) => {
    return moviments.slice(page * 10, (page + 1) * 10)
  }

  handleSubmit = async evt => {
    evt.preventDefault()

    try {
      const path = `/search-process?court_id=${this.state.court_id}&process_code=${this.state.process_code}`
      const result = await request.get(path)

      const initial_page = this.pageSlicer(result.data.process_data.data.moviments, 0)

      this.setState({
        current_moviments_on_page: initial_page
        , process_data: result.data.process_data
      })

    } catch (errors) {
      window.scrollTo(0, 0)
      this.setState({ errors })
    }
  }

  handlePageDisplay = (data) => {
    const { selected: page } = data
    const new_page = this.buildMovimentsPage(page)
    this.setState({
      current_moviments_on_page: new_page
    })
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
          handleUrlParams: this.handleUrlParams,
          handlePageDisplay: this.handlePageDisplay
        }}
      >
        <SearchHeader />
        <DisplayProcess />
      </ProcessSearchContext.Provider>
    )
  }

}

export default ProcessSearchProvider
