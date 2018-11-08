local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();


{
  add_logging(service)::
  {
      "driver": inv.parameters.docker_compose.logging.driver,
      "options": {
        "fluentd-address": inv.parameters.docker_compose.logging.options.fluentd,
        "tag": "motherbase." + service,
      },
  },


  docker_compose: {
      version: inv.parameters.docker_compose.version,
    services: {
      [service]: set {
       #[if inv.parameters.docker_compose.services[service].logging then "logging"]: $.add_logging(service)
       [if true then "logging"]: $.add_logging(service)
      }
      for service in std.objectFields(inv.parameters.docker_compose.services)
      for set in inv.parameters.docker_compose.services[service]
    },
  },
}