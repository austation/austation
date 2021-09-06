import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { Button, Flex, Input, Section, Table, Collapsible } from '../components';
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
        <Table>
          <Table.Row>
            <Table.Cell>
              {"Snasbox Panel"}
            </Table.Cell>
            <Table.Cell
              textAlign="right">
              <Input
                placeholder="Search"
                value={searchText}
                onInput={(e, value) => setSearchText(value)}
                mx={1}
              />
            </Table.Cell>
          </Table.Row>
        </Table>
      } />
  );

  const makeButton = command => {
    return (
      <Flex.Item grow={1} basis="49%">
        <Button
          fluid
          ellipsis
          my={0.5}
          onClick={() => act(command[1])}
          content={command[0]} />
      </Flex.Item>
    );
  };

  const makeCategory = Category => {
    let Commands = Category[1]
      .filter(filterSearch)
      .map(makeButton);
    if (Commands.length) {
      return (
        <Collapsible
          title={`${Category[0]} (${Commands.length})`}
          bold
          key>
          <Section>
            <Flex
              spacing={1}
              wrap="wrap"
              textAlign="center"
              justify="center">
              {Commands}
            </Flex>
          </Section>
        </Collapsible>
      );
    }
  };

  const Items = Object.entries(Categories)
    .map(makeCategory);

  return (
    <Window
      width={720}
      height={480}>
      <Window.Content scrollable>
        {Header}
        <Section>
          {Items}
          {(Items && Items.length === 0) && "No results found."}
        </Section>
      </Window.Content>
    </Window>
  );

};
