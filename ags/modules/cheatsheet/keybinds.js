const { Gtk } = imports.gi;
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { keybindList } from "./data_keybinds.js";

export default () => {
  const Category = (category) =>
    Widget.Box({
      // Categories
      vertical: true,
      className: "spacing-v-15",
      children: [
        Widget.Box({
          // Category header
          vertical: false,
          className: "spacing-h-10",
          children: [
            Widget.Label({
              xalign: 0,
              className: `icon-material txt-larger cheatsheet-color-${category.id}`,
              label: category.icon,
            }),
            Widget.Label({
              xalign: 0,
              className: "cheatsheet-category-title txt",
              label: category.name,
            }),
          ],
        }),
        Widget.Box({
          vertical: false,
          className: "spacing-h-10",
          children: [
            Widget.Box({
              // Keys
              vertical: true,
              homogeneous: true,
              children: category.binds.map((keybinds, _) =>
                Widget.Box({
                  // Binds
                  vertical: false,
                  children: keybinds.keys.map((key, _) =>
                    Widget.Label({
                      // Specific keys
                      className: `${["OR", "+"].includes(key) ? "cheatsheet-key-notkey" : "cheatsheet-key cheatsheet-color-" + category.id} txt-small`,
                      label: key,
                    }),
                  ),
                }),
              ),
            }),
            Widget.Box({
              // Actions
              vertical: true,
              homogeneous: true,
              children: category.binds.map((keybinds, _) =>
                Widget.Label({
                  // Binds
                  xalign: 0,
                  label: keybinds.action,
                  className: "txt chearsheet-action txt-small",
                }),
              ),
            }),
          ],
        }),
      ],
    });
  const realKeybinds = Widget.Box({
    vertical: false,
    className: "spacing-h-15",
    homogeneous: true,
    children: keybindList.map((group, _) =>
      Widget.Box({
        // Columns
        vertical: true,
        className: "spacing-v-15",
        children: group.map((category, _) => Category(category)),
      }),
    ),
  });
  return Widget.Box({
    vertical: true,
    className: "spacing-v-10",
    children: [
      Widget.Label({
        useMarkup: true,
        selectable: true,
        justify: Gtk.Justification.CENTER,
        className: "txt-small txt",
        label:
          "Sheet data stored in <tt>~/.config/ags/modules/cheatsheet/data_keybinds.js</tt>\nChange keybinds in <tt>~/.config/hypr/keybinds.conf</tt>",
      }),
      realKeybinds,
    ],
  });
};

