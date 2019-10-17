import React from 'react'
import SearchTextInput from '../../../search_page/search_process/SearchTextInput';

describe('<SearchTextInput />', () => {
  it('Renders text input component without crashing', () => {
    const component = shallow(
      <SearchTextInput />
    );

    const input = component.find('input');
    expect(input).toHaveLength(1);
    expect(input.prop('type')).toEqual('text');
  });
});
