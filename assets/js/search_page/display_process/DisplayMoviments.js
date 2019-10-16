import React, { Fragment } from 'react';
import PropTypes from 'prop-types';
import ReactPaginate from 'react-paginate';

window.React = React;

const DisplayMoviments = (props) => {
  const { moviments, pageCount, handlePageDisplay } = props;
  return (
    <Fragment>
      <div className="card moviment-wrapper">
        <div className="card-content moviment-details">
          <span className="card-title"><b>Movimentações</b></span>
          {moviments.map((moviment, index) => (
            <div className="moviment-detail-wrapper" key={index}>
              <span className="moviment-data"><b>{moviment.data}</b></span>
              <p className="moviment-log">{moviment.moviment}</p>
              {moviment.moviment_url == null ? null : <a href={`https://www2.tjal.jus.br${moviment.moviment_url}`} target="_blank">PDF</a>}
            </div>
          ))}
        </div>
      </div>

      <ReactPaginate
        previousLabel={'Anterior'}
        nextLabel={'Proximo'}
        breakLabel={'...'}
        breakClassName={'break-me'}
        pageCount={pageCount}
        marginPagesDisplayed={2}
        pageRangeDisplayed={5}
        onPageChange={(evt) => handlePageDisplay(evt)}
        containerClassName={'pagination'}
        subContainerClassName={'pages pagination'}
        activeClassName={'active'}
      />
    </Fragment>
  );
};

export default DisplayMoviments;
