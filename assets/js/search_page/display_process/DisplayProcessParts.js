import React, { Fragment } from 'react';
import PropTypes from 'prop-types';

const DisplayProcessParts = (props) => {
  const { parts } = props;

  const part = parts.map((partobj, index) => {
    const [[key, value]] = Object.entries(partobj);

    return (
      <Fragment key={value}>
        <div className="parts-card">
          <span className="parts-role">
            <b>
              {key}
              :
            </b>
          </span>
          <p className="parts-value">{value}</p>
        </div>
      </Fragment>
    );
  });
  return part;
};

DisplayProcessParts.PropTypes = {
  parts: PropTypes.arrayOf(
    PropTypes.shape(
      {
        key: PropTypes.string.isRequired,
        value: PropTypes.string.isRequired,
      },
    ),
  ),
};

export default DisplayProcessParts;
