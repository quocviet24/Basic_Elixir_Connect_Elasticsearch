defmodule TestConnectElastic.Sync do
  alias TestConnectElastic.Repo
  alias TestConnectElastic.ElasticsearchStore
  alias TestConnectElastic.Student

  def sync_posts_to_elasticsearch do
    students = Repo.all(Student)

    Enum.each(students, fn student ->
      ElasticsearchStore.index_post(student)
    end)
  end

  def search_students_detail(name) do
    query = %{
      "query" => %{
        "match" => %{
          "name" => name
        }
      }
    }

    case ElasticsearchStore.search("students_index", query) do
      {:ok, response} ->
        IO.inspect(response, label: "Elasticsearch Search Response")
        response

      {:error, error} ->
        IO.inspect(error, label: "Elasticsearch Search Error")
        :error
    end
  end

  def search_students(name) do
    query = %{
      "query" => %{
        "match" => %{
          "name" => name
        }
      }
    }

    case ElasticsearchStore.search("students_index", query) do
      {:ok, %{"hits" => %{"hits" => hits}}} ->
        IO.puts("Found documents:")
        Enum.each(hits, fn hit ->
          IO.inspect(hit["_source"], label: "Document")
        end)
        :ok

      {:error, reason} ->
        IO.inspect(reason, label: "Elasticsearch Search Error")
    end
  end
end
