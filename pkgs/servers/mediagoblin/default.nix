{ lib
, stdenv
, fetchgit
, fetchpatch
, gobject-introspection
, python39
}:

let
  # tests are disabled due to breakages with older flask ecosystem
  python = python39.override {
    packageOverrides = final: prev: {
      alembic = prev.alembic.overridePythonAttrs (old: rec {
        doCheck = false;
      });
      amqp = prev.amqp.overridePythonAttrs (old: rec {
        version = "2.6.1";
        src = old.src.override {
          inherit version;
          hash = "sha256-cM2xBihGj/FOV+wvdRx6qeSOfjZRz9YtQxITwMTljyE=";
        };
        doCheck = false;
      });
      celery = prev.celery.overridePythonAttrs (old: rec {
        version = "4.2.2";
        src = old.src.override {
          inherit version;
          hash = "sha256-sbfamL5rQIKr+m4YKC7ORQJx82a86B0NUhNCoNuGJQY=";
        };
        postPatch = ''
          substituteInPlace requirements/default.txt \
            --replace "billiard>=3.5.0.2,<3.6.0" "billiard" \
            --replace "kombu>=4.2.0,<4.4" "kombu"
        '';

        doCheck = false;
      });
      click = prev.click.overridePythonAttrs (old: rec {
        version = "7.1.2";
        src = old.src.override {
          inherit version;
          hash = "sha256-0rUlXHxjSbwb0eWeCM0SrLvWPOZJ8liHVXg6qU37axo=";
        };
        doCheck = false;
      });
      flask = prev.flask.overridePythonAttrs (old: rec {
        version = "1.1.4";
        src = old.src.override {
          inherit version;
          hash = "sha256-D762GA04OpGG0NbtlU4AQq2fGODo3giLK0GdUmkn0ZY=";
        };
        doCheck = false;
      });
      jinja2 = prev.jinja2.overridePythonAttrs (old: rec {
        version = "2.11.3";
        src = old.src.override {
          inherit version;
          hash = "sha256-ptWEM94K6AA0fKsfowQ867q+i6qdKeZo8cdoy4ejM8Y=";
        };
        doCheck = false;
      });
      itsdangerous = prev.itsdangerous.overridePythonAttrs (old: rec {
        version = "1.1.0";
        src = old.src.override {
          inherit version;
          hash = "sha256-MhsDPQfypBNtPsdi6snxahDM1g9TwMka+QIXrOe6Hxk=";
        };
        doCheck = false;
      });
      kombu = prev.kombu.overridePythonAttrs (old: rec {
        version = "4.3.0";
        src = old.src.override {
          inherit version;
          hash = "sha256-Up354OzAutn8KzdsPOR5bEG0gs9pe3i3GupuvnyjU8g=";
        };
        doCheck = false;
      });
      markupsafe = prev.markupsafe.overridePythonAttrs (old: rec {
        version = "1.1.1";
        src = old.src.override {
          inherit version;
          hash = "sha256-KYcukoOXZeVGgou3dUpoxBjZJ80GT9Rwj6uf6ci7EWs=";
        };
        doCheck = false;
      });
      # moto = prev.moto.overridePythonAttrs (old: rec {
      #   # tests take a good amount of time
      #   doCheck = false;
      # });
      # sphinx = prev.sphinx.overridePythonAttrs (old: rec {
      #   doCheck = false;
      # });
      sqlalchemy = prev.sqlalchemy.overridePythonAttrs (old: rec {
        version = "1.3.24";
        src = old.src.override {
          inherit version;
          hash = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };
        doCheck = false;
      });
      twisted = prev.twisted.overridePythonAttrs (old: rec {
        # tests take a good amount of time
        doCheck = false;
      });
      vine = prev.vine.overridePythonAttrs (old: rec {
        version = "1.3.0";
        src = old.src.override {
          inherit version;
          hash = "sha256-Ez7m16kBbxd93q8ZHB9YQhodzG7ppCxYs0vtQOHSzYc=";
        };
        doCheck = false;
      });
      werkzeug = prev.werkzeug.overridePythonAttrs (old: rec {
        version = "1.0.1";
        src = old.src.override {
          inherit version;
          hash = "sha256-bICx5a02ZSkOo5MguR4b4eDV9gZSuWSjBwIW3oPS5Hw=";
        };
        doCheck = false;
      });
      wtforms = prev.wtforms.overridePythonAttrs (old: rec {
        version = "2.3.3";
        src = old.src.override {
          inherit version;
          hash = "sha256-gRld4KyU+8g2iruvkZe4jE8//WwnGbW/X8nadE89gpw=";
        };
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "mediagoblin";
  version = "0.12.0";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/mediagoblin.git";
    # rev = "v${version}";
    # sha256 = "sha256-hLbRKJyQKwRoT6HXZb7koxhucf0AW+sc7Hg9bSkt5kg=";
    sha256 = "sha256-OwLHi4MhraW1EVD9f4jaC7a25jSOrtuFkNSdimD0zew=";
  };

  # patches = [
  #   (fetchpatch {
  #     url = "https://git.savannah.gnu.org/cgit/mediagoblin.git/patch/?id=fe01dd00fbebbf46f8cab552b89c402124541cab";
  #     excludes = [ "docs/source/siteadmin/relnotes.rst" ];
  #     sha256 = "sha256-66A7FA1bGpTE/qHx9RmPPw4CKU+9gvrWJR1IiblO6yY=";
  #   })
  # ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "celery>=3.0,<4.3.0" "celery"
  '';

  nativeBuildInputs = with python.pkgs; [
    babel
    setuptools
  ];

  buildInputs = with python.pkgs; [
    alembic
    # babel
    bcrypt
    celery
    certifi
    configobj
    email-validator
    exifread
    feedgenerator
    itsdangerous
    jinja2
    jsonschema
    lxml
    markdown
    oauthlib
    pastescript
    pillow
    pyld
    python-dateutil
    pytz
    requests
    soundfile
    sphinx
    sqlalchemy
    unidecode
    waitress
    werkzeug
    wtforms

    pygobject3
  ];

  # postBuild = ''
  #   ./devtools/compile_translations.sh
  # '';

  checkInputs = with python.pkgs; [
    gobject-introspection
    gst-python
    pytest-xdist
    pytestCheckHook
    webtest
  ];

  meta = with lib; {
    description = "Free media publishing platform";
    homepage = "https://mediagoblin.org/";
    license = licenses.agpl3;
    # maintainers = teams.c3d2.members;
  };
}
