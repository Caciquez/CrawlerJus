import React from 'react';

const DisplayData = (props) => {
  const { data } = props;

  return (
    <div className="card details-card">
      <div className="card-content details--content">
        <span className="card-title"><b>Detalhes do Processo</b></span>
        <p className="details-value">
          <b>Área:</b>
          {' '}
          {data.area}
        </p>
        <p className="details-value">
          <b>Classe:</b>
          {' '}
          {data.class}
        </p>
        <p className="details-value">
          <b>Data de distribuição:</b>
          {' '}
          {data.data_distribition}
        </p>
        <p className="details-value">
          <b>Juiz:</b>
          {' '}
          {data.judge}
        </p>
        <p className="details-value">
          <b>Assunto:</b>
          {' '}
          {data.subject_matter}
        </p>
        <p className="details-value">
          <b>Valor da ação:</b>
          {' '}
          {data.action_value}
        </p>
      </div>
    </div>
  );
};

export default DisplayData;
