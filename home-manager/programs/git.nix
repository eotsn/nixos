{
  programs.git = {
    enable = true;
    userName = "Eric Ottosson";
    userEmail = "4204520+eotsn@users.noreply.github.com";
    diff-so-fancy.enable = true;
    ignores = [
      ".direnv"
      ".envrc"
    ];
    extraConfig = {
      url = {
        "git@github.com:" = {
          insteadOf = [ "git://github.com/" "https://github.com/" ];
        };
      };
    };
  };
}
