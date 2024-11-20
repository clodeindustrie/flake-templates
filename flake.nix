 {
  description = "My templates";

  outputs = {self}: let
    mkWelcomeText = {
      name,
      description,
      path,
      buildTools ? null,
      additionalSetupInfo ? null,
    }: {
      inherit path;

      description = name;

      welcomeText = ''
        # ${name}
        ${description}

        ${
          if buildTools != null
          then ''
            Comes bundled with:
            ${builtins.concatStringsSep ", " buildTools}
          ''
          else ""
        }
        ${
          if additionalSetupInfo != null
          then ''
            ## Additional Setup
            To set up the project run:
            ```sh
            flutter create .
            ```
          ''
          else ""
        }

        ## More info
        - [flake-utils Github Page](https://github.com/numtide/flake-utils)
      '';
    };
  in {
    templates = {
      php = mkWelcomeText {
        path = ./php;
        name = "PHP Template";
        description = ''
          my php template
        '';
        buildTools = [
          "whatev"
        ];
      };
    };
  };
}
