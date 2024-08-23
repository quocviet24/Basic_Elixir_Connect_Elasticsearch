defmodule TestConnectElastic.ElasticsearchCluster do
  use Elasticsearch.Cluster, otp_app: :test_connect_elastic
end
