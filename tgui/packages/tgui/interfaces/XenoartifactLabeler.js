import { useBackend } from '../backend';
import {Button, Section, Box, Flex, Input, BlockQuote} from '../components';
import { Window } from '../layouts';

export const XenoartifactLabeler = (props, context) => {
  return (
    <Window>
      <Window.Content scrollable>
        <XenoartifactLabelerSticker/>
        <XenoartifactLabelerActivators/>
      </Window.Content>
    </Window>
  );
};

const XenoartifactLabelerActivators = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    activator,
    activator_traits,
    minor_trait,
    minor_traits,
    major_trait,
    major_traits,
    info_list,
  } = data;
  return (
    <Flex grow = {1}>
        <Flex.Item column>
            <Section title="Material">
                        <Box>
                            {
                                activator_traits.map(trait => <XenoartifactLabelerGenerateList specific_trait = {trait} check_against = {activator} trait_type = "activator"/>)
                            }
                        </Box>
            </Section>
            <Section title="Notes">
                        <Box>
                            {
                                minor_traits.map(trait => <XenoartifactLabelerGenerateList specific_trait = {trait} check_against = {minor_trait} trait_type = "minor"/>)
                            }
                        </Box>
            </Section>
            <Section title="Shape">
                        <Box>
                            {
                                major_traits.map(trait => <XenoartifactLabelerGenerateList specific_trait = {trait} check_against = {major_trait} trait_type = "major"/>)
                            }
                        </Box>
            </Section>
        </Flex.Item>
        <Flex.Item column>
            <Box fluid px = {1}>
                {info_list.map(info => <XenoartifactLabelerGenerateInfo info = {info}/>)}
            </Box>
        </Flex.Item>
    </Flex>
  );
};

const XenoartifactLabelerGenerateList = (props, context,) => {
    const { act } = useBackend(context);
    const {
        specific_trait,
        check_against,
        trait_type,
      } = props;
    return (
        <Box>
            <Button.Checkbox content = {specific_trait} checked={check_against.includes(specific_trait)} onClick={() => act(`assign_${trait_type}_${specific_trait}`)}/>
        </Box>
    );
  };

const XenoartifactLabelerGenerateInfo = (props, context,) => {
const { act } = useBackend(context);
const {
    info
    } = props;
return (
    <Section>
        <Box italic>
            <BlockQuote>
                {`${info}`}
            </BlockQuote>
        </Box>
    </Section>
);
};

const XenoartifactLabelerSticker = (props, context) => {
const { act } = useBackend(context);
return (
    <Box>
        <Input onChange={(e, input) => act('change_print_name', {name: input})}/>
        <Button content = "Print" placeholder = "Xenoartifact name..." onClick={() => act("print_traits")}/>
    </Box>
);
};
