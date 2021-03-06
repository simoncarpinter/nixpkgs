{ stdenv, python }:
let

  localPython = python.override {
    packageOverrides = self: super: {
      cement = super.cement.overridePythonAttrs (oldAttrs: rec {
        version = "2.8.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1li2whjzfhbpg6fjb6r1r92fb3967p1xv6hqs3j787865h2ysrc7";
        };
      });

      colorama = super.colorama.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.7";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0avqkn6362v7k2kg3afb35g4sfdvixjgy890clip4q174p9whhz0";
        };
      });

      requests = super.requests.overridePythonAttrs (oldAttrs: rec {
        version = "2.9.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0zsqrzlybf25xscgi7ja4s48y2abf9wvjkn47wh984qgs1fq2xy5";
        };
      });

      semantic-version = super.semantic-version.overridePythonAttrs (oldAttrs: rec {
        version = "2.5.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0p5n3d6blgkncxdz00yxqav0cis87fisdkirjm0ljjh7rdfx7aiv";
        };
      });

      tabulate = super.tabulate.overridePythonAttrs (oldAttrs: rec {
        version = "0.7.5";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "03l1r7ddd1a0j2snv1yd0hlnghjad3fg1an1jr8936ksv75slwch";
        };
      });
    };
  };
in with localPython.pkgs; buildPythonApplication rec {
  pname = "awsebcli";
  version = "3.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jj6xhvsrgvc5pm05zbd95zvx36ssywq70j6q1kzcdv1flfzzyp9";
  };

  checkInputs = [
    pytest mock nose pathspec colorama requests docutils
  ];

  doCheck = false;

  propagatedBuildInputs = [
    # FIXME: Add optional docker dependency, which requires requests >= 2.14.2.
    # Otherwise, awsebcli will try to install it using pip when using some
    # commands (like "eb local run").
    blessed botocore cement colorama dockerpty docopt pathspec pyyaml
    requests semantic-version setuptools tabulate termcolor websocket_client
  ];

  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    mv $out/bin/eb_completion.bash $out/etc/bash_completion.d
  '';

  meta = with stdenv.lib; {
    homepage = https://aws.amazon.com/elasticbeanstalk/;
    description = "A command line interface for Elastic Beanstalk";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.asl20;
  };
}
