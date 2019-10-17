import React from 'react'
import SearchButton from '../../../search_page/search_process/SearchButton';

describe('<SearchButton />', () => {
  it('Renders button component without crashing', () => {
    const component = shallow(
      <SearchButton type="submit">
        Buscar
      </SearchButton>
    );

    const button = component.find('button');
    expect(button).toHaveLength(1);
    expect(button.prop('type')).toEqual('button');
    expect(button.text()).toEqual(' Buscar ');
  });
});
