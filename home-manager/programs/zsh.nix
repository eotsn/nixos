{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''
      bindkey -s ^f "tmux-sessionizer\n"

      function jwtDecode {
        jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $1
      }
    '';
  };
}
