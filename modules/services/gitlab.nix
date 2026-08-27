{
  flake.modules.nixos.gitlab = {config, ...}: {
    age.secrets = {
      gitlab-initial-root-password = {
        file = ../../secrets/gitlab-initial-root-password.age;
        owner = "gitlab";
      };
      gitlab-secret = {
        file = ../../secrets/gitlab-secret.age;
        owner = "gitlab";
      };
      gitlab-db = {
        file = ../../secrets/gitlab-db.age;
        owner = "gitlab";
      };
      gitlab-otp = {
        file = ../../secrets/gitlab-otp.age;
        owner = "gitlab";
      };
      gitlab-jws = {
        file = ../../secrets/gitlab-jws.age;
        owner = "gitlab";
      };
      gitlab-active-record-primary-key = {
        file = ../../secrets/gitlab-active-record-primary-key.age;
        owner = "gitlab";
      };
      gitlab-active-record-deterministic-key = {
        file = ../../secrets/gitlab-active-record-deterministic-key.age;
        owner = "gitlab";
      };
      gitlab-active-record-salt = {
        file = ../../secrets/gitlab-active-record-salt.age;
        owner = "gitlab";
      };
    };

    services.gitlab = {
      enable = true;
      host = "gitlab.tantalus.lan";
      port = 443;
      https = true;

      initialRootEmail = "alucascu@proton.me";
      initialRootPasswordFile = config.age.secrets.gitlab-initial-root-password.path;

      secrets = {
        secretFile = config.age.secrets.gitlab-secret.path;
        dbFile = config.age.secrets.gitlab-db.path;
        otpFile = config.age.secrets.gitlab-otp.path;
        jwsFile = config.age.secrets.gitlab-jws.path;
        activeRecordPrimaryKeyFile = config.age.secrets.gitlab-active-record-primary-key.path;
        activeRecordDeterministicKeyFile = config.age.secrets.gitlab-active-record-deterministic-key.path;
        activeRecordSaltFile = config.age.secrets.gitlab-active-record-salt.path;
      };
    };

    services.caddy.virtualHosts."gitlab.tantalus.lan".extraConfig = ''
      tls internal
      reverse_proxy unix//run/gitlab/gitlab-workhorse.socket
    '';
  };
}
