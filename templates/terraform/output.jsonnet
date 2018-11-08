local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();

{
  data: {
    template_file: {
      readme: {
        template: kap.jinja2_template('templates/terraform/README.md.j2', inv),
      },
    },
  },

  output: {
    'README.md': {
      value: '${data.template_file.readme.rendered}',
      sensitive: true,
    },
    client_certificate: {
      value: '${google_container_cluster.cluster1.master_auth.0.client_certificate}',
    },
    client_key: {
      value: '${google_container_cluster.cluster1.master_auth.0.client_key}',
    },
    cluster_ca_certificate: {
      value: '${google_container_cluster.cluster1.master_auth.0.cluster_ca_certificate}',
    },
  },

}
