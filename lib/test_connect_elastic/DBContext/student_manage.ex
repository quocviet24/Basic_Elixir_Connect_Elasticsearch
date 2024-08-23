defmodule TestConnectElastic.DBContext.StudentManage do
  # alias là một tham chiếu ngắn gọn đến một module
  # Ví dụ nếu không dùng alias mỗi lần sử dụng function của Repo chúng ta phải viết dài như này : TestConnectElastic.Repo.all(TestConnectElastic.Student)
  # Nhưng nếu dùng alias thì ta có thể viết ngắn gọn như sau : Repo.all(Student)
  alias TestConnectElastic.{Repo, Student}

  def create_student(attribute) do
    %Student{}
    |> Student.changeset(attribute)
    |> Repo.insert()
  end
end
