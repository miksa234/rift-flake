{ inputs, ... }:
{
  imports = [ inputs.rift.darwinModules.rift ];

  services.rift = {
    enable = true;

    settings = {
      settings = {
        animate = true;
        animation_duration = 0.3;
        animation_fps = 100.0;
        focus_follows_mouse = true;
        mouse_follows_focus = true;
        hot_reload = true;

        layout = {
          mode = "scrolling";
          scrolling = {
            column_width_ratio = 0.7;
            min_column_width_ratio = 0.3;
            max_column_width_ratio = 0.9;
            alignment = "center";
            focus_navigation_style = "niri";
          };
          gaps = {
            outer = {
              top = 10;
              left = 10;
              bottom = 10;
              right = 10;
            };
            inner = {
              horizontal = 10;
              vertical = 10;
            };
          };
        };
      };

      virtual_workspaces = {
        enabled = true;
        default_workspace_count = 9;
        auto_assign_windows = true;
        preserve_focus_per_workspace = true;
      };

      modifier_combinations.comb1 = "Alt + Shift";

      keys = {
        "Alt + H".move_focus = "left";
        "Alt + J".move_focus = "down";
        "Alt + K".move_focus = "up";
        "Alt + L".move_focus = "right";
        "comb1 + H".move_node = "left";
        "comb1 + J".move_node = "down";
        "comb1 + K".move_node = "up";
        "comb1 + L".move_node = "right";
        "Alt + Enter".exec = [
          "/usr/bin/open"
          "-na"
          "Ghostty"
        ];
      };
    };
  };
}
