<<<<<<< HEAD

import { Placement } from '@popperjs/core';
import { Component, findDOMfromVNode, InfernoNode } from 'inferno';
import { Popper } from "./Popper";

const DEFAULT_PLACEMENT = "top";

type TooltipProps = {
  children?: InfernoNode;
  content: string;
  position?: Placement,
=======
import { createPopper, Placement, VirtualElement } from '@popperjs/core';
import { Component, findDOMFromVNode, render } from 'inferno';
import type { Inferno } from 'inferno';

type TooltipProps = {
  children?: Inferno.InfernoNode;
  content: Inferno.InfernoNode;
  position?: Placement;
>>>>>>> 870ec40eef (Update to Python 3.11.2, Node 18.14.2, Inferno 8, Typescript 4.9, Yarn 3.4 (#8586))
};

type TooltipState = {
  hovered: boolean;
};

export class Tooltip extends Component<TooltipProps, TooltipState> {
  constructor() {
    super();

    this.state = {
      hovered: false,
    };
  }

  componentDidMount() {
    // HACK: We don't want to create a wrapper, as it could break the layout
    // of consumers, so we do the inferno equivalent of `findDOMNode(this)`.
    // My attempt to avoid this was a render prop that passed in
    // callbacks to onmouseenter and onmouseleave, but this was unwiedly
    // to consumers, specifically buttons.
    // This code is copied from `findDOMNode` in inferno-extras.
    // Because this component is written in TypeScript, we will know
    // immediately if this internal variable is removed.
<<<<<<< HEAD
    const domNode = findDOMfromVNode(this.$LI, true);
=======
    return findDOMFromVNode(this.$LI, true);
  }
>>>>>>> 870ec40eef (Update to Python 3.11.2, Node 18.14.2, Inferno 8, Typescript 4.9, Yarn 3.4 (#8586))

    domNode.addEventListener("mouseenter", () => {
      this.setState({
        hovered: true,
      });
    });

    domNode.addEventListener("mouseleave", () => {
      this.setState({
        hovered: false,
      });
    });
  }

  render() {
    return (
      <Popper
        options={{
          placement: this.props.position || "auto",
          modifiers: [{
            name: "eventListeners",
            enabled: false,
          }],
        }}
        popperContent={
          <div
            className="Tooltip"
            style={{
              opacity: this.state.hovered ? 1 : 0,
            }}>
            {this.props.content}
          </div>
        }
        additionalStyles={{
          "pointer-events": "none",
        }}>
        {this.props.children}
      </Popper>
    );
  }
}
