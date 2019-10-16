import React from 'react';
import PropTypes from 'prop-types';

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

DisplayData.propTypes = {
  data: PropTypes.objectOf(
    PropTypes.shape({
      area: PropTypes.string.isRequired,
      class: PropTypes.string.isRequired,
      data_distribition: PropTypes.string.isRequired,
      judge: PropTypes.string.isRequired,
      subject_matter: PropTypes.string.isRequired,
      action_value: PropTypes.string.isRequired,
    }),
  ),
};

export default DisplayData;
