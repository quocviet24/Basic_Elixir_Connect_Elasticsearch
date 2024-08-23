defmodule TestConnectElastic.Controller.StudentController do
  alias TestConnectElastic.DBContext.StudentManage

  def add_student(attrs) do
    case StudentManage.create_student(attrs) do
      {:ok, student} ->
        IO.puts("Student created successfully: #{student.name}")

      {:error, changeset} ->
        IO.puts(changeset.errors, label: "Failed to create student")
    end
  end
end
