{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    ros-overlay.url = "github:lopsided98/nix-ros-overlay";
  };
  outputs = { self, nixpkgs, flake-utils, ros-overlay }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [
            ros-overlay.overlay
          ];
          patched-grid-map-loader = pkgs.rosPackages.noetic.grid-map-loader.overrideAttrs (old: {
            src = pkgs.fetchFromGitHub {
              owner = "2m";
              repo = "grid_map";
              rev = "wip/interface-include-2m";
              hash = "sha256-dLqys4UB05mhkpRhQnyXw7y5AuD6i0jupaT06x2ZnMQ=";
              postFetch = ''
                cp -r "$out/grid_map_loader/." "$out/"
              '';
            };
          });
          pkgs = import nixpkgs {
            inherit system overlays;
            config = {
              allowUnfree = true;
              packageOverrides = pkgs: {
                rosPackages.noetic.grid-map-loader = patched-grid-map-loader;
              };
            };
          };
        in
        with pkgs.rosPackages.noetic;
        {
          devShell = pkgs.mkShell {
            buildInputs = [
              pkgs.glibcLocales
              pkgs.nix
              (buildEnv { paths = [
                ros-base
                tf2-eigen
                tf2-geometry-msgs
                serial
                rosbridge-server
                nmea-msgs
                rtcm-msgs
                mavros-msgs
                rqt-reconfigure
                mbf-costmap-core
                grid-map-msgs
                #grid-map # depends on grid-map-demos which still uses non-patched grid-map-loader
                patched-grid-map-loader
                ublox-msgs
                #imu-tools
                imu-filter-madgwick
                grid-map-cv
                grid-map-ros
                grid-map-filters
                mobile-robot-simulator
                robot-localization
                pcl-conversions
                twist-mux
              ]; })
            ];

            ROS_HOSTNAME = "localhost";
            ROS_MASTER_URI = "http://localhost:11311";
          };
        }
      );
}
