{...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
      };
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.0117;
          brightness = 0.8;
        }
      ];
    };
  };
}
