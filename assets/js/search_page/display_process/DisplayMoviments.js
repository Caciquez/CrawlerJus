import React from 'react';
import ReactPaginate from 'react-paginate';

window.React = React;

const DisplayMoviments = (props) => {
  const { moviments } = props;

  return (
    <div className="card moviment-wrapper">
      <div className="card-content moviment-details">
        <span className="card-title"><b>Movimentações</b></span>
        {moviments.map((moviment, index) => (
          <div className="moviment-detail-wrapper" key={index}>
            <span className="moviment-data"><b>{moviment.data}</b></span>
            <p className="moviment-log">{moviment.moviment}</p>
            {moviment.url ? <a href={moviment.url}>pdf</a> : <a />}
          </div>
        ))}
      </div>
    </div>
  );
};

export default DisplayMoviments;
