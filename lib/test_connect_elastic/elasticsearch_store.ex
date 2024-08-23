defmodule TestConnectElastic.ElasticsearchStore do
  # Module sẽ tuân theo các hàm callback do Elasticsearch.Stire yêu cầu
  @behaviour Elasticsearch.Store

  # import Ecto.Query
  alias Elasticsearch.Client
  alias TestConnectElastic.Repo

  #   Hàm này nhận vào một schema Ecto và sử dụng Repo.stream/1 để trả về một luồng dữ liệu (stream) của các bản ghi từ cơ sở dữ liệu.
  # Luồng này sau đó có thể được sử dụng để truyền dữ liệu vào Elasticsearch. Hàm stream/1 giúp bạn có thể xử lý một số lượng lớn dữ liệu một cách hiệu quả bằng cách lấy từng phần dữ liệu một thay vì lấy toàn bộ cùng lúc.
  @impl true
  def stream(schema) do
    Repo.stream(schema)
  end

  #   Hàm này thực hiện một giao dịch (transaction) trong cơ sở dữ liệu thông qua Repo.transaction/2.
  # Nó nhận một hàm fun (một hàm ẩn danh hoặc module function) làm đối số và thực thi hàm đó trong một transaction. Nếu hàm fun thành công, giao dịch sẽ được commit và kết quả của hàm fun sẽ được trả về. Nếu xảy ra lỗi, giao dịch sẽ bị rollback.
  # timeout: :infinity đảm bảo rằng giao dịch này sẽ không bị timeout, ngay cả khi nó mất nhiều thời gian.
  @impl true
  def transaction(fun) do
    {:ok, result} = Repo.transaction(fun, timeout: :infinity)
    result
  end

  def index_post(%TestConnectElastic.Student{id: id, name: name, age: age}) do
    body = %{
      "name" => name,
      "age" => age
    }

    IO.inspect(body, label: "Sending to Elasticsearch")

    index_name = "students_index"
    response = Elasticsearch.Client.index(index_name, id, body)

    IO.inspect(response, label: "Elasticsearch Response")
  end

  # Hàm để tìm kiếm dữ liệu từ Elasticsearch
  def search(index, query) do
    Client.search(index, query)
  end
end

# Module này đóng vai trò là cầu nối giữa cơ sở dữ liệu Ecto và Elasticsearch. Nó cung cấp cách để bạn có thể:

# Stream dữ liệu từ cơ sở dữ liệu PostgreSQL vào Elasticsearch một cách hiệu quả.
# Thực hiện các giao dịch cơ sở dữ liệu liên quan đến việc đồng bộ hóa dữ liệu với Elasticsearch, đảm bảo tính toàn vẹn của dữ liệu trong cả hai hệ thống.
