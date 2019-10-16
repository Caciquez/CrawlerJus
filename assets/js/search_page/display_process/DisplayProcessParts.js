import React, { Fragment } from 'react';

const DisplayProcessParts = (props) => {
  const { parts } = props;

  const part = parts.map((part_obj, index) => {
    const [[key, value]] = Object.entries(part_obj);

    return (
      <Fragment key={index}>
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

export default DisplayProcessParts;
