{ inputs, ... }:
{
  imports = [ inputs.rift.darwinModules.rift ];

  services.rift = {
    enable = true;
    settings = {
      settings.layout = {
        mode = "scrolling";
        scrolling.focus_navigation_style = "niri";
      };

      virtual_workspaces = {
        enabled = true;
        default_workspace_count = 4;
      };

      keys = {
        "Alt + H".move_focus = "left";
        "Alt + L".move_focus = "right";
      };
    };
  };
}
