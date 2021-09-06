import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { Button, Stack, Input, Section, Table, Collapsible } from '../components';
import { Window } from '../layouts';
import { isFalsy } from 'common/react';

const pick = array => array[Math.floor(Math.random() * array.length)];

export const Snasboxpanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    Categories = [],
  } = data;
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');

  const Search = createSearch(searchText, item => {
    return item;
  });

  const filterSearch = command => {
    return Search(command[0]);
  };

  const Header = (
    <Section
      title={
        <Stack fill vertical>
          <Stack.Item>
            <Input
              autoFocus
              placeholder="Search"
              value={searchText}
              onInput={(e, value) => setSearchText(value)}
            />
          </Stack.Item>
        </Stack>
      } />
  );

  const makeButton = command => {
    return (
      <Stack.Item fill grow>
        <Button
          fluid
          onClick={() => act(command[1])}
          content={command[0]} />
      </Stack.Item>
    );
  };

  const makeCategory = Category => {
    let Commands = Category[1]
      .filter(filterSearch)
      .map(makeButton);
    if (Commands.length) {
      return (
        <Section
          title={`${Category[0]} (${Commands.length})`}
          bold>
          <Section>
            <Stack
              vertical
              wrap
              textAlign="center"
              justify="center">
              {Commands}
            </Stack>
          </Section>
        </Section>
      );
    }
  };

  const Items = Object.entries(Categories)
    .map(makeCategory);

  return (
    <Window
      width={380}
      height={580}>
      <Window.Content scrollable>
        {Header}
        {Items}
        {(Items && Items.length === 0) && "No results found."}
      </Window.Content>
    </Window>
  );

};
