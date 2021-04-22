import { useDispatch, useSelector } from 'common/redux';
import { Button, Stack, Box, Section } from 'tgui/components';
import { selectStatPanel } from './selectors';
import { StatText } from './StatText';

export const StatStatus = (props, context) => {
  const stat = useSelector(context, selectStatPanel);
  const dispatch = useDispatch(context);
  let statPanelData = [];
  if (stat.infomationUpdate) {
    for (const [key, value] of Object.entries(stat.infomationUpdate)) {
      if (key === stat.selectedTab) {
        statPanelData = value;
      }
    }
  }
  return (
    <Stack fill vertical>
      {stat.dead_popup
        ?(
          <Stack.Item mt={1} mb={1}>
            <Stack vertical>
              <div className="StatBorder_observer">
                <Stack.Item>
                  <Box
                    className="deadsay">
                    <Button
                      color="transparent"
                      icon="times"
                      onClick={() => dispatch({
                        type: 'stat/clearDeadPopup',
                      })} />
                    You are <b>dead</b>!
                  </Box>
                </Stack.Item>
                <Stack.Item mt={2}>
                  <Box
                    className="deadsay">
                    Don&#39;t worry, you can still get back into the game
                    if your body is revived or through ghost roles.
                  </Box>
                </Stack.Item>
              </div>
            </Stack>
          </Stack.Item>
        )
        :null}
      {stat.alert_popup
        ?(
          <Stack.Item mt={1} mb={1}>
            <div className="StatBorder_infomation">
              <Box>
                <Stack
                  vertical
                  className="stat_infomation">
                  <Stack.Item bold>
                    <Button
                      color="transparent"
                      icon="times"
                      onClick={() => dispatch({
                        type: 'stat/clearAlertPopup',
                      })} />
                    <Box inline>
                      {stat.alert_popup.title}
                    </Box>
                  </Stack.Item>
                  <Stack.Item mt={2}>
                    {stat.alert_popup.text}
                  </Stack.Item>
                </Stack>
              </Box>
            </div>
          </Stack.Item>
        )
        :null}
      {stat.antagonist_popup
        ?(
          <Stack.Item mt={1} mb={1}>
            <div className="StatBorder_antagonist">
              <Box>
                <Stack
                  vertical
                  className="stat_antagonist">
                  <Stack.Item bold>
                    <Button
                      color="transparent"
                      icon="times"
                      onClick={() => dispatch({
                        type: 'stat/clearAntagPopup',
                      })} />
                    <Box inline>
                      {stat.antagonist_popup.title}
                    </Box>
                  </Stack.Item>
                  <Stack.Item mt={2}>
                    {stat.antagonist_popup.text}
                  </Stack.Item>
                </Stack>
              </Box>
            </div>
          </Stack.Item>
        )
        :null}
      <StatText />
    </Stack>
  );
};

// =======================
// Non-Flex Support
// =======================

export const HoboStatStatus = (props, context) => {
  const stat = useSelector(context, selectStatPanel);
  const dispatch = useDispatch(context);
  let statPanelData = [];
  if (stat.infomationUpdate) {
    for (const [key, value] of Object.entries(stat.infomationUpdate)) {
      if (key === stat.selectedTab) {
        statPanelData = value;
      }
    }
  }
  return (
    <Box>
      {stat.dead_popup
        ?(
          <div className="StatBorder_observer">
            <Box>
              <Section
                className="deadsay">
                <Button
                  color="transparent"
                  icon="times"
                  onClick={() => dispatch({
                    type: 'stat/clearDeadPopup',
                  })} />
                You are <b>dead</b>!
              </Section>
            </Box>
            <Box>
              <Section
                className="deadsay">
                Don&#39;t worry, you can still get back into the game
                if your body is revived or through ghost roles.
              </Section>
            </Box>
          </div>
        )
        :null}
      {stat.alert_popup
        ?(
          <div className="StatBorder_infomation">
            <Section>
              <Box className="stat_infomation">
                <Button
                  color="transparent"
                  icon="times"
                  onClick={() => dispatch({
                    type: 'stat/clearAlertPopup',
                  })} />
                <Box inline>
                  {stat.alert_popup.title}
                </Box>
                <Box>
                  {stat.alert_popup.text}
                </Box>
              </Box>
            </Section>
          </div>
        )
        :null}
      {stat.antagonist_popup
        ?(
          <div className="StatBorder_antagonist">
            <Section>
              <Box className="stat_antagonist">
                <Button
                  color="transparent"
                  icon="times"
                  onClick={() => dispatch({
                    type: 'stat/clearAntagPopup',
                  })} />
                <Box inline bold>
                  {stat.antagonist_popup.title}
                </Box>
                <Box>
                  {stat.antagonist_popup.text}
                </Box>
              </Box>
            </Section>
          </div>
        )
        :null}
      <StatText />
    </Box>
  );
};
