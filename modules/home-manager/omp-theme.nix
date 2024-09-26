{
  blocks = [
    {
      alignment = "left";
      segments = [
        {
          type = "path";
          style = "plain";
          template = "{{ .Path }} ";
          properties.style = "full";
          foreground = "#77E4F7";
        }
        {
          type = "command";
          style = "plain";
          template = "{{ if .Output }}{{ .Output }} {{ end }}";
          properties.command = "if [[ $SHLVL -gt 2 ]]; then echo '('$(($SHLVL-2))')'; fi";
          foreground = "blue";
        }
        {
          type = "git";
          style = "plain";
          template = "{{ .HEAD }} ";
          foreground = "#FFE700";
        }
        {
          type = "text";
          style = "plain";
          template = "$ ";
          foreground = "#43D426";
        }
      ];
      type = "prompt";
    }
  ];
  version = 2;
}
