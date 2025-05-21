{
  pkgs,
  ...
}: {

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.xwayland.enable = true;
  
  wayland.windowManager.hyprland.settings."$mod" = "SUPER"; #TODO: substitute SUPER with mod

  wayland.windowManager.hyprland.settings.bind = [
    # starting applications
        "SUPER,RETURN,exec,kitty"
        "SUPER,SPACE,exec,anyrun"
        #"SUPER,E,exec,ghostty -e yazi"

        # window management
        "SUPER,Q,killactive"
        "SUPER,M,exit"
        "SUPER,S,togglefloating"
        "SUPER,F,fullscreen"

        # move the active window to the next position
        "SUPER,N,swapnext"
        # make the active window the main
        "SUPER,A,togglesplit"

        # screenshots
        ",Print,exec,grim - | wl-copy"
        ''SHIFT,Print,exec,grim -g "$(slurp)" - | wl-copy''

        # brightness control
        ", XF86MonBrightnessUp,     exec, brightnessctl set 10%+"
        ", XF86MonBrightnessDown,   exec, brightnessctl set 10%-"

        # volume control (for pipewire / wireplumber)
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @D#EFAULT_AUDIO_SINK@ 10%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"

        # disable notifications
        # TODO: find how to do it with hyprpanel
        # "SHIFT_SUPER,N,exec,makoctl mode -t do-not-disturb"

        # hyprland management
        "SUPER,R,exec,hyprctl reload"

        # navigation between windows
      "SUPER, le ft,movefocus, l"
      "SUPER, ri ght,movefocus, r"
      "SUPER, up ,movefocus, u"
      "SUPER, do wn,movefocus, d"

       #  works pa  ce selecti on
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER, 9, workspace, 9"
      "SUPER, 0, workspace, 10"

      # move window to workspace
      "CTRL_SUPER, 1, movetoworkspace, 1"
      "CTRL_SUPER, 2, movetoworkspace, 2"
      "CTRL_SUPER, 3, movetoworkspace, 3"
      "CTRL_SUPER, 4, movetoworkspace, 4"
      "CTRL_SUPER, 5, movetoworkspace, 5"
      "CTRL_SUPER, 6, movetoworkspace, 6"
      "CTRL_SUPER, 7, movetoworkspace, 7"
      "CTRL_SUPER, 8, movetoworkspace, 8"
      "CTRL_SUPER, 9, movetoworkspace, 9"
      "CTRL_SUPER, 0, movetoworkspace, 10"

      "bind=SUPER,mouse_down,workspace,e+1"
      "bind=SUPER,mouse_up,workspace,e-1"
      "bind=SUPER,g,togglegroup"
      "bind=SUPER,tab,changegroupactive"
      ];

  wayland.windowManager.hyprland.settings.input = {
        kb_layout = "us,ru";
        kb_variant = ",qwerty";
        kb_options = "grp:alt_space_toggle";
        sensitivity = 0.3; 
      };
        # for mouse cursor
        # must click on window to move focus
        # follow_mouse=2

  wayland.windowManager.hyprland.settings.input.touchpad = {
          natural_scroll = "yes";
          scroll_factor = 0.6;
        };
      

      # move and resize windows with the mouse cursor
  wayland.windowManager.hyprland.settings.bindm = [
        "SUPER,mouse:272,movewindow"
        "SHIFT_SUPER,mouse:272,resizewindow"
        ];

}
