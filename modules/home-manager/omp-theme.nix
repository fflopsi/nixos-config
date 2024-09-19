{
  blocks = [
    {
      alignment = "left";
      segments = [
        {
          foreground = "#77E4F7";
          properties = {
            style = "full";
          };
          style = "plain";
          template = "{{ .Path }} ";
          type = "path";
        }
        {
          type = "nix-shell";
          style = "plain";
          foreground = "blue";
          template = "($(($SHLVL - 1))) ";
        }
        {
          foreground = "#FFE700";
          style = "plain";
          template = "{{ .HEAD }} ";
          type = "git";
        }
        {
          foreground = "#43D426";
          style = "plain";
          template = "$ ";
          type = "text";
        }
      ];
      type = "prompt";
    }
  ];
  version = 2;
}
